#1.Проаналізувати приклад універсального відношення.
#З'ясувати які його колонки містять надлишкові дані.
#Виконати нормалізацію універсального відношення, розбивши його на кілька таблиць.
#Проаналізувавши приклад універсального відношення, можна сказати про те, що колонка
#"Format","Theme","Category" і "Publisher" мають надлишкові дані і, тому, їх варто розбити на кілька таблиць.
#2.Скласти SQL-script, що виконує:
#a.Створення таблиць бази даних. Команди для створення таблиці повинні містити головний ключ,
#обмеження типу null / not null, default, check, створення зв'язків з умовами посилальної цілісності
CREATE TABLE bookformats (
    FORMAT_ID INT AUTO_INCREMENT PRIMARY KEY,
    FORMAT_NAME VARCHAR(255)
) ENGINE = InnoDB
  CHARACTER SET 'utf8'
  COLLATE 'utf8_general_ci';

CREATE TABLE theme (
    THEME_ID INT AUTO_INCREMENT PRIMARY KEY,
    THEME_NAME VARCHAR(255)
) ENGINE = InnoDB
  CHARACTER SET 'utf8'
  COLLATE 'utf8_general_ci';

CREATE TABLE categories (
    CATEGORY_ID INT AUTO_INCREMENT PRIMARY KEY,
    CATEGORY_NAME VARCHAR(255)
) ENGINE = InnoDB
  CHARACTER SET 'utf8'
  COLLATE 'utf8_general_ci';

CREATE TABLE publishernames (
    PUBLISHER_ID INT AUTO_INCREMENT PRIMARY KEY,
    PUBLISHER_NAME VARCHAR(255)
) ENGINE = InnoDB
  CHARACTER SET 'utf8'
  COLLATE 'utf8_general_ci';

CREATE TABLE maininfo (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Code INT,
    NewEntry VARCHAR(3) CHECK (NewEntry IN ('Yes', 'No')),
    Title VARCHAR(255),
    Price DECIMAL(10,2) DEFAULT 0.00,
    Publisher INT,
    Pages INT,
    Format INT,
    DatePublished DATE DEFAULT CURRENT_DATE,
    Edition INT,
    Theme INT,
    Category INT,
    FOREIGN KEY (Publisher) REFERENCES publishernames(PUBLISHER_ID) ON DELETE RESTRICT ON UPDATE RESTRICT,
    FOREIGN KEY (Theme) REFERENCES theme(THEME_ID) ON DELETE RESTRICT ON UPDATE RESTRICT,
    FOREIGN KEY (Category) REFERENCES categories(CATEGORY_ID) ON DELETE RESTRICT ON UPDATE RESTRICT,
    FOREIGN KEY (Format) REFERENCES bookformats(FORMAT_ID) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB
  CHARACTER SET 'utf8'
  COLLATE 'utf8_general_ci';

#b.Завантаження даних в таблиці
INSERT INTO bookformats (FORMAT_NAME) VALUES
('70х100/16'),
('84х108/16'),
('60х88/16'),
('84х10016'),
('60х84/16'),
('""'),
('60х90/16');

INSERT INTO categories (CATEGORY_NAME) VALUES
('Підручники'),
('Апаратні засоби ПК'),
('Захист і безпека ПК'),
('Інші книги'),
('Windows 2000'),
('Linux'),
('Unix'),
('Інші операційні системи'),
('C&C++'),
('SQL');

INSERT INTO publishernames (PUBLISHER_NAME) VALUES
('Видавнича група BHV'),
('Вільямс'),
('МикроАрт'),
('DiaSoft'),
('ДМК'),
('Фабула'),
('Навчальна книга - Богдан'),
('Триумф'),
('Эком'),
('Києво-Могилянська академія'),
('Університет "Україна"'),
('Вінниця: ВДТУ');

INSERT INTO theme (THEME_NAME) VALUES
('Використання ПК в цілому'),
('Навіть поганий програмний код може працювати.'),
('Книга присвячена мові програмування Python'),
('Операційні системи'),
('Програмування');

INSERT INTO maininfo (ID, Code, NewEntry, Title, Price, Publisher, Pages, Format, DatePublished, Edition, Theme, Category) VALUES
(2, 5110, 'No', 'Апаратні засоби мультимедіа. Відеосистема РС', 15.51, (SELECT PUBLISHER_ID FROM publishernames WHERE PUBLISHER_NAME = 'Видавнича група BHV'), 400, (SELECT FORMAT_ID FROM bookformats WHERE FORMAT_NAME = '70х100/16'), '2000-07-24', 5000, (SELECT THEME_ID FROM theme WHERE THEME_NAME = 'Використання ПК в цілому'), (SELECT CATEGORY_ID FROM categories WHERE CATEGORY_NAME = 'Підручники')),
(8, 4985, 'No', 'Засвой самостійно модернізацію та ремонт ПК за 24 години, 2-ге вид.', 18.90, (SELECT PUBLISHER_ID FROM publishernames WHERE PUBLISHER_NAME = 'Вільямс'), 288, (SELECT FORMAT_ID FROM bookformats WHERE FORMAT_NAME = '70х100/16'), '2000-07-07', 5000, (SELECT THEME_ID FROM theme WHERE THEME_NAME = 'Використання ПК в цілому'), (SELECT CATEGORY_ID FROM categories WHERE CATEGORY_NAME = 'Підручники')),
(9, 5141, 'No', 'Структури даних та алгоритми', 37.80, (SELECT PUBLISHER_ID FROM publishernames WHERE PUBLISHER_NAME = 'Вільямс'), 384, (SELECT FORMAT_ID FROM bookformats WHERE FORMAT_NAME = '70х100/16'), '2000-09-29', 5000, (SELECT THEME_ID FROM theme WHERE THEME_NAME = 'Використання ПК в цілому'), (SELECT CATEGORY_ID FROM categories WHERE CATEGORY_NAME = 'Підручники')),
(20, 5127, 'No', 'Автоматизація інженерно-графічних робіт', 11.58, (SELECT PUBLISHER_ID FROM publishernames WHERE PUBLISHER_NAME = 'Видавнича група BHV'), 256, (SELECT FORMAT_ID FROM bookformats WHERE FORMAT_NAME = '70х100/16'), '2000-06-15', 5000, (SELECT THEME_ID FROM theme WHERE THEME_NAME = 'Використання ПК в цілому'), (SELECT CATEGORY_ID FROM categories WHERE CATEGORY_NAME = 'Підручники')),
(31, 5110, 'No', 'Апаратні засоби мультимедіа. Відеосистема РС', 15.51, (SELECT PUBLISHER_ID FROM publishernames WHERE PUBLISHER_NAME = 'Видавнича група BHV'), 400, (SELECT FORMAT_ID FROM bookformats WHERE FORMAT_NAME = '70х100/16'), '2000-07-24', 5000, (SELECT THEME_ID FROM theme WHERE THEME_NAME = 'Використання ПК в цілому'), (SELECT CATEGORY_ID FROM categories WHERE CATEGORY_NAME = 'Апаратні засоби ПК')),
(46, 5199, 'No', 'Залізо IBM 2001', 30.07, (SELECT PUBLISHER_ID FROM publishernames WHERE PUBLISHER_NAME = 'МикроАрт'), 368, (SELECT FORMAT_ID FROM bookformats WHERE FORMAT_NAME = '70х100/16'), '2000-12-02', 5000, (SELECT THEME_ID FROM theme WHERE THEME_NAME = 'Використання ПК в цілому'), (SELECT CATEGORY_ID FROM categories WHERE CATEGORY_NAME = 'Апаратні засоби ПК')),
(50, 3851, 'No', 'Захист інформації та безпека комп\'ютерних систем', 26.00, (SELECT PUBLISHER_ID FROM publishernames WHERE PUBLISHER_NAME = 'DiaSoft'), 480, (SELECT FORMAT_ID FROM bookformats WHERE FORMAT_NAME = '84х108/16'), NULL, 5000, (SELECT THEME_ID FROM theme WHERE THEME_NAME = 'Використання ПК в цілому'), (SELECT CATEGORY_ID FROM categories WHERE CATEGORY_NAME = 'Захист і безпека ПК')),
(58, 3932, 'No', 'Як перетворити персональний комп\'ютер на вимірювальний комплекс', 7.65, (SELECT PUBLISHER_ID FROM publishernames WHERE PUBLISHER_NAME = 'ДМК'), 144, (SELECT FORMAT_ID FROM bookformats WHERE FORMAT_NAME = '60х88/16'), '1999-06-09', 5000, (SELECT THEME_ID FROM theme WHERE THEME_NAME = 'Використання ПК в цілому'), (SELECT CATEGORY_ID FROM categories WHERE CATEGORY_NAME = 'Інші книги')),
(59, 4713, 'No', 'Plug-ins. Додаткові програми для музичних програм', 11.41, (SELECT PUBLISHER_ID FROM publishernames WHERE PUBLISHER_NAME = 'ДМК'), 144, (SELECT FORMAT_ID FROM bookformats WHERE FORMAT_NAME = '70х100/16'), '2000-02-22', 5000, (SELECT THEME_ID FROM theme WHERE THEME_NAME = 'Використання ПК в цілому'), (SELECT CATEGORY_ID FROM categories WHERE CATEGORY_NAME = 'Інші книги')),
(175, 5217, 'No', 'Windows МЕ. Найновіші версії програм', 16.57, (SELECT PUBLISHER_ID FROM publishernames WHERE PUBLISHER_NAME = 'Триумф'), 320, (SELECT FORMAT_ID FROM bookformats WHERE FORMAT_NAME = '70х100/16'), '2000-08-25', 5000, (SELECT THEME_ID FROM theme WHERE THEME_NAME = 'Операційні системи'), (SELECT CATEGORY_ID FROM categories WHERE CATEGORY_NAME = 'Windows 2000')),
(176, 4829, 'No', 'Windows 2000 Professional крок за кроком з CD', 27.25, (SELECT PUBLISHER_ID FROM publishernames WHERE PUBLISHER_NAME = 'Эком'), 320, (SELECT FORMAT_ID FROM bookformats WHERE FORMAT_NAME = '70х100/16'), '2000-04-28', 5000, (SELECT THEME_ID FROM theme WHERE THEME_NAME = 'Операційні системи'), (SELECT CATEGORY_ID FROM categories WHERE CATEGORY_NAME = 'Windows 2000')),
(188, 5170, 'No', 'Linux версії', 24.43, (SELECT PUBLISHER_ID FROM publishernames WHERE PUBLISHER_NAME = 'ДМК'), 346, (SELECT FORMAT_ID FROM bookformats WHERE FORMAT_NAME = '70х100/16'), '2000-09-29', 5000, (SELECT THEME_ID FROM theme WHERE THEME_NAME = 'Операційні системи'), (SELECT CATEGORY_ID FROM categories WHERE CATEGORY_NAME = 'Linux')),
(191, 860, 'No', 'Операційна система UNIX', 3.50, (SELECT PUBLISHER_ID FROM publishernames WHERE PUBLISHER_NAME = 'Видавнича група BHV'), 395, (SELECT FORMAT_ID FROM bookformats WHERE FORMAT_NAME = '84х100\16'), '1997-05-05', 5000, (SELECT THEME_ID FROM theme WHERE THEME_NAME = 'Операційні системи'), (SELECT CATEGORY_ID FROM categories WHERE CATEGORY_NAME = 'Unix')),
(203, 44, 'No', 'Відповіді на актуальні запитання щодо OS/2 Warp', 5.00, (SELECT PUBLISHER_ID FROM publishernames WHERE PUBLISHER_NAME = 'DiaSoft'), 352, (SELECT FORMAT_ID FROM bookformats WHERE FORMAT_NAME = '60х84/16'), '1996-03-20', 5000, (SELECT THEME_ID FROM theme WHERE THEME_NAME = 'Операційні системи'), (SELECT CATEGORY_ID FROM categories WHERE CATEGORY_NAME = 'Інші операційні системи')),
(206, 5176, 'No', 'Windows Ме. Супутник користувача', 12.79, (SELECT PUBLISHER_ID FROM publishernames WHERE PUBLISHER_NAME = 'Видавнича група BHV'), 306, NULL, '2000-10-10', 5000, (SELECT THEME_ID FROM theme WHERE THEME_NAME = 'Операційні системи'), (SELECT CATEGORY_ID FROM categories WHERE CATEGORY_NAME = 'Інші операційні системи')),
(209, 5462, 'No', 'Мова програмування С++. Лекції та вправи', 29.00, (SELECT PUBLISHER_ID FROM publishernames WHERE PUBLISHER_NAME = 'DiaSoft'), 656, (SELECT FORMAT_ID FROM bookformats WHERE FORMAT_NAME = '84х108/16'), '2000-12-12', 5000, (SELECT THEME_ID FROM theme WHERE THEME_NAME = 'Програмування'), (SELECT CATEGORY_ID FROM categories WHERE CATEGORY_NAME = 'C&C++')),
(210, 4982, 'No', 'Мова програмування С. Лекції та вправи', 29.00, (SELECT PUBLISHER_ID FROM publishernames WHERE PUBLISHER_NAME = 'DiaSoft'), 432, (SELECT FORMAT_ID FROM bookformats WHERE FORMAT_NAME = '84х108/16'), '2000-07-12', 5000, (SELECT THEME_ID FROM theme WHERE THEME_NAME = 'Програмування'), (SELECT CATEGORY_ID FROM categories WHERE CATEGORY_NAME = 'C&C++')),
(220, 4687, 'No', 'Ефективне використання C++ .50 рекомендацій щодо покращення ваших програм та проектів', 17.60, (SELECT PUBLISHER_ID FROM publishernames WHERE PUBLISHER_NAME = 'ДМК'), 240, (SELECT FORMAT_ID FROM bookformats WHERE FORMAT_NAME = '70х100/16'), '2000-02-03', 5000, (SELECT THEME_ID FROM theme WHERE THEME_NAME = 'Програмування'), (SELECT CATEGORY_ID FROM categories WHERE CATEGORY_NAME = 'C&C++')),
(222, 235, 'No', 'Інформаційні системи і структури даних', NULL, (SELECT PUBLISHER_ID FROM publishernames WHERE PUBLISHER_NAME = 'Києво-Могилянська академія'), 288, (SELECT FORMAT_ID FROM bookformats WHERE FORMAT_NAME = '60х90/16'), NULL, 400, (SELECT THEME_ID FROM theme WHERE THEME_NAME = 'Використання ПК в цілому'), (SELECT CATEGORY_ID FROM categories WHERE CATEGORY_NAME = 'Інші книги')),
(225, 8746, 'Yes', 'Бази даних в інформаційних системах', NULL, (SELECT PUBLISHER_ID FROM publishernames WHERE PUBLISHER_NAME = 'Університет "Україна"'), 418, (SELECT FORMAT_ID FROM bookformats WHERE FORMAT_NAME = '60х84/16'), '2018-07-25', 100, (SELECT THEME_ID FROM theme WHERE THEME_NAME = 'Програмування'), (SELECT CATEGORY_ID FROM categories WHERE CATEGORY_NAME = 'SQL')),
(226, 2154, 'Yes', 'Сервер на основі операційної системи FreeBSD 6.1', 0, (SELECT PUBLISHER_ID FROM publishernames WHERE PUBLISHER_NAME = 'Університет "Україна"'), 216, (SELECT FORMAT_ID FROM bookformats WHERE FORMAT_NAME = '60х84/16'), '2015-03-11', 500, (SELECT THEME_ID FROM theme WHERE THEME_NAME = 'Програмування'), (SELECT CATEGORY_ID FROM categories WHERE CATEGORY_NAME = 'Інші операційні системи')),
(245, 2662, 'No', 'Організація баз даних та знань', 0, (SELECT PUBLISHER_ID FROM publishernames WHERE PUBLISHER_NAME = 'Вінниця: ВДТУ'), 208, (SELECT FORMAT_ID FROM bookformats WHERE FORMAT_NAME = '60х90/16'), '2001-10-10', 1000, (SELECT THEME_ID FROM theme WHERE THEME_NAME = 'Програмування'), (SELECT CATEGORY_ID FROM categories WHERE CATEGORY_NAME = 'SQL')),
(247, 5641, 'Yes', 'Організація баз даних та знань', 0, (SELECT PUBLISHER_ID FROM publishernames WHERE PUBLISHER_NAME = 'Видавнича група BHV'), 384, (SELECT FORMAT_ID FROM bookformats WHERE FORMAT_NAME = '70х100/16'), '2021-12-15', 5000, (SELECT THEME_ID FROM theme WHERE THEME_NAME = 'Програмування'), (SELECT CATEGORY_ID FROM categories WHERE CATEGORY_NAME = 'SQL'));

#5.Створити і перевірити уявлення для отримання універсального відношення з набору нормалізованих таблиць бази даних
SELECT
    m.ID,
    m.Code,
    m.NewEntry,
    m.Title,
    m.Price,
    p.PUBLISHER_NAME AS Publisher,
    m.Pages,
    f.FORMAT_NAME AS Format,
    m.DatePublished,
    m.Edition,
    t.THEME_NAME AS Theme,
    c.CATEGORY_NAME AS Category
FROM
    maininfo m
INNER JOIN
    publishernames p ON m.Publisher = p.PUBLISHER_ID
INNER JOIN
    bookformats f ON m.Format = f.FORMAT_ID
INNER JOIN
    theme t ON m.Theme = t.THEME_ID
INNER JOIN
    categories c ON m.Category = c.CATEGORY_ID;

























