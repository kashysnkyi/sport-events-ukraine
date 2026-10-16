CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE SCHEMA IF NOT EXISTS sports;
SET search_path = sports, public;

CREATE TABLE app_user (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(), email varchar(320) NOT NULL UNIQUE,
  display_name varchar(160) NOT NULL, role varchar(30) NOT NULL CHECK (role IN ('admin','organizer','athlete')),
  created_at timestamptz NOT NULL DEFAULT now(), deleted_at timestamptz
);
CREATE TABLE sport (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(), name varchar(100) NOT NULL UNIQUE, description text,
  created_at timestamptz NOT NULL DEFAULT now(), last_modified_at timestamptz NOT NULL DEFAULT now(), last_modified_by uuid REFERENCES app_user(id), deleted_at timestamptz
);
CREATE TABLE venue (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(), name varchar(160) NOT NULL, address text NOT NULL, city varchar(100) NOT NULL,
  capacity int CHECK (capacity IS NULL OR capacity > 0), created_at timestamptz NOT NULL DEFAULT now(),
  last_modified_at timestamptz NOT NULL DEFAULT now(), last_modified_by uuid REFERENCES app_user(id), deleted_at timestamptz
);
CREATE TABLE sport_event (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(), sport_id uuid NOT NULL REFERENCES sport(id) ON DELETE RESTRICT,
  venue_id uuid NOT NULL REFERENCES venue(id) ON DELETE RESTRICT, organizer_id uuid NOT NULL REFERENCES app_user(id) ON DELETE RESTRICT,
  name varchar(200) NOT NULL, description text, starts_at timestamptz NOT NULL, ends_at timestamptz NOT NULL,
  registration_deadline timestamptz, capacity int CHECK (capacity IS NULL OR capacity > 0),
  status varchar(20) NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','published','cancelled','completed')),
  created_at timestamptz NOT NULL DEFAULT now(), last_modified_at timestamptz NOT NULL DEFAULT now(),
  last_modified_by uuid REFERENCES app_user(id), deleted_at timestamptz,
  CHECK (ends_at > starts_at), CHECK (registration_deadline IS NULL OR registration_deadline <= starts_at)
);
CREATE TABLE event_category (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(), event_id uuid NOT NULL REFERENCES sport_event(id) ON DELETE RESTRICT,
  code varchar(40) NOT NULL, name varchar(120) NOT NULL, min_age int CHECK (min_age IS NULL OR min_age >= 0),
  max_age int CHECK (max_age IS NULL OR max_age >= 0), capacity int CHECK (capacity IS NULL OR capacity > 0),
  created_at timestamptz NOT NULL DEFAULT now(), last_modified_at timestamptz NOT NULL DEFAULT now(),
  last_modified_by uuid REFERENCES app_user(id), deleted_at timestamptz,
  UNIQUE(event_id, code), CHECK (max_age IS NULL OR min_age IS NULL OR max_age >= min_age)
);
CREATE TABLE athlete_profile (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(), user_id uuid NOT NULL UNIQUE REFERENCES app_user(id) ON DELETE RESTRICT,
  birth_date date, country_code char(2), created_at timestamptz NOT NULL DEFAULT now(),
  last_modified_at timestamptz NOT NULL DEFAULT now(), last_modified_by uuid REFERENCES app_user(id), deleted_at timestamptz
);
CREATE TABLE team (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(), name varchar(160) NOT NULL, owner_id uuid NOT NULL REFERENCES app_user(id) ON DELETE RESTRICT,
  created_at timestamptz NOT NULL DEFAULT now(), last_modified_at timestamptz NOT NULL DEFAULT now(),
  last_modified_by uuid REFERENCES app_user(id), deleted_at timestamptz
);
CREATE TABLE team_member (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(), team_id uuid NOT NULL REFERENCES team(id) ON DELETE RESTRICT,
  athlete_id uuid NOT NULL REFERENCES athlete_profile(id) ON DELETE RESTRICT,
  member_role varchar(30) NOT NULL DEFAULT 'member', joined_at timestamptz NOT NULL DEFAULT now(), left_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(), last_modified_at timestamptz NOT NULL DEFAULT now(),
  last_modified_by uuid REFERENCES app_user(id), deleted_at timestamptz, UNIQUE(team_id, athlete_id), CHECK(left_at IS NULL OR left_at >= joined_at)
);
CREATE TABLE event_registration (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(), category_id uuid NOT NULL REFERENCES event_category(id) ON DELETE RESTRICT,
  athlete_id uuid NOT NULL REFERENCES athlete_profile(id) ON DELETE RESTRICT,
  status varchar(20) NOT NULL DEFAULT 'pending' CHECK(status IN ('pending','confirmed','rejected','cancelled')),
  registered_at timestamptz NOT NULL DEFAULT now(), created_at timestamptz NOT NULL DEFAULT now(),
  last_modified_at timestamptz NOT NULL DEFAULT now(), last_modified_by uuid REFERENCES app_user(id), deleted_at timestamptz,
  UNIQUE(category_id, athlete_id)
);
CREATE TABLE event_team_entry (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(), category_id uuid NOT NULL REFERENCES event_category(id) ON DELETE RESTRICT,
  team_id uuid NOT NULL REFERENCES team(id) ON DELETE RESTRICT,
  status varchar(20) NOT NULL DEFAULT 'pending' CHECK(status IN ('pending','confirmed','rejected','cancelled')),
  registered_at timestamptz NOT NULL DEFAULT now(), created_at timestamptz NOT NULL DEFAULT now(),
  last_modified_at timestamptz NOT NULL DEFAULT now(), last_modified_by uuid REFERENCES app_user(id), deleted_at timestamptz,
  UNIQUE(category_id, team_id)
);
CREATE TABLE competition (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(), event_id uuid NOT NULL REFERENCES sport_event(id) ON DELETE RESTRICT,
  category_id uuid REFERENCES event_category(id) ON DELETE RESTRICT, name varchar(160) NOT NULL,
  format varchar(30) NOT NULL CHECK(format IN ('single_elimination','round_robin','time_trial','custom')),
  status varchar(20) NOT NULL DEFAULT 'planned' CHECK(status IN ('planned','active','completed','cancelled')),
  created_at timestamptz NOT NULL DEFAULT now(), last_modified_at timestamptz NOT NULL DEFAULT now(),
  last_modified_by uuid REFERENCES app_user(id), deleted_at timestamptz
);
CREATE TABLE match (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(), competition_id uuid NOT NULL REFERENCES competition(id) ON DELETE RESTRICT,
  round_no int NOT NULL CHECK(round_no > 0), scheduled_at timestamptz,
  status varchar(20) NOT NULL DEFAULT 'scheduled' CHECK(status IN ('scheduled','in_progress','completed','cancelled')),
  created_at timestamptz NOT NULL DEFAULT now(), last_modified_at timestamptz NOT NULL DEFAULT now(),
  last_modified_by uuid REFERENCES app_user(id), deleted_at timestamptz
);
CREATE TABLE match_participant (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(), match_id uuid NOT NULL REFERENCES match(id) ON DELETE RESTRICT,
  athlete_id uuid REFERENCES athlete_profile(id) ON DELETE RESTRICT, team_id uuid REFERENCES team(id) ON DELETE RESTRICT,
  lane_no int CHECK(lane_no IS NULL OR lane_no > 0), created_at timestamptz NOT NULL DEFAULT now(),
  last_modified_at timestamptz NOT NULL DEFAULT now(), last_modified_by uuid REFERENCES app_user(id), deleted_at timestamptz,
  CHECK ((athlete_id IS NOT NULL)::int + (team_id IS NOT NULL)::int = 1),
  UNIQUE(match_id, athlete_id), UNIQUE(match_id, team_id)
);
CREATE TABLE match_result (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(), match_id uuid NOT NULL UNIQUE REFERENCES match(id) ON DELETE RESTRICT,
  winner_participant_id uuid REFERENCES match_participant(id) ON DELETE RESTRICT, score_summary varchar(500),
  recorded_by uuid NOT NULL REFERENCES app_user(id) ON DELETE RESTRICT, recorded_at timestamptz NOT NULL DEFAULT now(),
  created_at timestamptz NOT NULL DEFAULT now(), last_modified_at timestamptz NOT NULL DEFAULT now(),
  last_modified_by uuid REFERENCES app_user(id), deleted_at timestamptz
);
CREATE TABLE sponsor (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(), name varchar(160) NOT NULL UNIQUE, website text,
  created_at timestamptz NOT NULL DEFAULT now(), last_modified_at timestamptz NOT NULL DEFAULT now(),
  last_modified_by uuid REFERENCES app_user(id), deleted_at timestamptz
);
CREATE TABLE event_sponsor (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(), event_id uuid NOT NULL REFERENCES sport_event(id) ON DELETE RESTRICT,
  sponsor_id uuid NOT NULL REFERENCES sponsor(id) ON DELETE RESTRICT, contribution_type varchar(40) NOT NULL,
  contribution_amount numeric(12,2) CHECK(contribution_amount IS NULL OR contribution_amount >= 0),
  created_at timestamptz NOT NULL DEFAULT now(), last_modified_at timestamptz NOT NULL DEFAULT now(),
  last_modified_by uuid REFERENCES app_user(id), deleted_at timestamptz, UNIQUE(event_id, sponsor_id)
);
CREATE TABLE audit_log (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY, table_name varchar(63) NOT NULL, row_id uuid NOT NULL,
  operation char(1) NOT NULL CHECK(operation IN ('I','U','D')), changed_at timestamptz NOT NULL DEFAULT now(),
  changed_by uuid REFERENCES app_user(id) ON DELETE SET NULL, old_data jsonb, new_data jsonb
);

CREATE OR REPLACE VIEW v_active_events AS
SELECT e.id, e.name, e.description, e.starts_at, e.ends_at, e.registration_deadline, e.capacity, e.status,
       s.name AS sport_name, v.name AS venue_name, v.city AS venue_city,
       e.sport_id, e.venue_id, e.organizer_id, e.last_modified_at
FROM sport_event e JOIN sport s ON s.id=e.sport_id AND s.deleted_at IS NULL
JOIN venue v ON v.id=e.venue_id AND v.deleted_at IS NULL
WHERE e.deleted_at IS NULL;

CREATE OR REPLACE VIEW v_event_registration_counts AS
SELECT c.id AS category_id, c.event_id, c.code, c.name,
       count(r.id) FILTER (WHERE r.status='confirmed' AND r.deleted_at IS NULL) AS confirmed_athletes,
       c.capacity
FROM event_category c LEFT JOIN event_registration r ON r.category_id=c.id
WHERE c.deleted_at IS NULL GROUP BY c.id;

CREATE OR REPLACE VIEW v_event_categories AS
SELECT c.id,c.event_id,c.code,c.name,c.min_age,c.max_age,c.capacity,c.last_modified_at,
       coalesce(rc.confirmed_athletes,0) AS confirmed_athletes
FROM event_category c LEFT JOIN v_event_registration_counts rc ON rc.category_id=c.id
WHERE c.deleted_at IS NULL;

CREATE OR REPLACE VIEW v_event_results AS
SELECT e.id AS event_id, e.name AS event_name, co.name AS competition_name, m.id AS match_id,
       m.round_no, m.scheduled_at, mr.score_summary, mr.winner_participant_id
FROM sport_event e JOIN competition co ON co.event_id=e.id AND co.deleted_at IS NULL
JOIN match m ON m.competition_id=co.id AND m.deleted_at IS NULL
LEFT JOIN match_result mr ON mr.match_id=m.id AND mr.deleted_at IS NULL
WHERE e.deleted_at IS NULL;

CREATE INDEX ix_event_status_start ON sport_event(status, starts_at) WHERE deleted_at IS NULL;
CREATE INDEX ix_event_name_trgm ON sport_event USING gin(name gin_trgm_ops) WHERE deleted_at IS NULL;
CREATE INDEX ix_registration_athlete ON event_registration(athlete_id, registered_at DESC) WHERE deleted_at IS NULL;
CREATE INDEX ix_team_member_athlete ON team_member(athlete_id) WHERE deleted_at IS NULL;
CREATE INDEX ix_match_competition_round ON match(competition_id, round_no) WHERE deleted_at IS NULL;
CREATE INDEX ix_audit_row_time ON audit_log(table_name, row_id, changed_at DESC);

CREATE OR REPLACE FUNCTION fn_touch_and_audit() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE actor uuid; oldj jsonb; newj jsonb; rowid uuid;
BEGIN
  BEGIN actor := nullif(current_setting('app.current_user_id', true), '')::uuid;
  EXCEPTION WHEN invalid_text_representation THEN actor := NULL; END;
  IF TG_OP = 'DELETE' THEN
    oldj := to_jsonb(OLD); rowid := (oldj->>'id')::uuid;
    INSERT INTO audit_log(table_name,row_id,operation,changed_by,old_data) VALUES(TG_TABLE_NAME,rowid,'D',actor,oldj);
    RETURN OLD;
  ELSIF TG_OP = 'UPDATE' THEN
    oldj := to_jsonb(OLD);
    newj := jsonb_populate_record(NEW, jsonb_build_object('last_modified_at',now(),'last_modified_by',actor))::jsonb;
    NEW := jsonb_populate_record(NEW,newj);
    rowid := (to_jsonb(NEW)->>'id')::uuid;
    INSERT INTO audit_log(table_name,row_id,operation,changed_by,old_data,new_data) VALUES(TG_TABLE_NAME,rowid,'U',actor,oldj,to_jsonb(NEW));
    RETURN NEW;
  ELSE
    newj := to_jsonb(NEW);
    INSERT INTO audit_log(table_name,row_id,operation,changed_by,new_data) VALUES(TG_TABLE_NAME,(newj->>'id')::uuid,'I',actor,newj);
    RETURN NEW;
  END IF;
END $$;

DO $$
DECLARE t text;
BEGIN
  FOREACH t IN ARRAY ARRAY['sport','venue','sport_event','event_category','athlete_profile','team','team_member',
    'event_registration','event_team_entry','competition','match','match_participant','match_result','sponsor','event_sponsor']
  LOOP
    EXECUTE format('DROP TRIGGER IF EXISTS %I_audit ON %I', t, t);
    EXECUTE format('CREATE TRIGGER %I_audit BEFORE INSERT OR UPDATE OR DELETE ON %I FOR EACH ROW EXECUTE FUNCTION fn_touch_and_audit()', t, t);
  END LOOP;
END $$;

CREATE OR REPLACE FUNCTION fn_create_event(
  p_sport_id uuid, p_venue_id uuid, p_organizer_id uuid, p_name text,
  p_starts_at timestamptz, p_ends_at timestamptz, p_capacity int DEFAULT NULL,
  p_description text DEFAULT NULL, p_registration_deadline timestamptz DEFAULT NULL
) RETURNS uuid LANGUAGE plpgsql AS $$
DECLARE new_id uuid;
BEGIN
  INSERT INTO sport_event(sport_id,venue_id,organizer_id,name,starts_at,ends_at,capacity,description,registration_deadline)
  VALUES(p_sport_id,p_venue_id,p_organizer_id,p_name,p_starts_at,p_ends_at,p_capacity,p_description,p_registration_deadline)
  RETURNING id INTO new_id;
  RETURN new_id;
END $$;

CREATE OR REPLACE FUNCTION fn_register_athlete(p_category_id uuid, p_athlete_id uuid, p_actor_id uuid)
RETURNS uuid LANGUAGE plpgsql AS $$
DECLARE new_id uuid; event_status text; deadline timestamptz; category_capacity int; used_count bigint;
BEGIN
  PERFORM set_config('app.current_user_id',p_actor_id::text,true);
  SELECT e.status,e.registration_deadline,c.capacity INTO event_status,deadline,category_capacity
  FROM event_category c JOIN sport_event e ON e.id=c.event_id
  WHERE c.id=p_category_id AND c.deleted_at IS NULL AND e.deleted_at IS NULL FOR UPDATE OF c,e;
  IF NOT FOUND THEN RAISE EXCEPTION 'Category/event not found or deleted'; END IF;
  IF event_status <> 'published' THEN RAISE EXCEPTION 'Registration requires a published event'; END IF;
  IF deadline IS NOT NULL AND now() > deadline THEN RAISE EXCEPTION 'Registration deadline passed'; END IF;
  SELECT count(*) INTO used_count FROM event_registration WHERE category_id=p_category_id AND status='confirmed' AND deleted_at IS NULL;
  IF category_capacity IS NOT NULL AND used_count >= category_capacity THEN RAISE EXCEPTION 'Category is full'; END IF;
  INSERT INTO event_registration(category_id,athlete_id,status,last_modified_by)
  VALUES(p_category_id,p_athlete_id,'confirmed',p_actor_id) RETURNING id INTO new_id;
  RETURN new_id;
END $$;

CREATE OR REPLACE FUNCTION fn_cancel_registration(p_registration_id uuid, p_actor_id uuid)
RETURNS boolean LANGUAGE plpgsql AS $$
BEGIN
  PERFORM set_config('app.current_user_id',p_actor_id::text,true);
  UPDATE event_registration SET status='cancelled', deleted_at=now(), last_modified_by=p_actor_id
    WHERE id=p_registration_id AND deleted_at IS NULL;
  RETURN FOUND;
END $$;

CREATE OR REPLACE FUNCTION fn_publish_event(p_event_id uuid, p_actor_id uuid)
RETURNS boolean LANGUAGE plpgsql AS $$
BEGIN
  PERFORM set_config('app.current_user_id',p_actor_id::text,true);
  UPDATE sport_event SET status='published',last_modified_by=p_actor_id
  WHERE id=p_event_id AND deleted_at IS NULL AND status='draft'
    AND EXISTS (SELECT 1 FROM event_category c WHERE c.event_id=p_event_id AND c.deleted_at IS NULL);
  RETURN FOUND;
END $$;

CREATE OR REPLACE FUNCTION fn_soft_delete_event(p_event_id uuid, p_actor_id uuid)
RETURNS boolean LANGUAGE plpgsql AS $$
BEGIN
  PERFORM set_config('app.current_user_id',p_actor_id::text,true);
  UPDATE sport_event SET deleted_at=now(),last_modified_by=p_actor_id
    WHERE id=p_event_id AND deleted_at IS NULL;
  RETURN FOUND;
END $$;

CREATE OR REPLACE FUNCTION fn_list_events(p_from timestamptz DEFAULT now(), p_to timestamptz DEFAULT now()+interval '1 year')
RETURNS SETOF v_active_events LANGUAGE sql STABLE AS $$
  SELECT * FROM v_active_events WHERE status='published' AND starts_at >= p_from AND starts_at < p_to ORDER BY starts_at
$$;

CREATE OR REPLACE FUNCTION fn_add_event_category(p_event_id uuid,p_code text,p_name text,p_capacity int DEFAULT NULL,p_actor_id uuid DEFAULT NULL)
RETURNS uuid LANGUAGE plpgsql AS $$
DECLARE new_id uuid;
BEGIN
  IF p_actor_id IS NOT NULL THEN PERFORM set_config('app.current_user_id',p_actor_id::text,true); END IF;
  INSERT INTO event_category(event_id,code,name,capacity,last_modified_by) VALUES(p_event_id,p_code,p_name,p_capacity,p_actor_id)
  RETURNING id INTO new_id; RETURN new_id;
END $$;

CREATE OR REPLACE FUNCTION fn_create_competition(p_event_id uuid,p_category_id uuid,p_name text,p_format text,p_actor_id uuid)
RETURNS uuid LANGUAGE plpgsql AS $$
DECLARE new_id uuid;
BEGIN
  PERFORM set_config('app.current_user_id',p_actor_id::text,true);
  INSERT INTO competition(event_id,category_id,name,format,last_modified_by) VALUES(p_event_id,p_category_id,p_name,p_format,p_actor_id)
  RETURNING id INTO new_id; RETURN new_id;
END $$;

CREATE OR REPLACE FUNCTION fn_create_match(p_competition_id uuid,p_round int,p_scheduled_at timestamptz,p_actor_id uuid)
RETURNS uuid LANGUAGE plpgsql AS $$
DECLARE new_id uuid;
BEGIN
  PERFORM set_config('app.current_user_id',p_actor_id::text,true);
  INSERT INTO match(competition_id,round_no,scheduled_at,last_modified_by) VALUES(p_competition_id,p_round,p_scheduled_at,p_actor_id)
  RETURNING id INTO new_id; RETURN new_id;
END $$;

CREATE OR REPLACE FUNCTION fn_record_result(p_match_id uuid,p_winner_participant_id uuid,p_score text,p_actor_id uuid)
RETURNS uuid LANGUAGE plpgsql AS $$
DECLARE new_id uuid;
BEGIN
  PERFORM set_config('app.current_user_id',p_actor_id::text,true);
  IF p_winner_participant_id IS NOT NULL AND NOT EXISTS(SELECT 1 FROM match_participant WHERE id=p_winner_participant_id AND match_id=p_match_id AND deleted_at IS NULL) THEN
    RAISE EXCEPTION 'Winner must participate in this match';
  END IF;
  INSERT INTO match_result(match_id,winner_participant_id,score_summary,recorded_by,last_modified_by)
  VALUES(p_match_id,p_winner_participant_id,p_score,p_actor_id,p_actor_id)
  ON CONFLICT(match_id) DO UPDATE SET winner_participant_id=excluded.winner_participant_id,score_summary=excluded.score_summary,
    recorded_by=excluded.recorded_by,recorded_at=now(),deleted_at=NULL,last_modified_by=excluded.last_modified_by
  RETURNING id INTO new_id;
  UPDATE match SET status='completed',last_modified_by=p_actor_id WHERE id=p_match_id;
  RETURN new_id;
END $$;

CREATE OR REPLACE FUNCTION fn_soft_delete_sport(p_id uuid,p_actor_id uuid) RETURNS boolean LANGUAGE plpgsql AS $$
BEGIN
  PERFORM set_config('app.current_user_id',p_actor_id::text,true);
  UPDATE sport SET deleted_at=now(),last_modified_by=p_actor_id WHERE id=p_id AND deleted_at IS NULL; RETURN FOUND;
END $$;
CREATE OR REPLACE FUNCTION fn_soft_delete_team(p_id uuid,p_actor_id uuid) RETURNS boolean LANGUAGE plpgsql AS $$
BEGIN
  PERFORM set_config('app.current_user_id',p_actor_id::text,true);
  UPDATE team SET deleted_at=now(),last_modified_by=p_actor_id WHERE id=p_id AND deleted_at IS NULL; RETURN FOUND;
END $$;
CREATE OR REPLACE FUNCTION fn_soft_delete_venue(p_id uuid,p_actor_id uuid) RETURNS boolean LANGUAGE plpgsql AS $$
BEGIN
  PERFORM set_config('app.current_user_id',p_actor_id::text,true);
  UPDATE venue SET deleted_at=now(),last_modified_by=p_actor_id WHERE id=p_id AND deleted_at IS NULL; RETURN FOUND;
END $$;


