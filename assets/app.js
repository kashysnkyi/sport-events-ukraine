const storageKey = 'sport-events-portal-state-v7';
const pageSize = 6;
const sports = [
  { name: 'Футбол', icon: '⚽', tone: 'green' },
  { name: 'Баскетбол', icon: '🏀', tone: 'orange' },
  { name: 'Біг', icon: '🏃', tone: 'blue' },
  { name: 'Теніс', icon: '🎾', tone: 'yellow' },
  { name: 'Плавання', icon: '🏊', tone: 'cyan' },
];
const demoAccounts = {
  athlete: { id: 'athlete-001', name: 'Андрій Коваль', email: 'participant001@sportevents.ua', role: 'Учасник', initials: 'АК' },
  organizer: { id: 'organizer-001', name: 'Олена Мельник', email: 'olena@sportevents.ua', role: 'Організатор', initials: 'ОМ' },
};
const eventSeed = [
  { id: 'e-001', name: 'Кубок України з футболу 2026', sport: 'Футбол', city: 'Київ', venue: 'НСК «Олімпійський»', date: '2026-10-18', endDate: '2026-10-19', type: 'Командний турнір', organizer: 'Федерація футболу України', participants: 28, capacity: 40, status: 'registration', price: 'Безкоштовно', description: 'Відкритий міський турнір для аматорських команд. Груповий етап і фінальна частина проходять протягом двох днів.', categories: ['Чоловіки', 'Жінки', 'U-18'], result: 'Груповий етап' },
  { id: 'e-002', name: 'Відкритий кубок Києва 3x3', sport: 'Баскетбол', city: 'Київ', venue: 'Арена «Динамо»', date: '2026-10-20', endDate: '2026-10-20', type: 'Відкритий кубок', organizer: 'БК «Динамо» Київ', participants: 24, capacity: 32, status: 'registration', price: '500 грн', description: 'Швидкий формат 3x3 для клубних та аматорських команд. Матчі проходять на центральному майданчику арени.', categories: ['Open', 'U-18'], result: 'Плей-оф' },
  { id: 'e-003', name: 'Осінній марафон «Золоте місто»', sport: 'Біг', city: 'Львів', venue: 'Площа перед Оперним театром', date: '2026-10-24', endDate: '2026-10-24', type: 'Марафон', organizer: 'Lviv Running Club', participants: 30, capacity: 40, status: 'registration', price: '800 грн', description: 'Міський марафон з дистанціями 5, 10 і 21 кілометр історичним центром Львова.', categories: ['5 км', '10 км', '21 км'], result: 'Старт о 08:00' },
  { id: 'e-004', name: 'Тенісний турнір «Ракетка»', sport: 'Теніс', city: 'Харків', venue: 'Спорткомплекс «Старт»', date: '2026-10-26', endDate: '2026-10-27', type: 'Рейтингова подія', organizer: 'Федерація тенісу України', participants: 22, capacity: 30, status: 'registration', price: '600 грн', description: 'Рейтингова подія для аматорів та спортсменів клубного рівня з одиночними і парними сітками.', categories: ['Чоловіки', 'Жінки', 'Парний розряд'], result: 'Сітка формується' },
  { id: 'e-005', name: 'Першість України з плавання', sport: 'Плавання', city: 'Дніпро', venue: 'Басейн «Метеор»', date: '2026-11-02', endDate: '2026-11-04', type: 'Чемпіонат', organizer: 'Федерація плавання України', participants: 26, capacity: 36, status: 'registration', price: 'Безкоштовно', description: 'Всеукраїнські старти серед юнаків та дорослих. Доступні дистанції 50, 100 та 200 метрів.', categories: ['Юнаки', 'Дорослі', 'Естафета'], result: 'Розклад опубліковано' },
  { id: 'e-006', name: 'Зимовий кубок з футболу', sport: 'Футбол', city: 'Одеса', venue: 'Центральний стадіон', date: '2026-11-08', endDate: '2026-11-08', type: 'Кубок', organizer: 'Одеська асоціація футболу', participants: 25, capacity: 36, status: 'registration', price: '1 000 грн', description: 'Одноденний кубок для команд з південних областей України.', categories: ['Open', 'Ветерани'], result: 'Реєстрація триває' },
  { id: 'e-007', name: 'Ліга баскетболу 3x3', sport: 'Баскетбол', city: 'Запоріжжя', venue: 'Палац спорту «Юність»', date: '2026-11-12', endDate: '2026-11-13', type: 'Ліга', organizer: 'Basketball UA', participants: 29, capacity: 40, status: 'registration', price: '500 грн', description: 'Другий тур національної ліги з баскетболу 3x3.', categories: ['Open', 'U-18', 'Жінки'], result: 'Тур 2 з 5' },
  { id: 'e-008', name: 'Забіг «Дніпровська хвиля»', sport: 'Біг', city: 'Дніпро', venue: 'Набережна Дніпра', date: '2026-11-16', endDate: '2026-11-16', type: 'Міський забіг', organizer: 'Run Dnipro', participants: 20, capacity: 30, status: 'registration', price: '400 грн', description: 'Осінній забіг вздовж набережної Дніпра з мальовничим маршрутом.', categories: ['5 км', '10 км'], result: 'Реєстрація триває' },
  { id: 'e-009', name: 'Кубок області з тенісу', sport: 'Теніс', city: 'Вінниця', venue: 'Тенісний центр «Маяк»', date: '2026-11-20', endDate: '2026-11-21', type: 'Обласний кубок', organizer: 'Вінницька федерація тенісу', participants: 23, capacity: 32, status: 'registration', price: '600 грн', description: 'Обласний турнір з відкритою реєстрацією для спортсменів усіх клубів.', categories: ['Open', 'Юніори'], result: 'Сітка формується' },
  { id: 'e-010', name: 'Міський чемпіонат з плавання', sport: 'Плавання', city: 'Київ', venue: 'Басейн «Хвиля»', date: '2026-11-24', endDate: '2026-11-25', type: 'Чемпіонат міста', organizer: 'Київський міський центр спорту', participants: 24, capacity: 36, status: 'registration', price: 'Безкоштовно', description: 'Відбіркові старти для міської збірної та клубів Києва.', categories: ['Діти', 'Юніори', 'Дорослі'], result: 'Реєстрація триває' },
  { id: 'e-011', name: 'Осінній корпоративний кубок', sport: 'Футбол', city: 'Київ', venue: 'Стадіон «Олімп»', date: '2026-09-28', endDate: '2026-09-28', type: 'Корпоративний турнір', organizer: 'Sport Events UA', participants: 36, capacity: 36, status: 'finished', price: '2 000 грн', description: 'Командний день для корпоративних збірних. Фінальні результати вже опубліковані.', categories: ['Корпоративні команди'], result: 'Завершено' },
  { id: 'e-012', name: 'Фінальний турнір року', sport: 'Баскетбол', city: 'Львів', venue: 'Палац спорту «Україна»', date: '2026-10-05', endDate: '2026-10-06', type: 'Фінал сезону', organizer: 'Basketball UA', participants: 32, capacity: 32, status: 'finished', price: '800 грн', description: 'Фінальні матчі сезону з нагородженням переможців та опублікованою таблицею.', categories: ['Open', 'Жінки'], result: 'Завершено' } ,
];
const state = loadState();
let page = 'catalog';
let currentPage = 1;
let activeEventId = null;
let activeEventTab = 'overview';
let selectedCategoryCode = null;
let pendingRegistration = null;
let calendarCursor = new Date(2026, 9, 1);
let organizerView = 'summary';
let organizerPage = 1;
const filters = { query: '', sport: 'all', city: 'all', status: 'all' };
if (state.lastCreatedEventId) {
  const lastCreatedEvent = state.events.find((event) => event.id === state.lastCreatedEventId);
  if (lastCreatedEvent) filters.query = lastCreatedEvent.name;
}

function loadState() {
  try {
    const saved = JSON.parse(localStorage.getItem(storageKey) || 'null');
    if (saved && Array.isArray(saved.events) && Array.isArray(saved.registrations)) {
      const generatedEvents = saved.events.filter((event) => event.type === 'Нова подія').sort((a, b) => String(b.id).localeCompare(String(a.id)));
      if (!saved.lastCreatedEventId && generatedEvents[0]) saved.lastCreatedEventId = generatedEvents[0].id;
      if (!saved.registrations.length) saved.registrations = makeDemoRegistrations();
      return saved;
    }
  } catch {}
  return { events: eventSeed.map((event) => ({ ...event })), registrations: makeDemoRegistrations(), account: null };
}
function makeDemoRegistrations() {
  const openEvents = eventSeed.filter((event) => event.status !== 'finished');
  const rows = [];
  for (let index = 0; index < 300; index += 1) {
    const event = openEvents[index % openEvents.length];
    const category = event.categories[index % event.categories.length];
    const number = String(index + 1).padStart(3, '0');
    rows.push({ id: 'registration-' + number, eventId: event.id, userId: index === 0 ? 'athlete-001' : 'athlete-' + number, name: index === 0 ? 'Андрій Коваль' : 'Учасник ' + number, email: 'participant' + number + '@sportevents.ua', phone: '+380 67 ' + String(1000000 + index), city: event.city, birthYear: 1988 - (index % 24), rating: 980 - (index % 410), category, status: index < 36 ? 'Очікує підтвердження' : 'Підтверджена', createdAt: '2026-09-' + String((index % 28) + 1).padStart(2, '0') });
  }
  return rows;
}
function saveState() {
  localStorage.setItem(storageKey, JSON.stringify(state));
}
function escapeHtml(value) {
  return String(value).replace(/[&<>"']/g, (char) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[char]);
}
function formatDate(value, options = { day: '2-digit', month: 'short' }) {
  return new Intl.DateTimeFormat('uk-UA', options).format(new Date(value + 'T12:00:00'));
}
function formatFullDate(value) {
  return new Intl.DateTimeFormat('uk-UA', { day: 'numeric', month: 'long', year: 'numeric' }).format(new Date(value + 'T12:00:00'));
}
function getSport(name) {
  return sports.find((item) => item.name === name) || sports[0];
}
function eventStatus(event) {
  if (event.status === 'finished') return ['Завершено', 'status-gray'];
  if (event.participants >= event.capacity) return ['Заповнено', 'status-orange'];
  return ['Реєстрація', 'status-green'];
}
function filteredEvents() {
  const query = filters.query.trim().toLowerCase();
  const sport = filters.sport;
  const city = filters.city;
  const status = filters.status;
  return state.events.filter((event) => {
    const textMatch = !query || [event.name, event.city, event.venue, event.organizer, event.type].join(' ').toLowerCase().includes(query);
    const sportMatch = sport === 'all' || event.sport === sport;
    const cityMatch = city === 'all' || event.city === city;
    const statusMatch = status === 'all' || (status === 'open' && eventStatus(event)[0] === 'Реєстрація') || (status === 'full' && eventStatus(event)[0] === 'Заповнено') || (status === 'finished' && event.status === 'finished');
    return textMatch && sportMatch && cityMatch && statusMatch;
  }).sort((a, b) => a.date.localeCompare(b.date));
}
function renderStats() {
  const cities = new Set(state.events.map((event) => event.city));
  document.getElementById('statEvents').textContent = state.events.filter((event) => event.status !== 'finished').length;
  document.getElementById('statCities').textContent = cities.size;
  document.getElementById('statSports').textContent = new Set(state.events.map((event) => event.sport)).size;
  document.getElementById('statAthletes').textContent = '300+';
}
function selectOptions(items, allLabel, selected = 'all') {
  return '<option value="all" ' + (selected === 'all' ? 'selected' : '') + '>' + allLabel + '</option>' + items.map((item) => '<option value="' + escapeHtml(item) + '" ' + (selected === item ? 'selected' : '') + '>' + escapeHtml(item) + '</option>').join('');
}
function catalogTemplate() {
  const cities = [...new Set(state.events.map((event) => event.city))].sort();
  const filtered = filteredEvents();
  const pages = Math.max(1, Math.ceil(filtered.length / pageSize));
  currentPage = Math.min(currentPage, pages);
  const visible = filtered.slice((currentPage - 1) * pageSize, currentPage * pageSize);
  return '<section class="page-head"><div><span class="eyebrow">TOURNAMENT DATABASE</span><h2>Каталог подій</h2><p>Знайдено <b>' + filtered.length + '</b> подій у календарі України</p></div><div class="view-toggle"><button class="view-btn active">▦ Таблиця</button><button class="view-btn" data-page="calendar">▦ Місяць</button></div></section>' +
    '<section class="filter-panel"><div class="search-field"><span>⌕</span><input id="globalSearch" placeholder="Назва, місто, організатор..." value="' + escapeHtml(filters.query) + '" /></div><label><span>Вид спорту</span><select id="sportFilter">' + selectOptions(sports.map((item) => item.name), 'Усі види', filters.sport) + '</select></label><label><span>Місто</span><select id="cityFilter">' + selectOptions(cities, 'Усі міста', filters.city) + '</select></label><label><span>Статус</span><select id="statusFilter"><option value="all" ' + (filters.status === 'all' ? 'selected' : '') + '>Усі події</option><option value="open" ' + (filters.status === 'open' ? 'selected' : '') + '>Є місця</option><option value="full" ' + (filters.status === 'full' ? 'selected' : '') + '>Заповнені</option><option value="finished" ' + (filters.status === 'finished' ? 'selected' : '') + '>Завершені</option></select></label><button class="filter-reset" id="resetFilters">Скинути</button></section>' +
    '<section class="catalog-card"><div class="catalog-toolbar"><div><b>Найближчі події</b><span class="muted"> Оновлено щойно</span></div><button class="sort-btn" id="sortButton">Дата проведення ↑</button></div><div class="event-table-wrap"><table class="event-table"><thead><tr><th>Дата</th><th>Подія</th><th>Вид спорту</th><th>Місто</th><th>Учасники</th><th>Статус</th><th></th></tr></thead><tbody>' +
    (visible.length ? visible.map(eventRow).join('') : '<tr><td colspan="7"><div class="empty-state"><strong>Подій не знайдено</strong><span>Спробуйте змінити фільтри пошуку.</span></div></td></tr>') +
    '</tbody></table></div><div class="table-foot"><span>Показано ' + (filtered.length ? (currentPage - 1) * pageSize + 1 : 0) + '-' + Math.min(currentPage * pageSize, filtered.length) + ' із ' + filtered.length + '</span><div class="pagination">' + pagination(pages) + '</div></div></section>';
}
function eventRow(event) {
  const sport = getSport(event.sport);
  const [status, statusClass] = eventStatus(event);
  return '<tr class="event-row" data-open-event="' + event.id + '"><td><div class="date-cell"><b>' + formatDate(event.date, { day: '2-digit' }) + '</b><span>' + formatDate(event.date, { month: 'short' }).replace('.', '') + '</span></div></td><td><div class="event-name"><strong>' + escapeHtml(event.name) + '</strong><span>' + escapeHtml(event.type) + ' · ' + escapeHtml(event.organizer) + '</span></div></td><td><span class="sport-pill ' + sport.tone + '">' + sport.icon + ' ' + escapeHtml(event.sport) + '</span></td><td><b>' + escapeHtml(event.city) + '</b><small>' + escapeHtml(event.venue) + '</small></td><td><div class="capacity"><span>' + event.participants + '/' + event.capacity + '</span><i><b style="width:' + Math.round((event.participants / event.capacity) * 100) + '%"></b></i></div></td><td><span class="status ' + statusClass + '">' + status + '</span></td><td><button class="row-arrow" aria-label="Відкрити">↗</button></td></tr>';
}
function pagination(pages) {
  let html = '<button data-page-number="prev" ' + (currentPage === 1 ? 'disabled' : '') + '>‹</button>';
  for (let index = 1; index <= pages; index += 1) html += '<button data-page-number="' + index + '" class="' + (index === currentPage ? 'active' : '') + '">' + index + '</button>';
  return html + '<button data-page-number="next" ' + (currentPage === pages ? 'disabled' : '') + '>›</button>';
}
function calendarTemplate() {
  const year = calendarCursor.getFullYear();
  const month = calendarCursor.getMonth();
  const monthKey = year + '-' + String(month + 1).padStart(2, '0');
  const monthEvents = state.events.filter((event) => event.date.startsWith(monthKey));
  const monthLabel = new Intl.DateTimeFormat('uk-UA', { month: 'long', year: 'numeric' }).format(calendarCursor);
  const upcoming = [...state.events].sort((a, b) => a.date.localeCompare(b.date)).slice(0, 6);
  return '<section class="page-head"><div><span class="eyebrow">EVENT CALENDAR</span><h2>Календар подій</h2><p>' + monthLabel + ' · події по всій Україні</p></div><button class="secondary-btn" data-page="catalog">← До каталогу</button></section><section class="calendar-layout"><div class="calendar-card"><div class="calendar-head"><button class="circle-btn" data-calendar-nav="prev" aria-label="Попередній місяць">‹</button><strong>' + monthLabel + '</strong><button class="circle-btn" data-calendar-nav="next" aria-label="Наступний місяць">›</button></div><div class="weekdays"><span>Пн</span><span>Вт</span><span>Ср</span><span>Чт</span><span>Пт</span><span>Сб</span><span>Нд</span></div><div class="month-grid">' + monthGrid(year, month, monthEvents) + '</div></div><aside class="upcoming-card"><div class="card-title"><span>Найближчі</span><a data-page="catalog">Всі події</a></div>' + upcoming.map((event) => '<button class="upcoming-row" data-open-event="' + event.id + '"><span class="mini-date"><b>' + formatDate(event.date, { day: '2-digit' }) + '</b><small>' + formatDate(event.date, { month: 'short' }).replace('.', '') + '</small></span><span><strong>' + escapeHtml(event.name) + '</strong><small>' + getSport(event.sport).icon + ' ' + escapeHtml(event.city) + '</small></span><i>›</i></button>').join('') + '</aside></section>';
}
function monthGrid(year, month, monthEvents) {
  const daysInMonth = new Date(year, month + 1, 0).getDate();
  const firstDay = (new Date(year, month, 1).getDay() + 6) % 7;
  const today = new Date().toISOString().slice(0, 10);
  let html = '';
  for (let index = 0; index < firstDay; index += 1) html += '<span class="day empty"></span>';
  for (let day = 1; day <= daysInMonth; day += 1) {
    const date = year + '-' + String(month + 1).padStart(2, '0') + '-' + String(day).padStart(2, '0');
    const events = monthEvents.filter((event) => event.date === date);
    html += '<button class="day ' + (events.length ? 'has-events' : '') + ' ' + (date === today ? 'today' : '') + '" data-calendar-date="' + date + '"><b>' + day + '</b>' + (events.length ? '<i>' + events.length + '</i>' : '') + '</button>';
  }
  return html;
}
function resultsTemplate() {
  const completedEvents = state.events.filter((event) => event.status === 'finished');
  const resultRows = completedEvents.length
    ? completedEvents.map((event) => '<button class="result-row" data-open-event="' + event.id + '"><span class="result-icon ' + getSport(event.sport).tone + '">' + getSport(event.sport).icon + '</span><span><strong>' + escapeHtml(event.name) + '</strong><small>' + escapeHtml(event.city) + ' · ' + formatFullDate(event.date) + '</small></span><span class="result-value">Фінальні результати <b>›</b></span></button>').join('')
    : '<div class="empty-state"><strong>Завершених подій поки немає</strong><span>Результати з’являться після завершення змагання.</span></div>';
  return '<section class="page-head"><div><span class="eyebrow">LIVE RESULTS</span><h2>Результати та рейтинги</h2><p>Підсумки завершених змагань, таблиці та календар матчів</p></div><div class="result-filter"><select id="resultSport">' + selectOptions(sports.map((item) => item.name), 'Усі види') + '</select></div></section><section class="results-layout"><div class="results-main"><div class="results-tabs"><button class="active">Останні результати</button><button>Рейтинг учасників</button><button>Матчі сьогодні</button></div>' + resultRows + '</div><aside class="ranking-card"><div class="card-title"><span>Топ учасників</span><a>Цей місяць</a></div>' + ['Андрій Коваль', 'Марія Кравець', 'Олег Олійник', 'Ірина Бойко', 'Максим Шевченко'].map((name, index) => '<div class="rank-row"><b>' + (index + 1) + '</b><span class="rank-avatar">' + name.split(' ').map((item) => item[0]).join('') + '</span><span><strong>' + name + '</strong><small>' + (980 - index * 37) + ' балів</small></span><em>' + (index < 2 ? '↑' : '•') + '</em></div>').join('') + '</aside></section>';
}
function organizersTemplate() {
  const organizer = state.account?.role === 'Організатор';
  const managedEvents = [...state.events].sort((a, b) => b.date.localeCompare(a.date)).slice(0, 6);
  const pending = state.registrations.filter((item) => item.status === 'Очікує підтвердження');
  const participantRows = organizerView === 'applications' ? state.registrations.filter((item) => item.status === 'Очікує підтвердження') : state.registrations;
  const pages = Math.max(1, Math.ceil(participantRows.length / 10));
  organizerPage = Math.min(organizerPage, pages);
  const visible = participantRows.slice((organizerPage - 1) * 10, organizerPage * 10);
  const tabs = '<div class="organizer-tabs"><button data-organizer-tab="summary" class="' + (organizerView === 'summary' ? 'active' : '') + '">Огляд</button><button data-organizer-tab="applications" class="' + (organizerView === 'applications' ? 'active' : '') + '">Заявки <b>' + pending.length + '</b></button><button data-organizer-tab="participants" class="' + (organizerView === 'participants' ? 'active' : '') + '">Учасники <b>' + state.registrations.length + '</b></button></div>';
  let workspace = '';
  if (organizerView === 'summary') workspace = '<div class="organizer-card"><div class="card-title"><span>Останні опубліковані події</span><a data-page="catalog">Відкрити каталог</a></div>' + managedEvents.map((event) => '<div class="managed-row"><span class="managed-date">' + formatDate(event.date, { day: '2-digit', month: 'short' }) + '</span><span><strong>' + escapeHtml(event.name) + '</strong><small>' + escapeHtml(event.city) + ' · ' + event.participants + '/' + event.capacity + ' учасників</small></span><span class="status ' + (event.status === 'finished' ? 'status-gray' : 'status-green') + '">' + (event.status === 'finished' ? 'Завершена' : 'Опублікована') + '</span><button data-open-event="' + event.id + '">›</button></div>').join('') + '</div>';
  else workspace = '<div class="organizer-card"><div class="card-title"><span>' + (organizerView === 'applications' ? 'Заявки, що очікують підтвердження' : 'Усі учасники') + '</span><span class="muted">Показано ' + (visible.length ? ((organizerPage - 1) * 10 + 1) + '-' + Math.min(organizerPage * 10, participantRows.length) : 0) + ' із ' + participantRows.length + '</span></div><div class="admin-table-wrap"><table class="admin-table"><thead><tr><th>Учасник</th><th>Подія</th><th>Категорія</th><th>Статус</th><th>Дії</th></tr></thead><tbody>' + (visible.length ? visible.map((item) => { const event = state.events.find((entry) => entry.id === item.eventId); return '<tr><td><strong>' + escapeHtml(item.name) + '</strong><small>' + escapeHtml(item.email) + '</small></td><td>' + escapeHtml(event?.name || 'Подія') + '<small>' + escapeHtml(event?.city || '') + '</small></td><td>' + escapeHtml(item.category || 'Open') + '</td><td><span class="status ' + (item.status === 'Підтверджена' ? 'status-green' : item.status === 'Відхилена' ? 'status-gray' : 'status-orange') + '">' + escapeHtml(item.status) + '</span></td><td><div class="organizer-actions"><button class="mini-btn" data-registration-profile="' + item.id + '">Профіль</button>' + (organizerView === 'applications' ? '<button class="mini-btn confirm-btn" data-application-action="confirm" data-registration-id="' + item.id + '">Підтвердити</button><button class="mini-btn reject-btn" data-application-action="reject" data-registration-id="' + item.id + '">Відхилити</button>' : '') + '</div></td></tr>'; }).join('') : '<tr><td colspan="5"><div class="empty-state"><strong>Немає записів</strong><span>Тут відображатимуться заявки та учасники.</span></div></td></tr>') + '</tbody></table></div><div class="table-foot"><span>Керування заявками зберігається у браузері</span><div class="pagination">' + organizerPagination(pages) + '</div></div></div>';
  return '<section class="page-head"><div><span class="eyebrow">FOR ORGANIZERS</span><h2>Кабінет організатора</h2><p>Публікуйте події, приймайте заявки та керуйте результатами.</p></div>' + (organizer ? '<button class="primary-btn" id="createEventButton">＋ Створити подію</button>' : '<button class="secondary-btn" id="organizerLoginButton">Увійти як організатор</button>') + '</section>' + (organizer ? tabs + '<section class="organizer-grid"><div class="organizer-main"><div class="organizer-stats"><button data-organizer-tab="summary"><span>Подій у каталозі</span><strong>' + state.events.length + '</strong><small>відкриті та завершені</small></button><button data-organizer-tab="applications"><span>Очікують підтвердження</span><strong>' + pending.length + '</strong><small>відкрити заявки</small></button><button data-organizer-tab="participants"><span>Учасники</span><strong>' + state.registrations.length + '</strong><small>відкрити список</small></button></div>' + workspace + '</div><aside class="organizer-help"><span class="help-icon">✦</span><h3>Потрібна допомога?</h3><p>Оберіть заявку, відкрийте профіль і підтвердіть участь. Дані та статуси залишаються після оновлення сторінки.</p><button class="ghost-btn" id="helpButton">Як це працює</button></aside></section>' : '<section class="organizer-grid"><div class="organizer-main"><div class="organizer-card"><div class="empty-state"><strong>Увійдіть як організатор</strong><span>Після входу тут будуть заявки, учасники та керування подіями.</span></div></div></div><aside class="organizer-help"><span class="help-icon">✦</span><h3>Кабінет організатора</h3><p>Створюйте події та керуйте реєстраціями в одному місці.</p></aside></section>');
}
function organizerPagination(pages) {
  let html = '<button data-organizer-page="prev" ' + (organizerPage === 1 ? 'disabled' : '') + '>‹</button>';
  for (let index = 1; index <= pages; index += 1) html += '<button data-organizer-page="' + index + '" class="' + (index === organizerPage ? 'active' : '') + '">' + index + '</button>';
  return html + '<button data-organizer-page="next" ' + (organizerPage === pages ? 'disabled' : '') + '>›</button>';
}
function renderPage() {
  const root = document.getElementById('pageRoot');
  root.innerHTML = page === 'catalog' ? catalogTemplate() : page === 'calendar' ? calendarTemplate() : page === 'results' ? resultsTemplate() : organizersTemplate();
  bindPageEvents();
  updateNav();
  renderStats();
}
function updateNav() {
  document.querySelectorAll('[data-page]').forEach((element) => element.classList.toggle('active', element.dataset.page === page));
  document.getElementById('accountLabel').textContent = state.account ? state.account.name.split(' ')[0] : 'Увійти';
  document.getElementById('accountAvatar').textContent = state.account ? state.account.initials : '?';
}
function switchPage(nextPage) {
  page = nextPage;
  currentPage = 1;
  renderPage();
  window.scrollTo({ top: 0, behavior: 'smooth' });
}
function bindPageEvents() {
  document.querySelectorAll('[data-page]').forEach((element) => element.addEventListener('click', (event) => {
    event.preventDefault();
    if (element.dataset.page) switchPage(element.dataset.page);
  }));
  document.querySelectorAll('[data-open-event]').forEach((element) => element.addEventListener('click', () => openEvent(element.dataset.openEvent)));
  const search = document.getElementById('globalSearch');
  if (search) search.addEventListener('input', () => { filters.query = search.value; currentPage = 1; renderPage(); const input = document.getElementById('globalSearch'); input?.focus(); input?.setSelectionRange(input.value.length, input.value.length); });
  ['sportFilter', 'cityFilter', 'statusFilter'].forEach((id) => document.getElementById(id)?.addEventListener('change', (event) => { filters[id === 'sportFilter' ? 'sport' : id === 'cityFilter' ? 'city' : 'status'] = event.target.value; currentPage = 1; renderPage(); }));
  document.getElementById('resetFilters')?.addEventListener('click', () => { filters.query = ''; filters.sport = 'all'; filters.city = 'all'; filters.status = 'all'; state.lastCreatedEventId = null; saveState(); currentPage = 1; renderPage(); });
  document.querySelectorAll('[data-page-number]').forEach((button) => button.addEventListener('click', () => {
    const filtered = filteredEvents();
    const pages = Math.max(1, Math.ceil(filtered.length / pageSize));
    currentPage = button.dataset.pageNumber === 'prev' ? Math.max(1, currentPage - 1) : button.dataset.pageNumber === 'next' ? Math.min(pages, currentPage + 1) : Number(button.dataset.pageNumber);
    renderPage();
  }));
  document.querySelectorAll('[data-calendar-nav]').forEach((button) => button.addEventListener('click', () => {
    calendarCursor.setMonth(calendarCursor.getMonth() + (button.dataset.calendarNav === 'next' ? 1 : -1));
    renderPage();
  }));
  document.querySelectorAll('[data-organizer-tab]').forEach((button) => button.addEventListener('click', () => {
    organizerView = button.dataset.organizerTab;
    organizerPage = 1;
    renderPage();
  }));
  document.querySelectorAll('[data-organizer-page]').forEach((button) => button.addEventListener('click', () => {
    const rows = organizerView === 'applications' ? state.registrations.filter((item) => item.status === 'Очікує підтвердження') : state.registrations;
    const pages = Math.max(1, Math.ceil(rows.length / 10));
    organizerPage = button.dataset.organizerPage === 'prev' ? Math.max(1, organizerPage - 1) : button.dataset.organizerPage === 'next' ? Math.min(pages, organizerPage + 1) : Number(button.dataset.organizerPage);
    renderPage();
  }));
  document.querySelectorAll('[data-application-action]').forEach((button) => button.addEventListener('click', () => {
    const registration = state.registrations.find((item) => item.id === button.dataset.registrationId);
    if (!registration) return;
    registration.status = button.dataset.applicationAction === 'confirm' ? 'Підтверджена' : 'Відхилена';
    registration.updatedAt = new Date().toISOString();
    saveState();
    renderPage();
    showToast(registration.status === 'Підтверджена' ? 'Заявку підтверджено' : 'Заявку відхилено');
  }));
  document.querySelectorAll('[data-registration-profile]').forEach((button) => button.addEventListener('click', () => {
    const item = state.registrations.find((registration) => registration.id === button.dataset.registrationProfile);
    if (!item) return;
    const event = state.events.find((entry) => entry.id === item.eventId);
    openInfo('Профіль учасника', '<div class="profile-grid"><div><span>ПІБ</span><strong>' + escapeHtml(item.name) + '</strong></div><div><span>Електронна пошта</span><strong>' + escapeHtml(item.email) + '</strong></div><div><span>Телефон</span><strong>' + escapeHtml(item.phone || 'Не вказано') + '</strong></div><div><span>Місто</span><strong>' + escapeHtml(item.city || '') + '</strong></div><div><span>Рік народження</span><strong>' + escapeHtml(item.birthYear || '') + '</strong></div><div><span>Рейтинг</span><strong>' + escapeHtml(item.rating || 0) + ' балів</strong></div><div><span>Подія</span><strong>' + escapeHtml(event?.name || '') + '</strong></div><div><span>Категорія</span><strong>' + escapeHtml(item.category || 'Open') + '</strong></div></div><p class="profile-status">Статус: <b>' + escapeHtml(item.status) + '</b></p>');
  }));
  document.getElementById('sortButton')?.addEventListener('click', () => {
    state.events.reverse();
    saveState();
    renderPage();
  });
  document.getElementById('createEventButton')?.addEventListener('click', openCreateEvent);
  document.getElementById('organizerLoginButton')?.addEventListener('click', () => openAccount(true));
  document.getElementById('helpButton')?.addEventListener('click', () => openInfo('Як працює каталог', '<p>Організатор створює подію, додає категорії та публікує реєстрацію. Учасник входить у кабінет, обирає категорію та стежить за статусом заявки.</p>'));
  document.querySelectorAll('[data-calendar-date]').forEach((button) => button.addEventListener('click', () => {
    const events = state.events.filter((event) => event.date === button.dataset.calendarDate);
    if (events.length) openEvent(events[0].id);
  }));
}
function openEvent(id) {
  activeEventId = id;
  activeEventTab = 'overview';
  selectedCategoryCode = null;
  renderEventModal();
  showModal();
}
function renderEventModal() {
  const event = state.events.find((item) => item.id === activeEventId);
  if (!event) return;
  const sport = getSport(event.sport);
  const [status, statusClass] = eventStatus(event);
  const registration = state.registrations.find((item) => item.eventId === event.id && item.userId === state.account?.id);
  const registered = Boolean(registration);
  const canRegister = event.status !== 'finished' && event.participants < event.capacity;
  const resultBody = event.status === 'finished'
    ? '<h3>Фінальні результати</h3><div class="result-board"><div><b>1</b><span>Андрій Коваль</span><strong>980</strong></div><div><b>2</b><span>Марія Кравець</span><strong>943</strong></div><div><b>3</b><span>Олег Олійник</span><strong>906</strong></div></div>'
    : '<div class="empty-state"><strong>Результатів ще немає</strong><span>Таблиця з’явиться після завершення події.</span></div>';
  const body = activeEventTab === 'overview'
    ? '<div class="detail-hero ' + sport.tone + '"><span class="detail-icon">' + sport.icon + '</span><div><span class="eyebrow">' + escapeHtml(event.type) + '</span><h2>' + escapeHtml(event.name) + '</h2><p>' + escapeHtml(event.organizer) + '</p></div></div><div class="detail-grid"><div><span>Дата</span><strong>' + formatFullDate(event.date) + (event.endDate !== event.date ? ' - ' + formatFullDate(event.endDate) : '') + '</strong></div><div><span>Місце</span><strong>' + escapeHtml(event.venue) + ', ' + escapeHtml(event.city) + '</strong></div><div><span>Участь</span><strong>' + escapeHtml(event.price) + '</strong></div><div><span>Статус</span><strong class="' + statusClass + '">' + status + '</strong></div></div><p class="detail-description">' + escapeHtml(event.description) + '</p><div class="category-list">' + event.categories.map((category) => '<span>' + escapeHtml(category) + '</span>').join('') + '</div>'
    : activeEventTab === 'categories'
      ? '<h3>Оберіть категорію для заявки</h3><p class="muted">Одна заявка подається тільки в одну категорію.</p><div class="category-table">' + event.categories.map((category, index) => '<div><span><b>' + String(index + 1).padStart(2, '0') + '</b>' + escapeHtml(category) + '</span><strong>' + Math.max(4, Math.round(event.capacity / event.categories.length) - index) + ' місць</strong><button class="mini-btn" data-select-category="' + event.id + '" data-category-code="' + escapeHtml(category) + '"' + (canRegister && !registered ? '' : ' disabled') + '>' + (registered && registration.category === category ? 'Обрано' : selectedCategoryCode === category ? 'Обрано' : canRegister ? 'Обрати' : 'Закрито') + '</button></div>').join('') + '</div>'
      : activeEventTab === 'schedule'
        ? '<h3>Розклад події</h3><div class="schedule-list"><div><b>08:00</b><span>Реєстрація та перевірка учасників</span><small>' + escapeHtml(event.venue) + '</small></div><div><b>10:00</b><span>Кваліфікаційний етап</span><small>Центральна арена</small></div><div><b>14:30</b><span>Фінальні старти та нагородження</span><small>Головна сцена</small></div></div>'
        : resultBody;
  const actionText = event.status === 'finished' ? 'Реєстрація завершена' : registered ? 'Заявка подана' : selectedCategoryCode ? 'Зареєструватися: ' + selectedCategoryCode : 'Обрати категорію';
  document.getElementById('modalContent').innerHTML = '<div class="modal-event-head"><span class="modal-code">SE-' + event.id.replace('e-', '') + '</span><button class="share-btn" id="shareEvent">Поділитися ↗</button></div><div class="detail-tabs"><button data-event-tab="overview" class="' + (activeEventTab === 'overview' ? 'active' : '') + '">Огляд</button><button data-event-tab="categories" class="' + (activeEventTab === 'categories' ? 'active' : '') + '">Категорії</button><button data-event-tab="schedule" class="' + (activeEventTab === 'schedule' ? 'active' : '') + '">Розклад</button><button data-event-tab="results" class="' + (activeEventTab === 'results' ? 'active' : '') + '">Результати</button></div><div class="modal-event-body">' + body + '</div><div class="modal-event-foot"><span>' + event.participants + ' із ' + event.capacity + ' місць зайнято</span><button class="' + (canRegister ? 'primary-btn' : 'secondary-btn') + '" data-submit-registration="' + event.id + '"' + (canRegister ? '' : ' disabled') + '>' + actionText + ' <span>' + (canRegister ? '↗' : '•') + '</span></button></div>';
  document.querySelectorAll('[data-event-tab]').forEach((button) => button.addEventListener('click', () => { activeEventTab = button.dataset.eventTab; renderEventModal(); }));
  document.querySelectorAll('[data-select-category]').forEach((button) => button.addEventListener('click', () => { selectedCategoryCode = button.dataset.categoryCode; activeEventTab = 'categories'; renderEventModal(); showToast('Категорію обрано'); }));
  document.querySelectorAll('[data-submit-registration]').forEach((button) => button.addEventListener('click', () => registerForEvent(event, selectedCategoryCode)));
  document.getElementById('shareEvent')?.addEventListener('click', () => { navigator.clipboard?.writeText(window.location.href + '#' + event.id); showToast('Посилання скопійовано'); });
}
function registerForEvent(event, category) {
  if (event.status === 'finished') return showToast('Реєстрацію на цю подію завершено');
  if (event.participants >= event.capacity) return showToast('Вільних місць більше немає');
  if (!category) { activeEventTab = 'categories'; renderEventModal(); return showToast('Спочатку оберіть категорію'); }
  if (!state.account) { pendingRegistration = { eventId: event.id, category }; return openAccount(true); }
  if (state.account.role !== 'Учасник') return showToast('Реєстрація доступна в кабінеті учасника');
  if (!state.registrations.some((item) => item.eventId === event.id && item.userId === state.account.id)) {
    state.registrations.push({ id: 'registration-' + Date.now(), eventId: event.id, userId: state.account.id, name: state.account.name, email: state.account.email, city: 'Київ', category, status: 'Очікує підтвердження', createdAt: new Date().toISOString() });
    event.participants += 1;
    saveState();
    renderEventModal();
    renderStats();
    showToast('Заявку подано організатору');
  } else showToast('Ви вже подали заявку на цю подію');
}
function openAccount(forceLogin = false) {
  const account = state.account;
  document.getElementById('modalContent').innerHTML = account && !forceLogin ? '<div class="account-modal"><span class="eyebrow">MY ACCOUNT</span><h2>' + escapeHtml(account.name) + '</h2><p>' + escapeHtml(account.email) + '</p><div class="account-role">' + escapeHtml(account.role) + '</div><div class="account-actions"><button class="secondary-btn" id="myApplications">Мої заявки</button><button class="danger-btn" id="logoutButton">Вийти</button></div><div class="account-note">Усі демо-дії зберігаються у браузері та відновлюються після оновлення.</div></div>' : '<div class="login-modal"><span class="eyebrow">SPORT EVENTS ACCOUNT</span><h2>Увійдіть до кабінету</h2><p>Оберіть демо-роль, щоб перевірити сценарії користувача.</p><button class="login-choice" data-login-role="athlete"><span class="login-avatar">АК</span><span><b>Андрій Коваль</b><small>Учасник · заявки та профіль</small></span><i>→</i></button><button class="login-choice" data-login-role="organizer"><span class="login-avatar organizer">ОМ</span><span><b>Олена Мельник</b><small>Організатор · події та результати</small></span><i>→</i></button></div>';
  showModal();
  document.querySelectorAll('[data-login-role]').forEach((button) => button.addEventListener('click', () => {
    state.account = demoAccounts[button.dataset.loginRole];
    saveState();
    closeModal();
    updateNav();
    if (pendingRegistration && state.account.role === 'Учасник') {
      const pending = pendingRegistration;
      pendingRegistration = null;
      activeEventId = pending.eventId;
      selectedCategoryCode = pending.category;
      renderEventModal();
      showModal();
      showToast('Категорію збережено. Натисніть кнопку реєстрації');
    } else {
      renderPage();
      showToast('Ви увійшли до кабінету');
    }
  }));
  document.getElementById('logoutButton')?.addEventListener('click', () => { state.account = null; saveState(); closeModal(); updateNav(); renderPage(); showToast('Ви вийшли з кабінету'); });
  document.getElementById('myApplications')?.addEventListener('click', openApplications);
}
function openApplications() {
  const own = state.registrations.filter((item) => item.userId === state.account?.id);
  document.getElementById('modalContent').innerHTML = '<div class="applications-modal"><span class="eyebrow">MY REGISTRATIONS</span><h2>Мої заявки</h2>' + (own.length ? own.map((item) => { const event = state.events.find((entry) => entry.id === item.eventId); return '<div class="application-row"><span class="mini-date"><b>' + formatDate(event.date, { day: '2-digit' }) + '</b><small>' + formatDate(event.date, { month: 'short' }) + '</small></span><span><strong>' + escapeHtml(event.name) + '</strong><small>' + escapeHtml(event.city) + ' · ' + escapeHtml(item.category || 'Open') + '</small></span><em>' + escapeHtml(item.status) + '</em></div>'; }).join('') : '<div class="empty-state"><strong>Заявок поки немає</strong><span>Відкрийте подію, оберіть категорію та подайте заявку.</span></div>') + '</div>';
}
function openCreateEvent() {
  if (!state.account || state.account.role !== 'Організатор') return openAccount(true);
  document.getElementById('modalContent').innerHTML = '<div class="create-modal"><span class="eyebrow">NEW EVENT</span><h2>Створити подію</h2><form id="createEventForm"><label>Назва події<input required name="name" placeholder="Наприклад, Кубок міста з бігу" /></label><div class="form-two"><label>Вид спорту<select name="sport">' + selectOptions(sports.map((item) => item.name), 'Оберіть вид спорту', sports[0].name) + '</select></label><label>Місто<input required name="city" placeholder="Київ" /></label></div><div class="form-two"><label>Дата<input required name="date" type="date" value="2026-12-12" /></label><label>Місткість<input required name="capacity" type="number" min="2" value="40" /></label></div><label>Локація<input required name="venue" placeholder="Назва майданчика" /></label><label>Опис<textarea name="description" rows="3" placeholder="Коротко про подію"></textarea></label><button class="primary-btn" type="submit">Опублікувати подію <span>↗</span></button></form></div>';
  showModal();
  document.getElementById('createEventForm').addEventListener('submit', (event) => {
    event.preventDefault();
    const data = new FormData(event.target);
    const createdEvent = { id: 'e-' + Date.now(), name: String(data.get('name')).trim(), sport: data.get('sport'), city: String(data.get('city')).trim(), venue: String(data.get('venue')).trim(), date: data.get('date'), endDate: data.get('date'), type: 'Нова подія', organizer: state.account.name, participants: 0, capacity: Number(data.get('capacity')), status: 'registration', price: 'Уточнюється', description: String(data.get('description') || 'Опис події буде додано організатором.').trim(), categories: ['Open'], result: 'Реєстрація триває' };
    state.events.push(createdEvent);
    state.lastCreatedEventId = createdEvent.id;
    saveState();
    closeModal();
    filters.query = createdEvent.name;
    filters.sport = 'all';
    filters.city = 'all';
    filters.status = 'all';
    page = 'catalog';
    currentPage = 1;
    renderPage();
    showToast('Подію збережено. Вона відкрита у каталозі');
  });
}
function openInfo(title, content) {
  document.getElementById('modalContent').innerHTML = '<div class="info-modal"><span class="eyebrow">SPORT EVENTS</span><h2>' + title + '</h2><div class="info-content">' + content + '</div></div>';
  showModal();
}
function showModal() {
  document.getElementById('modalBackdrop').classList.remove('hidden');
  document.body.classList.add('modal-open');
}
function closeModal() {
  document.getElementById('modalBackdrop').classList.add('hidden');
  document.body.classList.remove('modal-open');
}
function showToast(message) {
  const toast = document.getElementById('toast');
  toast.textContent = message;
  toast.classList.remove('hidden');
  clearTimeout(window.toastTimer);
  window.toastTimer = setTimeout(() => toast.classList.add('hidden'), 2800);
}
document.getElementById('modalClose').addEventListener('click', closeModal);
document.getElementById('modalBackdrop').addEventListener('click', (event) => { if (event.target.id === 'modalBackdrop') closeModal(); });
document.getElementById('accountButton').addEventListener('click', () => openAccount());
document.getElementById('notificationsButton').addEventListener('click', () => openInfo('Сповіщення', '<div class="notice-list"><div><b>12 нових заявок</b><span>Потрібне підтвердження організатора</span></div><div><b>Оновлено календар</b><span>Додано 4 події у листопаді</span></div></div>'));
document.querySelectorAll('[data-page]').forEach((element) => element.addEventListener('click', (event) => { event.preventDefault(); if (element.dataset.page) switchPage(element.dataset.page); }));
renderPage();









