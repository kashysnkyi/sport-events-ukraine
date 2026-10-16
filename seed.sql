SET search_path = sports, public;

SELECT set_config('app.current_user_id', '00000000-0000-0000-0000-000000000001', false);

INSERT INTO app_user(id, email, display_name, role)
VALUES
  ('00000000-0000-0000-0000-000000000001', 'olena@sportevents.ua', 'Олена Мельник', 'organizer'),
  ('00000000-0000-0000-0000-000000000002', 'participant001@sportevents.ua', 'Андрій Коваль', 'athlete')
ON CONFLICT(id) DO UPDATE SET email = excluded.email, display_name = excluded.display_name, role = excluded.role, deleted_at = NULL;

INSERT INTO sport(id, name, description, last_modified_by)
VALUES
  ('00000000-0000-0000-0000-000000000101', 'Футбол', 'Командні футбольні турніри', '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000102', 'Баскетбол', 'Баскетбольні змагання', '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000103', 'Біг', 'Забіги та марафони', '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000104', 'Теніс', 'Тенісні турніри', '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000105', 'Плавання', 'Плавальні старти', '00000000-0000-0000-0000-000000000001')
ON CONFLICT(id) DO UPDATE SET name = excluded.name, description = excluded.description, deleted_at = NULL, last_modified_by = excluded.last_modified_by;

INSERT INTO venue(id, name, address, city, capacity, last_modified_by)
VALUES
  ('00000000-0000-0000-0000-000000000201', 'НСК «Олімпійський»', 'вул. Велика Васильківська, 55', 'Київ', 1000, '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000202', 'Арена «Динамо»', 'вул. Грушевського, 12', 'Київ', 500, '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000203', 'Парк Перемоги', 'просп. Броварський, 20', 'Київ', 2000, '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000204', 'Спорткомплекс «Старт»', 'вул. Спортивна, 26', 'Харків', 350, '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000205', 'Басейн «Метеор»', 'вул. Козака Бабури, 9', 'Дніпро', 220, '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000206', 'Палац спорту «Україна»', 'вул. Мельника, 18', 'Львів', 800, '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000207', 'Площа перед Оперним театром', 'просп. Свободи, 28', 'Львів', 34000, '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000208', 'Спортивна база «Карпати»', 'вул. Гірська, 3', 'Львів', 260, '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000209', 'Палац спорту «Юність»', 'вул. Перемоги, 66', 'Запоріжжя', 650, '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000210', 'Набережна Дніпра', 'вул. Набережна, 1', 'Дніпро', 1500, '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000211', 'Манеж «Олімпійський»', 'вул. Динамівська, 4', 'Харків', 420, '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000212', 'Центральний стадіон', 'вул. Центральна, 10', 'Одеса', 1200, '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000213', 'Тенісний центр «Маяк»', 'вул. Келецька, 98', 'Вінниця', 180, '00000000-0000-0000-0000-000000000001'),
    ('00000000-0000-0000-0000-000000000214', 'Басейн «Хвиля»', 'вул. Басейна, 5', 'Київ', 220, '00000000-0000-0000-0000-000000000001')
ON CONFLICT(id) DO UPDATE SET name = excluded.name, address = excluded.address, city = excluded.city, capacity = excluded.capacity, deleted_at = NULL, last_modified_by = excluded.last_modified_by;

INSERT INTO sport_event(id, sport_id, venue_id, organizer_id, name, description, starts_at, ends_at, registration_deadline, capacity, status, last_modified_by)
VALUES
  ('00000000-0000-0000-0000-000000000301', '00000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000201', '00000000-0000-0000-0000-000000000001', 'Кубок України з футболу 2026', 'Міський відкритий футбольний турнір', '2026-10-18 09:00+03', '2026-10-18 18:00+03', '2026-10-16 23:59+03', 40, 'published', '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000302', '00000000-0000-0000-0000-000000000102', '00000000-0000-0000-0000-000000000202', '00000000-0000-0000-0000-000000000001', 'Відкритий кубок Києва 3x3', 'Баскетбольний кубок міста', '2026-10-20 10:00+03', '2026-10-20 19:00+03', '2026-10-18 23:59+03', 32, 'published', '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000303', '00000000-0000-0000-0000-000000000103', '00000000-0000-0000-0000-000000000207', '00000000-0000-0000-0000-000000000001', 'Осінній марафон «Золоте місто»', 'Дистанції 5, 10 та 21 кілометр', '2026-10-24 08:00+03', '2026-10-24 15:00+03', '2026-10-22 23:59+03', 40, 'published', '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000304', '00000000-0000-0000-0000-000000000104', '00000000-0000-0000-0000-000000000204', '00000000-0000-0000-0000-000000000001', 'Тенісний турнір «Ракетка»', 'Відкритий турнір для аматорів', '2026-10-26 09:00+03', '2026-10-26 20:00+03', '2026-10-24 23:59+03', 30, 'published', '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000305', '00000000-0000-0000-0000-000000000105', '00000000-0000-0000-0000-000000000205', '00000000-0000-0000-0000-000000000001', 'Першість України з плавання', 'Міські старти з плавання', '2026-11-02 08:00+03', '2026-11-02 16:00+03', '2026-10-30 23:59+03', 36, 'published', '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000306', '00000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000212', '00000000-0000-0000-0000-000000000001', 'Зимовий кубок з футболу', 'Футбольний кубок зимового сезону', '2026-11-08 09:00+03', '2026-11-08 18:00+03', '2026-11-05 23:59+03', 36, 'published', '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000307', '00000000-0000-0000-0000-000000000102', '00000000-0000-0000-0000-000000000209', '00000000-0000-0000-0000-000000000001', 'Ліга баскетболу 3x3', 'Міська баскетбольна ліга', '2026-11-12 10:00+03', '2026-11-12 19:00+03', '2026-11-09 23:59+03', 40, 'published', '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000308', '00000000-0000-0000-0000-000000000103', '00000000-0000-0000-0000-000000000210', '00000000-0000-0000-0000-000000000001', 'Забіг «Дніпровська хвиля»', 'Осінній міський забіг', '2026-11-16 08:00+03', '2026-11-16 14:00+03', '2026-11-13 23:59+03', 30, 'published', '00000000-0000-0000-0000-000000000001'),
    ('00000000-0000-0000-0000-000000000309', '00000000-0000-0000-0000-000000000104', '00000000-0000-0000-0000-000000000213', '00000000-0000-0000-0000-000000000001', 'Кубок області з тенісу', 'Обласні тенісні змагання', '2026-11-20 09:00+03', '2026-11-20 20:00+03', '2026-11-17 23:59+03', 32, 'published', '00000000-0000-0000-0000-000000000001'),
    ('00000000-0000-0000-0000-000000000310', '00000000-0000-0000-0000-000000000105', '00000000-0000-0000-0000-000000000214', '00000000-0000-0000-0000-000000000001', 'Міський чемпіонат з плавання', 'Чемпіонат міста серед різних вікових груп', '2026-11-24 08:00+03', '2026-11-24 16:00+03', '2026-11-21 23:59+03', 36, 'published', '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000311', '00000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000201', '00000000-0000-0000-0000-000000000001', 'Осінній корпоративний кубок', 'Командний турнір для компаній', '2026-09-28 09:00+03', '2026-09-28 18:00+03', '2026-09-25 23:59+03', 36, 'completed', '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000312', '00000000-0000-0000-0000-000000000102', '00000000-0000-0000-0000-000000000202', '00000000-0000-0000-0000-000000000001', 'Фінальний турнір року', 'Фінальні матчі сезону', '2026-10-05 10:00+03', '2026-10-06 19:00+03', '2026-10-02 23:59+03', 32, 'completed', '00000000-0000-0000-0000-000000000001')
ON CONFLICT(id) DO UPDATE SET sport_id = excluded.sport_id, venue_id = excluded.venue_id, organizer_id = excluded.organizer_id,
  name = excluded.name, description = excluded.description, starts_at = excluded.starts_at, ends_at = excluded.ends_at,
  registration_deadline = excluded.registration_deadline, capacity = excluded.capacity, status = excluded.status, deleted_at = NULL,
  last_modified_by = excluded.last_modified_by;

INSERT INTO event_category(id, event_id, code, name, min_age, max_age, capacity, last_modified_by)
VALUES
  ('00000000-0000-0000-0000-000000000401', '00000000-0000-0000-0000-000000000301', 'OPEN', 'Відкрита категорія', 16, NULL, 40, '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000402', '00000000-0000-0000-0000-000000000302', 'OPEN', 'Відкрита категорія', 16, NULL, 32, '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000403', '00000000-0000-0000-0000-000000000303', 'OPEN', 'Відкрита категорія', 18, NULL, 40, '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000404', '00000000-0000-0000-0000-000000000304', 'OPEN', 'Відкрита категорія', 16, NULL, 30, '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000405', '00000000-0000-0000-0000-000000000305', 'OPEN', 'Відкрита категорія', 12, NULL, 36, '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000406', '00000000-0000-0000-0000-000000000306', 'OPEN', 'Відкрита категорія', 16, NULL, 36, '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000407', '00000000-0000-0000-0000-000000000307', 'OPEN', 'Відкрита категорія', 16, NULL, 40, '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000408', '00000000-0000-0000-0000-000000000308', 'OPEN', 'Відкрита категорія', 16, NULL, 30, '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000409', '00000000-0000-0000-0000-000000000309', 'OPEN', 'Відкрита категорія', 16, NULL, 32, '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000410', '00000000-0000-0000-0000-000000000310', 'OPEN', 'Відкрита категорія', 12, NULL, 36, '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000411', '00000000-0000-0000-0000-000000000311', 'OPEN', 'Відкрита категорія', 18, NULL, 36, '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000412', '00000000-0000-0000-0000-000000000312', 'OPEN', 'Відкрита категорія', 16, NULL, 32, '00000000-0000-0000-0000-000000000001')
ON CONFLICT(id) DO UPDATE SET event_id = excluded.event_id, code = excluded.code, name = excluded.name,
  min_age = excluded.min_age, max_age = excluded.max_age, capacity = excluded.capacity, deleted_at = NULL,
  last_modified_by = excluded.last_modified_by;

DO $$
DECLARE
  i int;
  uid uuid;
  pid uuid;
  athlete_name text;
BEGIN
  FOR i IN 1..300 LOOP
    uid := CASE WHEN i = 1 THEN '00000000-0000-0000-0000-000000000002'::uuid ELSE md5('sports-athlete-' || i)::uuid END;
    pid := md5('sports-profile-' || i)::uuid;
    athlete_name := CASE WHEN i = 1 THEN 'Андрій Коваль' ELSE 'Учасник ' || lpad(i::text, 3, '0') END;
    INSERT INTO app_user(id, email, display_name, role)
    VALUES(uid, CASE WHEN i = 1 THEN 'participant001@sportevents.ua' ELSE 'participant' || lpad(i::text, 3, '0') || '@sportevents.ua' END, athlete_name, 'athlete')
    ON CONFLICT(id) DO UPDATE SET email = excluded.email, display_name = excluded.display_name, role = excluded.role, deleted_at = NULL;
    INSERT INTO athlete_profile(id, user_id, birth_date, country_code, last_modified_by)
    VALUES(pid, uid, DATE '1980-01-01' + ((i * 23) % 12000), 'UA', '00000000-0000-0000-0000-000000000001')
    ON CONFLICT(id) DO UPDATE SET user_id = excluded.user_id, birth_date = excluded.birth_date,
      country_code = excluded.country_code, deleted_at = NULL, last_modified_by = excluded.last_modified_by;
  END LOOP;
END $$;

INSERT INTO team(id, name, owner_id, last_modified_by)
VALUES
  ('00000000-0000-0000-0000-000000000501', 'Сокіл', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000502', 'Дніпро', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000503', 'Київські леви', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000504', 'Старт', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000505', 'Олімп', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000506', 'Перемога', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000507', 'Фенікс', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000508', 'Динамо', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001')
ON CONFLICT(id) DO UPDATE SET name = excluded.name, owner_id = excluded.owner_id, deleted_at = NULL, last_modified_by = excluded.last_modified_by;

DO $$
DECLARE
  team_ids uuid[] := ARRAY[
    '00000000-0000-0000-0000-000000000501'::uuid,
    '00000000-0000-0000-0000-000000000502'::uuid,
    '00000000-0000-0000-0000-000000000503'::uuid,
    '00000000-0000-0000-0000-000000000504'::uuid,
    '00000000-0000-0000-0000-000000000505'::uuid,
    '00000000-0000-0000-0000-000000000506'::uuid,
    '00000000-0000-0000-0000-000000000507'::uuid,
    '00000000-0000-0000-0000-000000000508'::uuid
  ];
  member_counts int[] := ARRAY[38, 36, 40, 34, 37, 39, 35, 41];
  team_index int;
  start_no int := 0;
  athlete_id uuid;
BEGIN
  FOR team_index IN 1..8 LOOP
    FOR athlete_id IN
      SELECT ranked.id
      FROM (
        SELECT id, row_number() OVER (ORDER BY id) AS rn
        FROM athlete_profile
        WHERE deleted_at IS NULL
      ) ranked
      WHERE ranked.rn > start_no AND ranked.rn <= start_no + member_counts[team_index]
    LOOP
      INSERT INTO team_member(team_id, athlete_id, member_role, last_modified_by)
      VALUES(team_ids[team_index], athlete_id, CASE WHEN start_no = 0 THEN 'captain' ELSE 'member' END, '00000000-0000-0000-0000-000000000001')
      ON CONFLICT(team_id, athlete_id) DO UPDATE SET deleted_at = NULL, last_modified_by = excluded.last_modified_by;
    END LOOP;
    start_no := start_no + member_counts[team_index];
  END LOOP;
END $$;

DO $$
DECLARE
  i int;
  profile_id uuid;
  category_id uuid;
BEGIN
  FOR i IN 1..300 LOOP
    SELECT id INTO profile_id FROM athlete_profile WHERE deleted_at IS NULL ORDER BY id OFFSET (i - 1) LIMIT 1;
    SELECT id INTO category_id FROM event_category WHERE deleted_at IS NULL ORDER BY id OFFSET ((i - 1) % 12) LIMIT 1;
    INSERT INTO event_registration(category_id, athlete_id, status, registered_at, last_modified_by)
    VALUES(category_id, profile_id, CASE WHEN i <= 36 THEN 'pending' ELSE 'confirmed' END, now() - ((i % 18) || ' days')::interval, '00000000-0000-0000-0000-000000000001')
    ON CONFLICT(category_id, athlete_id) DO UPDATE SET status = excluded.status, deleted_at = NULL, last_modified_by = excluded.last_modified_by;
  END LOOP;
END $$;

DO $$
DECLARE
  i int;
  category_id uuid;
  current_team_id uuid;
BEGIN
  FOR i IN 1..8 LOOP
    SELECT id INTO category_id FROM event_category WHERE deleted_at IS NULL ORDER BY id OFFSET (i - 1) LIMIT 1;
    current_team_id := ('00000000-0000-0000-0000-00000000050' || i)::uuid;
    INSERT INTO event_team_entry(category_id, team_id, status, last_modified_by)
    VALUES(category_id, current_team_id, 'confirmed', '00000000-0000-0000-0000-000000000001')
    ON CONFLICT(category_id, team_id) DO UPDATE SET status = excluded.status, deleted_at = NULL, last_modified_by = excluded.last_modified_by;
  END LOOP;
END $$;

DELETE FROM match_result WHERE match_id IN (SELECT id FROM match WHERE competition_id IN ('00000000-0000-0000-0000-000000000603'::uuid, '00000000-0000-0000-0000-000000000604'::uuid, '00000000-0000-0000-0000-000000000605'::uuid, '00000000-0000-0000-0000-000000000606'::uuid, '00000000-0000-0000-0000-000000000607'::uuid, '00000000-0000-0000-0000-000000000608'::uuid));
DELETE FROM match_participant WHERE match_id IN (SELECT id FROM match WHERE competition_id IN ('00000000-0000-0000-0000-000000000603'::uuid, '00000000-0000-0000-0000-000000000604'::uuid, '00000000-0000-0000-0000-000000000605'::uuid, '00000000-0000-0000-0000-000000000606'::uuid, '00000000-0000-0000-0000-000000000607'::uuid, '00000000-0000-0000-0000-000000000608'::uuid));
DELETE FROM match WHERE competition_id IN ('00000000-0000-0000-0000-000000000603'::uuid, '00000000-0000-0000-0000-000000000604'::uuid, '00000000-0000-0000-0000-000000000605'::uuid, '00000000-0000-0000-0000-000000000606'::uuid, '00000000-0000-0000-0000-000000000607'::uuid, '00000000-0000-0000-0000-000000000608'::uuid);
DELETE FROM competition WHERE id IN ('00000000-0000-0000-0000-000000000603'::uuid, '00000000-0000-0000-0000-000000000604'::uuid, '00000000-0000-0000-0000-000000000605'::uuid, '00000000-0000-0000-0000-000000000606'::uuid, '00000000-0000-0000-0000-000000000607'::uuid, '00000000-0000-0000-0000-000000000608'::uuid);

INSERT INTO competition(id, event_id, category_id, name, format, status, last_modified_by)
VALUES
  ('00000000-0000-0000-0000-000000000601', '00000000-0000-0000-0000-000000000311', '00000000-0000-0000-0000-000000000411', 'Осінній корпоративний кубок', 'single_elimination', 'completed', '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000602', '00000000-0000-0000-0000-000000000312', '00000000-0000-0000-0000-000000000412', 'Фінальний турнір року', 'single_elimination', 'completed', '00000000-0000-0000-0000-000000000001')
ON CONFLICT(id) DO UPDATE SET event_id = excluded.event_id, category_id = excluded.category_id, name = excluded.name,
  format = excluded.format, status = excluded.status, deleted_at = NULL, last_modified_by = excluded.last_modified_by;

DO $$
DECLARE
  i int;
  j int;
  competition_id uuid;
  current_match_id uuid;
  participant_id uuid;
  current_team_id uuid;
BEGIN
  FOR i IN 1..2 LOOP
    competition_id := ('00000000-0000-0000-0000-0000000060' || lpad(i::text, 2, '0'))::uuid;
    FOR j IN 1..2 LOOP
      current_match_id := md5('sports-match-' || i || '-' || j)::uuid;
      INSERT INTO match(id, competition_id, round_no, scheduled_at, status, last_modified_by)
      VALUES(current_match_id, competition_id, j, ('2026-10-' || lpad((18 + i)::text, 2, '0') || ' ' || lpad((8 + j)::text, 2, '0') || ':00+03')::timestamptz,
        'completed', '00000000-0000-0000-0000-000000000001')
      ON CONFLICT(id) DO UPDATE SET competition_id = excluded.competition_id, round_no = excluded.round_no,
        scheduled_at = excluded.scheduled_at, status = excluded.status, deleted_at = NULL, last_modified_by = excluded.last_modified_by;
      FOR current_team_id IN SELECT unnest(ARRAY[
        ('00000000-0000-0000-0000-00000000050' || (((i + j - 2) % 8) + 1))::uuid,
        ('00000000-0000-0000-0000-00000000050' || (((i + j - 1) % 8) + 1))::uuid
      ])
      LOOP
        participant_id := md5(current_match_id::text || current_team_id::text)::uuid;
        INSERT INTO match_participant(id, match_id, team_id, last_modified_by)
        VALUES(participant_id, current_match_id, current_team_id, '00000000-0000-0000-0000-000000000001')
        ON CONFLICT(id) DO UPDATE SET match_id = excluded.match_id, team_id = excluded.team_id, deleted_at = NULL, last_modified_by = excluded.last_modified_by;
      END LOOP;
      IF j = 1 THEN
        SELECT mp.id INTO participant_id FROM match_participant mp WHERE mp.match_id = current_match_id ORDER BY mp.id LIMIT 1;
        INSERT INTO match_result(match_id, winner_participant_id, score_summary, recorded_by, last_modified_by)
        VALUES(current_match_id, participant_id, '2:1', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001')
        ON CONFLICT(match_id) DO UPDATE SET winner_participant_id = excluded.winner_participant_id,
          score_summary = excluded.score_summary, recorded_by = excluded.recorded_by, deleted_at = NULL, last_modified_by = excluded.last_modified_by;
      END IF;
    END LOOP;
  END LOOP;
END $$;

INSERT INTO sponsor(id, name, website, last_modified_by)
VALUES
  ('00000000-0000-0000-0000-000000000801', 'СпортМаркет', 'https://sportmarket.example', '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000802', 'Енергія Плюс', 'https://energyplus.example', '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000803', 'Місто Спорту', 'https://sportcity.example', '00000000-0000-0000-0000-000000000001')
ON CONFLICT(id) DO UPDATE SET name = excluded.name, website = excluded.website, deleted_at = NULL, last_modified_by = excluded.last_modified_by;

INSERT INTO event_sponsor(event_id, sponsor_id, contribution_type, contribution_amount, last_modified_by)
VALUES
  ('00000000-0000-0000-0000-000000000301', '00000000-0000-0000-0000-000000000801', 'Генеральний партнер', 25000, '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000302', '00000000-0000-0000-0000-000000000802', 'Партнер події', 12000, '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000303', '00000000-0000-0000-0000-000000000803', 'Партнер події', 8000, '00000000-0000-0000-0000-000000000001')
ON CONFLICT(event_id, sponsor_id) DO UPDATE SET contribution_type = excluded.contribution_type,
  contribution_amount = excluded.contribution_amount, deleted_at = NULL, last_modified_by = excluded.last_modified_by;

SELECT 'app_user' AS object_type, count(*) AS total FROM app_user WHERE deleted_at IS NULL
UNION ALL SELECT 'sport', count(*) FROM sport WHERE deleted_at IS NULL
UNION ALL SELECT 'venue', count(*) FROM venue WHERE deleted_at IS NULL
UNION ALL SELECT 'sport_event', count(*) FROM sport_event WHERE deleted_at IS NULL
UNION ALL SELECT 'athlete_profile', count(*) FROM athlete_profile WHERE deleted_at IS NULL
UNION ALL SELECT 'team', count(*) FROM team WHERE deleted_at IS NULL
UNION ALL SELECT 'team_member', count(*) FROM team_member WHERE deleted_at IS NULL
UNION ALL SELECT 'event_registration', count(*) FROM event_registration WHERE deleted_at IS NULL
UNION ALL SELECT 'competition', count(*) FROM competition WHERE deleted_at IS NULL
UNION ALL SELECT 'match', count(*) FROM match WHERE deleted_at IS NULL
ORDER BY object_type;









