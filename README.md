# Курс "Оптимизация Oracle SQL"
#### Репозиторий с примерами для лекций, домашними заданиями и учебным стендом

Автор: Кивилев Денис  

Telegram-канал о разработке в СУБД Oracle: https://t.me/oracle_dbd  
Youtube-канал о разработке в СУБД Oracle и Backend: https://www.youtube.com/@pro_backendD  
Telegram-личка: https://t.me/denis_dbd  
Linked-in: https://www.linkedin.com/in/kivilev/  
Email: kivilev.d@gmail.com  

## Содержание

1. [Учебный стенд в Docker](#учебный-стенд-в-docker)
2. [Подключение и алиас в tnsnames.ora](#подключение-и-алиас-в-tnsnamesora)
3. [Трассировка и tkprof](#трассировка-и-tkprof)
4. [Чем стенд отличается от сервера из лекций](#чем-стенд-отличается-от-сервера-из-лекций)
5. [Если что-то не так](#если-что-то-не-так)
6. [Структура репозитория](#структура-репозитория)

## Учебный стенд в Docker

Стенд — это ваша личная база Oracle со схемами курса `kivi` и `hr`, которая работает у вас на компьютере в Docker.
У всех студентов данные и настройки одинаковые, поэтому планы запросов и число прочитанных блоков совпадают с тем, что показывает преподаватель.

Скрипты курса писались под Oracle 19c, а стенд работает на бесплатной Oracle AI Database 26ai Free. Отличия описаны [ниже](#чем-стенд-отличается-от-сервера-из-лекций).

### 1. Установите Docker (один раз)

1. Скачайте и установите **Docker Desktop**: https://www.docker.com/products/docker-desktop/
2. Запустите его и дождитесь статуса «Engine running».

Нужно 4 ГБ свободной оперативной памяти и 20 ГБ места на диске.

### 2. Создайте папку для трейс-файлов

Трейсы, которые база пишет внутри стенда, будут сразу появляться в этой папке на вашем диске, копировать их из стенда не придется.

Путь `C:\oracle\trace` — **пример**: папку можно назвать и расположить как угодно (например, `D:\study\oracle-trace`). Главное — потом указать этот же путь в команде запуска.

Windows (PowerShell):

```powershell
mkdir C:\oracle\trace
```

Mac / Linux:

```bash
mkdir -p ~/oracle/trace
```

Отдельную папку для файлов самой базы создавать **не нужно**: они хранятся в томе Docker (см. ниже).

### 3. Запустите стенд (одна команда, один раз)

Windows (PowerShell). Символ `` ` `` в конце строки — перенос команды:

```powershell
docker run -d --name oracle-opt-study-db `
  -p 127.0.0.1:1521:1521 `
  --shm-size=1g --memory=3g `
  -v oracle-opt-study-data:/opt/oracle/oradata `
  -v C:\oracle\trace:/opt/oracle/diag/rdbms/free/FREE/trace `
  ghcr.io/kivilev/oracle-opt-study-db:latest
```

Mac / Linux:

```bash
docker run -d --name oracle-opt-study-db \
  -p 127.0.0.1:1521:1521 \
  --shm-size=1g --memory=3g \
  -v oracle-opt-study-data:/opt/oracle/oradata \
  -v ~/oracle/trace:/opt/oracle/diag/rdbms/free/FREE/trace \
  ghcr.io/kivilev/oracle-opt-study-db:latest
```

Что здесь можно менять, а что нет:

| Параметр | Что это | Менять? |
|---|---|---|
| `--name oracle-opt-study-db` | Имя стенда в Docker. Используется в командах `docker start/stop/logs` | Можно (тогда и в остальных командах подставляйте своё имя) |
| `-p 127.0.0.1:1521:1521` | Порт. **Левое** `1521` — порт на вашем компьютере, к нему подключается IDE. **Правое** `1521` — порт внутри стенда | Левое число — можно, если 1521 занят другой базой: `-p 127.0.0.1:1522:1521` и подключаться к 1522. Правое — нет |
| `127.0.0.1` в `-p` | База доступна **только с вашего компьютера**. Без этого Docker откроет порт для всей сети (Wi-Fi в кафе, офисная сеть), а пароли у стенда учебные и всем известные | Не убирайте |
| `-v oracle-opt-study-data:/opt/oracle/oradata` | **Том Docker** с файлами базы — это «виртуальный диск», которым управляет сам Docker. Его не видно как папку на `C:`, искать его не нужно. Именно благодаря тому ваши данные сохраняются между перезапусками | Имя `oracle-opt-study-data` — можно любое (без пробелов). Правую часть — нет. Заменить том на папку `C:\...` **нельзя**: стенд с ней не запустится |
| `-v C:\oracle\trace:/opt/.../trace` | Папка для трейсов: **слева** — папка на вашем диске из шага 2, **справа** — каталог трейсов внутри стенда. В Windows путь пишется как обычно, `C:\...`; в Mac/Linux — `~/...` или `/home/...` | Левую часть — любую свою папку. Правую — нет |
| `--memory=3g`, `--shm-size=1g` | Память для базы | Лучше не уменьшать |
| `ghcr.io/kivilev/oracle-opt-study-db:latest` | Образ стенда | Нет |

Сначала Docker скачает образ (около 3–4 ГБ). Первый запуск занимает **2–5 минут**: готовая база копируется на ваш диск, а даты платежей подстраиваются под сегодняшний день. Следить за ходом:

```
docker logs -f oracle-opt-study-db
```

Стенд готов, когда в конце лога появится строка `STAND IS READY`. Выйти из просмотра лога — `Ctrl+C`.

> Уже запустили стенд без папки трейсов? Пересоздайте контейнер, данные при этом сохранятся (они в томе `oracle-opt-study-data`):
> `docker rm -f oracle-opt-study-db`, затем команда из шага 3.

### 4. Каждый день

| Что сделать | Команда |
|---|---|
| Выключить стенд | `docker stop oracle-opt-study-db` |
| Включить стенд (1–2 минуты) | `docker start oracle-opt-study-db` |

Всё, что вы сделали в базе (индексы, изменения, результаты ДЗ), **сохраняется** между выключениями и перезагрузками компьютера.

Начать с чистого стенда (всё ваше удалится!):

```
docker rm -f oracle-opt-study-db
docker volume rm oracle-opt-study-data
```

Затем снова выполните команду из шага 3.

## Подключение и алиас в tnsnames.ora

| | |
|---|---|
| Host / Port | `localhost` / `1521` (или ваш порт из шага 3) |
| Service name | `FREEPDB1` |
| Пользователь / пароль | `kivi` / `booble12` (основная схема курса) |
| Схема hr | `hr` / `booble12` |
| SYS | `sys` / `booble34`, роль SYSDBA |

Строка подключения: `kivi/booble12@//localhost:1521/FREEPDB1` (SQL Developer, DBeaver, PL/SQL Developer, Toad).

Пароли учебные, стенд доступен только с вашего компьютера.

### Алиас в tnsnames.ora

Чтобы не набирать каждый раз `//localhost:1521/FREEPDB1`, добавьте алиас в файл `tnsnames.ora`:

```
OPTSTUDY =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521))
    (CONNECT_DATA = (SERVICE_NAME = FREEPDB1))
  )
```

Где лежит `tnsnames.ora`:
- в каталоге `network\admin` вашего Oracle Client, например `C:\oracle\product\21.0.0\client_1\network\admin\tnsnames.ora` (если файла нет — создайте);
- или в каталоге из переменной окружения `TNS_ADMIN`, если она задана.

После этого подключение выглядит так: `sqlplus kivi/booble12@OPTSTUDY`. Алиас `OPTSTUDY` также подхватят PL/SQL Developer и Toad, а в SQL Developer и DBeaver можно выбрать тип подключения TNS.

## Трассировка и tkprof

Если стенд запущен с папкой трейсов (шаг 3), все трейс-файлы сразу лежат у вас на диске: `C:\oracle\trace` (Windows) или `~/oracle/trace` (Mac/Linux).

### 1. Снимите трассировку

В своей сессии (IDE или sqlplus):

```sql
alter session set tracefile_identifier = 'MY_TRC_1';   -- метка попадет в имя файла
exec dbms_session.session_trace_enable(waits => true, binds => true);

-- ... здесь выполняется исследуемый код ...

exec dbms_session.session_trace_disable;

-- полное имя трейс-файла текущей сессии (путь внутри стенда)
select value from v$diag_info where name = 'Default Trace File';
```

Файл будет называться примерно так: `FREE_ora_270_MY_TRC_1.trc` — ищите его по метке в своей папке трейсов. Другие способы включения трассировки — в `2. find slow queries/1. trace`.

### 2. Разберите tkprof

**Вариант А. tkprof внутри стенда** — ничего ставить не нужно. Результат появится в той же папке трейсов:

```
docker exec oracle-opt-study-db tkprof /opt/oracle/diag/rdbms/free/FREE/trace/FREE_ora_270_MY_TRC_1.trc /opt/oracle/diag/rdbms/free/FREE/trace/FREE_ora_270_MY_TRC_1.txt sys=no sort=prsela,fchela,exeela
```

**Вариант Б. На своем компьютере** — если установлен Oracle Client (в нём есть `tkprof`) или OraSRP. Windows (PowerShell):

```powershell
cd C:\oracle\trace
tkprof FREE_ora_270_MY_TRC_1.trc FREE_ora_270_MY_TRC_1.txt sys=no sort=prsela,fchela,exeela
orasrp --sort=prsela,fchela,exeela --sys=no FREE_ora_270_MY_TRC_1.trc FREE_ora_270_MY_TRC_1.html
```

Трейс также можно открыть в IDE (Toad, SQL Developer).

### Если стенд запущен без папки трейсов

Трейсы лежат только внутри стенда. Найти, разобрать и скопировать к себе:

```
docker exec oracle-opt-study-db bash -c "ls -t /opt/oracle/diag/rdbms/free/FREE/trace/*MY_TRC_1*.trc"
docker exec oracle-opt-study-db tkprof /opt/oracle/diag/rdbms/free/FREE/trace/FREE_ora_270_MY_TRC_1.trc /tmp/my_trc_1.txt sys=no sort=prsela,fchela,exeela
docker cp oracle-opt-study-db:/tmp/my_trc_1.txt .
```

`docker cp` кладет файл в текущую папку терминала. В Git Bash на Windows перед `docker exec` и `docker cp` с путями добавьте `MSYS_NO_PATHCONV=1 `, иначе путь `/opt/...` будет искажён. Проще пересоздать стенд с папкой трейсов (см. шаг 3).

### Через представления (как на удаленном сервере)

Без доступа к файлам трейс можно прочитать прямо из базы:

```sql
select t.trace_filename, t.modify_time
  from v$diag_trace_file t
 where t.trace_filename like '%MY_TRC_1%';

select t.payload
  from v$diag_trace_file_contents t
 where t.trace_filename = 'FREE_ora_270_MY_TRC_1.trc'
 order by t.line_number;
```

Сохранить трейс в файл через sqlplus поможет `2. find slow queries/1. trace/treader.sql`.

## Чем стенд отличается от сервера из лекций

- **Время** выполнения зависит от вашего компьютера, и тормоза короче, чем на слайдах. Сравнивайте план, Buffers (query/cr) и разницу «до/после».
  Перед замерами вызывайте `exec flush_all`.
- **SQL Monitor** сам записывает только запросы дольше 5 секунд. Чтобы получить отчёт по запросу, включите мониторинг по его sql_id и выполните код ещё раз:
  ```sql
  alter session set events 'sql_monitor [sql: ВАШ_SQL_ID] force=true';
  ```
- **AWR:** при получении плана из AWR укажите `awr_location`:
  ```sql
  select * from table(dbms_xplan.display_workload_repository(sql_id => 'ВАШ_SQL_ID', awr_location => 'AWR_PDB'));
  ```
- Статистика схемы `kivi` **заблокирована**. Если вы создали индекс, соберите по нему статистику:
  `exec dbms_stats.gather_index_stats('KIVI', 'ИМЯ_ИНДЕКСА', force => true)`
- Параллельного выполнения в бесплатной версии Oracle нет: хинт `parallel` игнорируется. SQL Quarantine тоже недоступен.

## Если что-то не так

- **Порт 1521 занят** другой базой: в команде запуска замените `127.0.0.1:1521:1521` на `127.0.0.1:1522:1521` и подключайтесь к порту 1522 (в tnsnames — `PORT = 1522`).
- **В папке трейсов пусто** (Mac/Linux): проверьте, что папка из шага 2 существует и доступна на запись; на Linux может понадобиться `chmod 777 ~/oracle/trace`.
- **В логе нет `STAND IS READY` дольше 15 минут** или видно `ОШИБКА`: пришлите преподавателю вывод команды
  `docker logs oracle-opt-study-db`.
- **Проверить, что стенд «правильный»** (перед выполнением ДЗ, около 3 минут):
  ```
  docker exec oracle-opt-study-db sqlplus -s kivi/booble12@//localhost:1521/FREEPDB1 @/opt/stand/sql/verify_stand.sql
  ```
  В конце должно быть `STAND CHECK PASSED`.

## Структура репозитория

| Папка | Урок |
|---|---|
| `1. intro` | Введение в оптимизацию, демо «проверка платежа» |
| `sql_query` | Сессии, SQL-запросы, курсоры |
| `2. find slow queries` | Поиск медленных запросов: трассировка, ASH, SQL Monitor, v$session, AWR |
| `3. query plan` | План запроса и способы его получения; селективность, кардинальность, стоимость |
| `4. read plans` | Чтение планов, трейс-файлов, отчётов SQL Monitor; ожидания |
| `5. table access` | Доступ к таблицам |
| `6. index access` | Индексный доступ, как и когда использовать индексы |
| `7. joins` | Соединения таблиц |
| `8. other operations` | Другие операции плана |
| `9. analyze plans` | Поиск и анализ проблем, best practices, «шумные соседи» |
| `10. rollout changes` | Поставка изменений: SPM, online-индексы, EBR, статистика |
| `11. bonus. dwh` … `15. bonus. partitioning` | Бонусные лекции: DWH, статистика, адаптивная оптимизация, другие темы, секционирование |
| `others` | Хинты и вспомогательные примеры |
| `homeworks` | Домашние задания и финальная работа |
| `install` | Установка схем `kivi` и `hr` на собственный сервер (если не используете стенд) |
