# Чекліст здачі

## Виконані вимоги

1. Нова ER схема порталу описана у `sports_events_portal.dbml`. Модель містить 17 сутностей, первинні та зовнішні ключі, обмеження і зв'язки.
2. PostgreSQL реалізація знаходиться у `schema.sql`.
3. Початкові дані для демонстрації знаходяться у `seed.sql`. Скрипт заповнює базу узгодженим набором: 12 подій, 14 локацій, 8 команд і 300 різних профілів спортсменів.
4. Soft delete реалізовано через `deleted_at`. Поля `last_modified_at` і `last_modified_by` та аудит змін реалізовані для робочих сутностей.
5. У схемі є 14 SQL і PL/pgSQL функцій для створення, зміни, читання та soft delete.
6. Є 4 подання та тригер аудиту, який підключається до 15 робочих таблиць.
7. Є B-tree індекси та GIN індекс для пошуку назв подій.
8. `repository-example.cs` та `sports-events-app/` демонструють Repository і Unit of Work. Запити виконуються через функції та подання PostgreSQL.
9. `NORMALIZATION_AND_INDEXES.md` пояснює 1НФ, 2НФ, 3НФ, усунені аномалії та перевірку індексів через `EXPLAIN`.

## Перевірка PostgreSQL

```bash
psql -d sports_events -f schema.sql
psql -d sports_events -f seed.sql
```

У pgAdmin порядок такий самий: Query Tool, `schema.sql`, потім `seed.sql`. Після seed перевірте контрольні числа запитом нижче або перегляньте подання `v_active_events`, `v_event_registration_counts`, `v_event_categories` та `v_event_results`.

Після виконання у pgAdmin можна перевірити об'єкти запитом:

```sql
SELECT object_type, count(*)
FROM (
  SELECT 'tables' AS object_type FROM information_schema.tables WHERE table_schema = 'sports'
  UNION ALL SELECT 'views' FROM information_schema.views WHERE table_schema = 'sports'
  UNION ALL SELECT 'functions' FROM information_schema.routines WHERE routine_schema = 'sports'
  UNION ALL SELECT 'triggers' FROM information_schema.triggers WHERE trigger_schema = 'sports'
) objects
GROUP BY object_type
ORDER BY object_type;
```

## Перевірка застосунку

`index.html` є готовим клікабельним порталом Sport Events Ukraine. За логікою каталогу він спирається на довідник турнірів: пошук за назвою, видом спорту та містом, фільтр доступних місць, пагінація, календар з переходом між місяцями, результати, сторінка події з категоріями, розкладом і результатами, вибір однієї категорії, вхід учасника та організатора, подача заявки, підтвердження або відхилення заявки, профіль учасника, список усіх учасників і створення події. У демо використано 12 подій у 7 містах України, з них 10 з відкритою реєстрацією та 2 завершені з результатами, 5 видів спорту та 300 різних учасників. Дані входу, заявок і створених подій зберігаються у браузері, а остання створена подія відновлюється після оновлення.

Інтерфейс розділений на `index.html`, `assets/styles.css` та `assets/app.js`, тому його можна окремо читати, змінювати й розширювати.

Для запуску локального перегляду:

```bash
python -m http.server 8765
```

Потім відкрити `http://127.0.0.1:8765/index.html`.
