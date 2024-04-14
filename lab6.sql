#ЛР №6
#Проектування багатотабличних запитів (внутрішнє з'єднання, inner join, left join, right join, self join, subquery, correlated subquery, exists, not exist, union)
#1.Вивести значення наступних колонок: назва книги, ціна, назва видавництва. Використовувати внутрішнє з'єднання, застосовуючи where.
SELECT m.Title, m.Price, p.PUBLISHER_NAME
FROM maininfo m
INNER JOIN publishernames p ON m.Publisher = p.PUBLISHER_ID
WHERE m.Price > 10;

#2.Вивести значення наступних колонок: назва книги, назва категорії. Використовувати внутрішнє з'єднання, застосовуючи inner join.
SELECT m.Title, c.CATEGORY_NAME
FROM maininfo m
INNER JOIN categories c ON m.Category = c.CATEGORY_ID;

#3.Вивести значення наступних колонок: назва книги, ціна, назва видавництва, формат.
SELECT m.Title, m.Price, p.PUBLISHER_NAME, m.Format
FROM maininfo m
INNER JOIN publishernames p ON m.Publisher = p.PUBLISHER_ID;


#4.Вивести значення наступних колонок: тема, категорія, назва книги, назва видавництва. Фільтр по темам і категоріям.
SELECT t.THEME_NAME, c.CATEGORY_NAME, m.Title, p.PUBLISHER_NAME
FROM maininfo m
INNER JOIN theme t ON m.Theme = t.THEME_ID
INNER JOIN categories c ON m.Category = c.CATEGORY_ID
INNER JOIN publishernames p ON m.Publisher = p.PUBLISHER_ID
WHERE t.THEME_NAME = 'Операційні системи' AND c.CATEGORY_NAME = 'Windows 2000';

#5.Вивести книги видавництва 'BHV', видані після 2000 р
SELECT m.Title
FROM maininfo m
INNER JOIN publishernames p ON m.Publisher = p.PUBLISHER_ID
WHERE p.PUBLISHER_NAME = 'Видавнича група BHV' AND m.DatePublished > '2000-01-01';

#6.Вивести загальну кількість сторінок по кожній назві категорії. Фільтр по спадаючій кількості сторінок.
SELECT c.CATEGORY_NAME, SUM(m.Pages) AS TotalPages
FROM maininfo m
INNER JOIN categories c ON m.Category = c.CATEGORY_ID
GROUP BY c.CATEGORY_NAME
ORDER BY totalPages DESC;

#7.Вивести середню вартість книг по темі 'Використання ПК' і категорії 'Linux'.
SELECT AVG(m.Price) AS AveragePrice
FROM maininfo m
INNER JOIN theme t ON m.Theme = t.THEME_ID
INNER JOIN categories c ON m.Category = c.CATEGORY_ID
WHERE t.THEME_NAME = 'Використання ПК' AND c.CATEGORY_NAME = 'Linux';

#8.Вивести всі дані універсального відношення. Використовувати внутрішнє з'єднання, застосовуючи where.
SELECT maininfo.*,
       publishernames.PUBLISHER_NAME,
       bookformats.FORMAT_NAME,
       theme.THEME_NAME,
       categories.CATEGORY_NAME
FROM maininfo
INNER JOIN publishernames ON maininfo.Publisher = publishernames.PUBLISHER_ID
INNER JOIN bookformats ON maininfo.Format = bookformats.FORMAT_ID
INNER JOIN theme ON maininfo.Theme = theme.THEME_ID
INNER JOIN categories ON maininfo.Category = categories.CATEGORY_ID
WHERE maininfo.Price > 5;


#9.Вивести всі дані універсального відношення. Використовувати внутрішнє з'єднання, застосовуючи inner join.
SELECT maininfo.*,
       publishernames.PUBLISHER_NAME,
       bookformats.FORMAT_NAME,
       theme.THEME_NAME,
       categories.CATEGORY_NAME
FROM maininfo
INNER JOIN publishernames ON maininfo.Publisher = publishernames.PUBLISHER_ID
INNER JOIN bookformats ON maininfo.Format = bookformats.FORMAT_ID
INNER JOIN theme ON maininfo.Theme = theme.THEME_ID
INNER JOIN categories ON maininfo.Category = categories.CATEGORY_ID;

#10.Вивести всі дані універсального відношення. Використовувати зовнішнє з'єднання, застосовуючи left join / rigth join.
SELECT maininfo.*,
       publishernames.PUBLISHER_NAME,
       bookformats.FORMAT_NAME,
       theme.THEME_NAME,
       categories.CATEGORY_NAME
FROM maininfo
LEFT JOIN publishernames ON maininfo.Publisher = publishernames.PUBLISHER_ID
LEFT JOIN bookformats ON maininfo.Format = bookformats.FORMAT_ID
LEFT JOIN theme ON maininfo.Theme = theme.THEME_ID
LEFT JOIN categories ON maininfo.Category = categories.CATEGORY_ID;

#11.Вивести пари книг, що мають однакову кількість сторінок. Використовувати само об’єднання і аліаси (self join).
SELECT A.Title AS Book_1, B.Title AS Book_2, A.Pages
FROM maininfo A
JOIN maininfo B ON A.Pages = B.Pages AND A.ID < B.ID;

#12.Вивести тріади книг, що мають однакову ціну. Використовувати самооб'єднання і аліаси (self join).
SELECT DISTINCT b1.Title AS Title_1, b2.Title AS Title_2, b3.Title AS Title_3, b1.Price
FROM maininfo AS b1
JOIN maininfo AS b2 ON b1.Price = b2.Price AND b1.ID < b2.ID
JOIN maininfo AS b3 ON b2.Price = b3.Price AND b2.ID < b3.ID;

#13.Вивести всі книги категорії 'C ++'. Використовувати підзапити (subquery).
SELECT Title, Category
FROM maininfo
WHERE Category = (SELECT CATEGORY_ID FROM categories WHERE CATEGORY_NAME = 'C&C++');


#14.Вивести книги видавництва 'BHV', видані після 2000 р Використовувати підзапити (subquery).
SELECT *
FROM maininfo
WHERE Publisher IN (
    SELECT PUBLISHER_ID
    FROM publishernames
    WHERE PUBLISHER_NAME = 'Видавнича група BHV'
) AND DatePublished > '2000-01-01';

#15.Вивести список видавництв, у яких розмір книг перевищує 400 сторінок. Використовувати пов'язані підзапити (correlated subquery).
SELECT DISTINCT Publisher
FROM maininfo AS m1
WHERE (SELECT COUNT(*) FROM maininfo AS m2 WHERE m2.Publisher = m1.Publisher AND m2.Pages > 400) > 0;

#16.Вивести список категорій в яких більше 3-х книг. Використовувати пов'язані підзапити (correlated subquery).
SELECT DISTINCT Category
FROM maininfo AS m1
WHERE (SELECT COUNT(*) FROM maininfo AS m2 WHERE m2.Category = m1.Category) > 3;

#17.Вивести список книг видавництва 'BHV', якщо в списку є хоча б одна книга цього видавництва. Використовувати exists.
SELECT *
FROM maininfo m
WHERE EXISTS (
    SELECT 1
    FROM publishernames p
    WHERE p.PUBLISHER_NAME = 'Видавнича група BHV'
    AND p.PUBLISHER_ID = m.Publisher
);

#18.Вивести список книг видавництва 'BHV', якщо в списку немає жодної книги цього видавництва. Використовувати not exists.
SELECT *
FROM maininfo m
WHERE NOT EXISTS (
    SELECT 1
    FROM publishernames p
    WHERE p.PUBLISHER_NAME = 'Видавнича група BHV'
    AND p.PUBLISHER_ID = m.Publisher
);

#19.Вивести відсортований загальний список назв тем і категорій. Використовувати union.
SELECT THEME_NAME AS Name FROM theme
UNION
SELECT CATEGORY_NAME AS Name FROM categories
ORDER BY Name;

#20.Вивести відсортований в зворотному порядку загальний список перших слів, назв книг і категорій що не повторюються. Використовувати union.
SELECT SUBSTRING_INDEX(Title, ' ', 1) AS First_Word FROM maininfo
UNION
SELECT SUBSTRING_INDEX(CATEGORY_NAME, ' ', 1) AS First_Word FROM categories
ORDER BY First_Word DESC;



