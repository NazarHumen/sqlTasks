#1. Вивести книги у яких не введена ціна або ціна дорівнює 0
SELECT * FROM books WHERE Price IS NULL OR Price = 0;

#2. Вивести книги у яких введена ціна, але не введений тираж
SELECT * FROM books WHERE Price IS NOT NULL AND Edition IS NULL;

#3. Вивести книги, про дату видання яких нічого не відомо.
SELECT * FROM books WHERE DatePublished IS NULL;

#4. Вивести книги, з дня видання яких пройшло не більше року.
SELECT * FROM books WHERE DatePublished >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR );

#5. Вивести список книг-новинок, відсортованих за зростанням ціни
SELECT * FROM books WHERE NewEntry = 'YES' ORDER BY Price ASC;

#6. Вивести список книг з числом сторінок від 300 до 400, відсортованих в зворотному алфавітному порядку назв
SELECT * FROM books WHERE Pages BETWEEN 300 AND 400 ORDER BY Title DESC;

#7. Вивести список книг з ціною від 20 до 40, відсортованих за спаданням дати
SELECT * FROM books WHERE Price BETWEEN 20 AND 40 ORDER BY DatePublished DESC;

#8. Вивести список книг, відсортованих в алфавітному порядку назв і ціною по спадаючій
SELECT * FROM books ORDER BY Title ASC , Price DESC;

#9. Вивести книги, у яких ціна однієї сторінки < 10 копійок.
SELECT * FROM books WHERE Price / Pages < 0.1;

#10. Вивести значення наступних колонок: число символів в назві, перші 20 символів назви великими літерами
SELECT
    LENGTH(Title) AS NumCharacters,
    UPPER(SUBSTRING(Title, 1, 20)) AS First20UpperCase
FROM
    books;

#11. Вивести значення наступних колонок: перші 10 і останні 10 символів назви прописними буквами, розділені '...'
SELECT
    LOWER(CONCAT(
        UPPER(SUBSTRING(Title, 1, 10)),
        '...',
        UPPER(SUBSTRING(Title, -10))
    )) AS FirstLast10Upper
FROM
    books;

#12. Вивести значення наступних колонок: назва, дата, день, місяць, рік
SELECT
    Title,
    DatePublished,
    DAY(DatePublished) AS Day,
    MONTH(DatePublished) AS Month,
    YEAR(DatePublished) AS Year
FROM
    books;

#13. Вивести значення наступних колонок: назва, дата, дата в форматі 'dd / mm / yyyy'
SELECT
    Title,
    DatePublished,
    DATE_FORMAT(DatePublished, '%d / %m / %Y') AS FormattedDate
FROM
    books;

#14. Вивести значення наступних колонок: код, ціна, ціна в грн., ціна в євро, ціна в руб.
SELECT
    Code,
    Price,
    Price *  38.81 AS Price_UAH,
    Price * 0.92 AS Price_EUR,
    Price * 92.54 AS Price_RUB
FROM
    books;

#15. Вивести значення наступних колонок: код, ціна, ціна в грн. без копійок, ціна без копійок округлена
SELECT
    Code,
    Price,
    FLOOR(Price * 38.81) AS Price_UAH_without_cents,
    ROUND(Price * 38.81) AS Price_UAH_rounded
FROM
    books;

#16. Додати інформацію про нову книгу (всі колонки)
INSERT INTO books(ID, Code, NewEntry, Title, Price, Publisher, Pages, Format, DatePublished, Edition, Theme, Category)
VALUES(0101, 5585, 'YES', 'Програмування мовою Python', 20.5, 'Навчальна книга - Богдан', 200, '70х100/16', '2023-08-13', 1000, 'Книга присвячена мові програмування Python', 'Підручники');

#17. Додати інформацію про нову книгу (колонки обов'язкові для введення)
INSERT INTO books(ID, Code, NewEntry, Title, Price, Publisher, Pages, Format, DatePublished, Edition, Theme, Category)
VALUES(99, 9021, 'YES', 'Книга Чистий код.', 50.5, 'Фабула', 300, '70х100/16', '2024-02-15', 1000, 'Навіть поганий програмний код може працювати.', 'Підручники');

#18. Видалити книги, видані до 1990 року
DELETE FROM books WHERE EXTRACT(YEAR FROM DatePublished) < 1990;

#19. Проставити поточну дату для тих книг, у яких дата видання відсутня
UPDATE books SET DatePublished = CURRENT_DATE WHERE DatePublished IS NULL;


#20. Установити ознаку новинка для книг виданих після 2005 року
UPDATE books SET NewEntry = 'YES' WHERE EXTRACT(YEAR FROM DatePublished) > 2005;



