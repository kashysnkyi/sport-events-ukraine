using System.Data;
using Dapper;
using Npgsql;

namespace SportsEvents.Data;

public sealed record EventListItem(Guid Id, string Name, string? Description,
    DateTime StartsAt, DateTime EndsAt, DateTime? RegistrationDeadline,
    int? Capacity, string Status, string SportName, string VenueName, string VenueCity,
    Guid SportId, Guid VenueId, Guid OrganizerId, DateTime LastModifiedAt);
public sealed record CreateEvent(Guid SportId, Guid VenueId, Guid OrganizerId, string Name,
    DateTimeOffset StartsAt, DateTimeOffset EndsAt, int? Capacity, string? Description,
    DateTimeOffset? RegistrationDeadline);
public sealed record EventCategory(Guid Id, Guid EventId, string Code, string Name, long ConfirmedAthletes, int? Capacity);
public sealed record EventResult(Guid EventId, string EventName, string CompetitionName,
    Guid MatchId, int RoundNo, DateTime? ScheduledAt, string? ScoreSummary, Guid? WinnerParticipantId);

public interface IEventRepository
{
    Task<IReadOnlyList<EventListItem>> ListPublishedAsync(DateTimeOffset from, DateTimeOffset to, CancellationToken ct);
    Task<Guid> CreateAsync(CreateEvent input, CancellationToken ct);
    Task<bool> PublishAsync(Guid eventId, Guid actorId, CancellationToken ct);
    Task<Guid> AddCategoryAsync(Guid eventId, string code, string name, int? capacity, Guid actorId, CancellationToken ct);
    Task<IReadOnlyList<EventCategory>> GetCategoriesAsync(Guid eventId, CancellationToken ct);
    Task<IReadOnlyList<EventResult>> GetResultsAsync(Guid eventId, CancellationToken ct);
}

public interface IRegistrationRepository
{
    Task<Guid> RegisterAthleteAsync(Guid categoryId, Guid athleteId, Guid actorId, CancellationToken ct);
    Task<bool> CancelAsync(Guid registrationId, Guid actorId, CancellationToken ct);
}

public interface IUnitOfWork : IAsyncDisposable
{
    IEventRepository Events { get; }
    IRegistrationRepository Registrations { get; }
    Task BeginAsync(CancellationToken ct = default);
    Task CommitAsync(CancellationToken ct = default);
    Task RollbackAsync(CancellationToken ct = default);
}

public sealed class SportsUnitOfWork : IUnitOfWork
{
    private readonly NpgsqlConnection _connection;
    private NpgsqlTransaction? _transaction;
    public IEventRepository Events { get; }
    public IRegistrationRepository Registrations { get; }

    public SportsUnitOfWork(string connectionString)
    {
        var builder = new NpgsqlConnectionStringBuilder(connectionString) { SearchPath = "sports,public" };
        _connection = new NpgsqlConnection(builder.ConnectionString);
        Events = new EventRepository(_connection, () => _transaction);
        Registrations = new RegistrationRepository(_connection, () => _transaction);
    }

    public async Task BeginAsync(CancellationToken ct = default)
    {
        if (_transaction is not null) throw new InvalidOperationException("Transaction already started.");
        await _connection.OpenAsync(ct);
        _transaction = await _connection.BeginTransactionAsync(ct);
    }
    public async Task CommitAsync(CancellationToken ct = default)
    {
        if (_transaction is null) throw new InvalidOperationException("No active transaction.");
        await _transaction.CommitAsync(ct);
        await _transaction.DisposeAsync(); _transaction = null;
    }
    public async Task RollbackAsync(CancellationToken ct = default)
    {
        if (_transaction is null) return;
        await _transaction.RollbackAsync(ct);
        await _transaction.DisposeAsync(); _transaction = null;
    }
    public async ValueTask DisposeAsync()
    {
        if (_transaction is not null) await RollbackAsync();
        await _connection.DisposeAsync();
    }
}

internal sealed class EventRepository(NpgsqlConnection connection, Func<NpgsqlTransaction?> transaction) : IEventRepository
{
    private NpgsqlTransaction? Tx => transaction();

    public async Task<IReadOnlyList<EventListItem>> ListPublishedAsync(DateTimeOffset from, DateTimeOffset to, CancellationToken ct)
    {
        var rows = await connection.QueryAsync<EventListItem>(new CommandDefinition(
            "select * from sports.fn_list_events(@from_at, @to_at)", new { from_at = from, to_at = to }, Tx, cancellationToken: ct));
        return rows.AsList();
    }

    public async Task<Guid> CreateAsync(CreateEvent input, CancellationToken ct)
    {
        await connection.ExecuteScalarAsync<string>(new CommandDefinition(
            "select set_config('app.current_user_id', @OrganizerId::text, true)", input, Tx, cancellationToken: ct));
        return await connection.ExecuteScalarAsync<Guid>(new CommandDefinition(
            "select sports.fn_create_event(@SportId,@VenueId,@OrganizerId,@Name,@StartsAt,@EndsAt,@Capacity,@Description,@RegistrationDeadline)",
            input, Tx, cancellationToken: ct));
    }

    public Task<bool> PublishAsync(Guid eventId, Guid actorId, CancellationToken ct) => connection.ExecuteScalarAsync<bool>(new CommandDefinition(
        "select sports.fn_publish_event(@event_id,@actor_id)", new { event_id = eventId, actor_id = actorId }, Tx, cancellationToken: ct));

    public Task<Guid> AddCategoryAsync(Guid eventId, string code, string name, int? capacity, Guid actorId, CancellationToken ct) =>
        connection.ExecuteScalarAsync<Guid>(new CommandDefinition(
            "select sports.fn_add_event_category(@event_id,@code,@name,@capacity,@actor_id)",
            new { event_id = eventId, code, name, capacity, actor_id = actorId }, Tx, cancellationToken: ct));

    public async Task<IReadOnlyList<EventCategory>> GetCategoriesAsync(Guid eventId, CancellationToken ct)
    {
        var rows = await connection.QueryAsync<EventCategory>(new CommandDefinition(
            "select id,event_id,code,name,confirmed_athletes,capacity from sports.v_event_categories " +
            "where event_id=@event_id order by name",
            new { event_id = eventId }, Tx, cancellationToken: ct));
        return rows.AsList();
    }

    public async Task<IReadOnlyList<EventResult>> GetResultsAsync(Guid eventId, CancellationToken ct)
    {
        var rows = await connection.QueryAsync<EventResult>(new CommandDefinition(
            "select * from sports.v_event_results where event_id=@event_id order by round_no,scheduled_at",
            new { event_id = eventId }, Tx, cancellationToken: ct));
        return rows.AsList();
    }
}

internal sealed class RegistrationRepository(NpgsqlConnection connection, Func<NpgsqlTransaction?> transaction) : IRegistrationRepository
{
    public Task<Guid> RegisterAthleteAsync(Guid categoryId, Guid athleteId, Guid actorId, CancellationToken ct) =>
        connection.ExecuteScalarAsync<Guid>(new CommandDefinition(
            "select sports.fn_register_athlete(@category_id,@athlete_id,@actor_id)",
            new { category_id = categoryId, athlete_id = athleteId, actor_id = actorId }, transaction(), cancellationToken: ct));

    public Task<bool> CancelAsync(Guid registrationId, Guid actorId, CancellationToken ct) =>
        connection.ExecuteScalarAsync<bool>(new CommandDefinition(
            "select sports.fn_cancel_registration(@registration_id,@actor_id)",
            new { registration_id = registrationId, actor_id = actorId }, transaction(), cancellationToken: ct));
}

public static class EventWorkflow
{
    public static async Task<Guid> CreateAndPublishAsync(IUnitOfWork uow, CreateEvent request,
        string categoryCode, string categoryName, CancellationToken ct)
    {
        await uow.BeginAsync(ct);
        try
        {
            var eventId = await uow.Events.CreateAsync(request, ct);
            await uow.Events.AddCategoryAsync(eventId, categoryCode, categoryName, request.Capacity, request.OrganizerId, ct);
            if (!await uow.Events.PublishAsync(eventId, request.OrganizerId, ct))
                throw new InvalidOperationException("Event was not published; create at least one active category and use draft status.");
            await uow.CommitAsync(ct);
            return eventId;
        }
        catch
        {
            await uow.RollbackAsync(ct);
            throw;
        }
    }
}


