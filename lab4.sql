#1.Вивести статистику: загальна кількість всіх книг, їх вартість, їх середню вартість, мінімальну і максимальну ціну
SELECT
    COUNT(*) AS totalBooks,
    SUM(price) AS totalPrice,
    AVG(price) AS averagePrice,
    MIN(price) AS minPrice,
    MAX(price) AS maxPrice
FROM
    books;

#2.Вивести загальну кількість всіх книг без урахування книг з непроставленою ціною
SELECT COUNT(*) AS totalBooks FROM books WHERE price IS NOT NULL;


#3.Вивести статистику (див. 1) для книг новинка / не новинка
SELECT
    NewEntry,
    COUNT(*) AS totalBooks,
    SUM(price) AS totalPrice,
    AVG(price) AS averagePrice,
    MIN(price) AS minPrice,
    MAX(price) AS maxPrice
FROM
    books
GROUP BY
    NewEntry;

#4.Вивести статистику (див. 1) для книг за кожним роком видання
SELECT
    DatePublished,
    COUNT(*) AS totalBooks,
    SUM(price) AS totalPrice,
    AVG(price) AS averagePrice,
    MIN(price) AS minPrice,
    MAX(price) AS maxPrice
FROM
    books
GROUP BY
    DatePublished;

#5.Змінити п.4, виключивши з статистики книги з ціною від 10 до 20
SELECT
    DatePublished,
    COUNT(*) AS totalBooks,
    SUM(price) AS totalPrice,
    AVG(price) AS averagePrice,
    MIN(price) AS minPrice,
    MAX(price) AS maxPrice
FROM
    books
WHERE Price < 10 OR Price > 20 OR Price IS NULL
GROUP BY
    DatePublished;

#6.Змінити п.4. Відсортувати статистику по спадаючій кількості.
SELECT
    DatePublished,
    COUNT(*) AS totalBooks,
    SUM(price) AS totalPrice,
    AVG(price) AS averagePrice,
    MIN(price) AS minPrice,
    MAX(price) AS maxPrice
FROM
    books
GROUP BY
    DatePublished
ORDER BY totalBooks DESC;

#7.Вивести загальну кількість кодів книг і кодів книг що не повторюються
SELECT
    COUNT(*) AS totalBookCodes,
    COUNT(DISTINCT Code) AS uniqueCodes
FROM books;

#8.Вивести статистику: загальна кількість і вартість книг по першій букві її назви
SELECT
    SUBSTRING(Title, 1, 1) AS firstLetter,
    COUNT(*) AS totalBooks,
    SUM(Price) AS totalPrice
FROM
    books
GROUP BY
    SUBSTRING(Title, 1, 1)
ORDER BY
    firstLetter;

#9.Змінити п. 8, виключивши з статистики назви що починаються з англ. букви або з цифри.
SELECT
    SUBSTRING(Title, 1, 1) AS firstLetter,
    COUNT(*) AS totalBooks,
    SUM(Price) AS totalPrice
FROM
    books
WHERE
    NOT (SUBSTRING(Title, 1, 1) BETWEEN 'A' AND 'Z' OR SUBSTRING(Title, 1, 1) BETWEEN '0' AND '9')
GROUP BY
    SUBSTRING(Title, 1, 1)
ORDER BY
    firstLetter;

#10.Змінити п. 9 так щоб до складу статистики потрапили дані з роками більшими за 2000.
SELECT
    DatePublished,
    SUBSTRING(Title, 1, 1) AS firstLetter,
    COUNT(*) AS totalBooks,
    SUM(Price) AS totalPrice
FROM
    books
WHERE
    YEAR(DatePublished) > 2000
    AND NOT (SUBSTRING(Title, 1, 1) BETWEEN 'A' AND 'Z' OR SUBSTRING(Title, 1, 1) BETWEEN '0' AND '9')
GROUP BY
    SUBSTRING(Title, 1, 1),
    YEAR(DatePublished)
ORDER BY
    firstLetter;

#11.Змінити п. 10. Відсортувати статистику по спадаючій перших букв назви.
SELECT
    DatePublished,
    SUBSTRING(Title, 1, 1) AS firstLetter,
    COUNT(*) AS totalBooks,
    SUM(Price) AS totalPrice
FROM
    books
WHERE
    YEAR(DatePublished) > 2000
    AND NOT (SUBSTRING(Title, 1, 1) BETWEEN 'A' AND 'Z' OR SUBSTRING(Title, 1, 1) BETWEEN '0' AND '9')
GROUP BY
    SUBSTRING(Title, 1, 1),
    YEAR(DatePublished) > 2000
ORDER BY
    firstLetter DESC;

#12.Вивести статистику (див. 1) по кожному місяцю кожного року.
SELECT
    EXTRACT(YEAR FROM DatePublished) AS publicationYear,
    EXTRACT(MONTH FROM DatePublished) AS publicationMonth,
    COUNT(*) AS totalBooks,
    SUM(Price) AS totalPrice,
    AVG(price) AS averagePrice,
    MIN(price) AS minPrice,
    MAX(price) AS maxPrice
FROM
    books
GROUP BY
    EXTRACT(YEAR FROM DatePublished),
    EXTRACT(MONTH FROM DatePublished)
ORDER BY
    publicationYear, publicationMonth;

#13.Змінити п. 12 так щоб до складу статистики не увійшли дані з незаповненими датами.
SELECT
    EXTRACT(YEAR FROM DatePublished) AS publicationYear,
    EXTRACT(MONTH FROM DatePublished) AS publicationMonth,
    COUNT(*) AS totalBooks,
    SUM(Price) AS totalPrice,
    AVG(price) AS averagePrice,
    MIN(price) AS minPrice,
    MAX(price) AS maxPrice
FROM
    books
WHERE
    DatePublished IS NOT NULL
GROUP BY
    EXTRACT(YEAR FROM DatePublished),
    EXTRACT(MONTH FROM DatePublished)
ORDER BY
    publicationYear, publicationMonth;

#14.Змінити п. 12. Фільтр по спадаючій року і зростанню місяця.
SELECT
    EXTRACT(YEAR FROM DatePublished) AS publicationYear,
    EXTRACT(MONTH FROM DatePublished) AS publicationMonth,
    COUNT(*) AS totalBooks,
    SUM(Price) AS totalPrice,
    AVG(price) AS averagePrice,
    MIN(price) AS minPrice,
    MAX(price) AS maxPrice
FROM
    books
GROUP BY
    EXTRACT(YEAR FROM DatePublished),
    EXTRACT(MONTH FROM DatePublished)
ORDER BY
    publicationYear DESC, publicationMonth ASC;

#15.Вивести статистику для книг новинка / не новинка: загальна ціна, загальна ціна в грн. / Євро / руб. Колонкам запиту дати назви за змістом.
SELECT
    NewEntry,
    SUM(price) AS totalPrice,
    SUM(price * 38.8) AS totalPriceUAH,
    SUM(price * 0.92) AS totalPriceEUR,
    SUM(price * 92.54) AS totalPriceRUB
FROM
    books
GROUP BY
    NewEntry;

#16.Змінити п. 15 так щоб виводилася округлена до цілого числа (дол. / Грн. / Євро / руб.) Ціна.
SELECT
    NewEntry,
    ROUND(SUM(price)) AS totalPriceUSD,
    ROUND(SUM(price * 38.8)) AS totalPriceUAH,
    ROUND(SUM(price * 0.92)) AS totalPriceEUR,
    ROUND(SUM(price * 92.54)) AS totalPriceRUB
FROM
    books
GROUP BY
    NewEntry;

#17.Вивести статистику (див. 1) по видавництвах.
SELECT
    Publisher,
    COUNT(*) AS totalBooks,
    SUM(price) AS totalPrice,
    AVG(price) AS averagePrice,
    MIN(price) AS minPrice,
    MAX(price) AS maxPrice
FROM
    books
GROUP BY
    Publisher;

#18.Вивести статистику (див. 1) за темами і видавництвами. Фільтр по видавництвам.
SELECT
    Theme,
    Publisher,
    COUNT(*) AS totalBooks,
    SUM(price) AS totalPrice,
    AVG(price) AS averagePrice,
    MIN(price) AS minPrice,
    MAX(price) AS maxPrice
FROM
    books
GROUP BY Publisher;

#19.Вивести статистику (див. 1) за категоріями, темами і видавництвами. Фільтр по видавництвам, темах, категоріям.
SELECT
    Publisher,
    Theme,
    Category,
    COUNT(*) AS totalBooks,
    SUM(price) AS totalPrice,
    AVG(price) AS averagePrice,
    MIN(price) AS minPrice,
    MAX(price) AS maxPrice
FROM
    books
GROUP BY
    Publisher,
    Theme,
    Category;

#20.Вивести список видавництв, у яких округлена до цілого ціна однієї сторінки більше 10 копійок.
SELECT Publisher FROM books WHERE ROUND(Price/Pages) > 0.10;




















