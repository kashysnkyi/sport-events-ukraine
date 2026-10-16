using Dapper;
using SportsEvents.Data;

DefaultTypeMap.MatchNamesWithUnderscores = true;

var connectionString = Environment.GetEnvironmentVariable("SPORTS_DB");
if (string.IsNullOrWhiteSpace(connectionString))
{
    var password = ReadSecret("Пароль postgres для sports_events: ");
    var builder = new Npgsql.NpgsqlConnectionStringBuilder
    {
        Host = "127.0.0.1",
        Port = 5432,
        Database = "sports_events",
        Username = "postgres",
        Password = password
    };
    connectionString = builder.ConnectionString;
}

if (args.Length == 0 || args[0] == "list")
{
    await using var uow = new SportsUnitOfWork(connectionString);
    await uow.BeginAsync();
    try
    {
        var events = await uow.Events.ListPublishedAsync(DateTimeOffset.UtcNow, DateTimeOffset.UtcNow.AddYears(2), CancellationToken.None);
        foreach (var item in events)
            Console.WriteLine($"{item.Id} | {item.Name} | {item.StartsAt:g} | {item.SportName} | {item.VenueName}, {item.VenueCity}");
        await uow.CommitAsync();
    }
    catch
    {
        await uow.RollbackAsync();
        throw;
    }
    return 0;
}

if (args[0] == "register" && args.Length == 4)
{
    var categoryId = Guid.Parse(args[1]);
    var athleteId = Guid.Parse(args[2]);
    var actorId = Guid.Parse(args[3]);
    await using var uow = new SportsUnitOfWork(connectionString);
    await uow.BeginAsync();
    try
    {
        var registrationId = await uow.Registrations.RegisterAthleteAsync(categoryId, athleteId, actorId, CancellationToken.None);
        await uow.CommitAsync();
        Console.WriteLine($"Registration created: {registrationId}");
    }
    catch
    {
        await uow.RollbackAsync();
        throw;
    }
    return 0;
}

if (args[0] == "cancel" && args.Length == 3)
{
    var registrationId = Guid.Parse(args[1]);
    var actorId = Guid.Parse(args[2]);
    await using var uow = new SportsUnitOfWork(connectionString);
    await uow.BeginAsync();
    try
    {
        var cancelled = await uow.Registrations.CancelAsync(registrationId, actorId, CancellationToken.None);
        await uow.CommitAsync();
        Console.WriteLine(cancelled ? "Registration cancelled." : "Registration was not found.");
    }
    catch
    {
        await uow.RollbackAsync();
        throw;
    }
    return 0;
}

Console.WriteLine("Commands: list | register <categoryId> <athleteId> <actorId> | cancel <registrationId> <actorId>");
return 1;

static string ReadSecret(string prompt)
{
    Console.Write(prompt);
    var value = new System.Text.StringBuilder();
    while (true)
    {
        var key = Console.ReadKey(true);
        if (key.Key == ConsoleKey.Enter)
        {
            Console.WriteLine();
            return value.ToString();
        }
        if (key.Key == ConsoleKey.Backspace && value.Length > 0)
        {
            value.Length--;
            Console.Write("\b \b");
            continue;
        }
        if (!char.IsControl(key.KeyChar))
        {
            value.Append(key.KeyChar);
            Console.Write('*');
        }
    }
}
