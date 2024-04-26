#1.Вивести значення наступних колонок: назва книги, ціна, назва видавництва, формат.
DELIMITER //
CREATE PROCEDURE proc1()
BEGIN
    SELECT
        m.Title AS BookTitle,
        m.Price,
        p.PUBLISHER_NAME AS Publisher,
        f.FORMAT_NAME AS Format
    FROM
        maininfo m
    INNER JOIN
        publishernames p ON m.Publisher = p.PUBLISHER_ID
    INNER JOIN
        bookformats f ON m.Format = f.FORMAT_ID;
END//
DELIMITER ;
CALL proc1();

#2.Вивести значення наступних колонок: тема, категорія, назва книги, назва видавництва. Фільтр по темам і категоріям.
DELIMITER //
CREATE PROCEDURE proc2(
    IN themeName VARCHAR(255),
    IN categoryName VARCHAR(255)
)
BEGIN
    SELECT
        t.THEME_NAME AS Theme,
        c.CATEGORY_NAME AS Category,
        m.Title AS BookTitle,
        p.PUBLISHER_NAME AS Publisher
    FROM
        maininfo m
    INNER JOIN
        publishernames p ON m.Publisher = p.PUBLISHER_ID
    INNER JOIN
        theme t ON m.Theme = t.THEME_ID
    INNER JOIN
        categories c ON m.Category = c.CATEGORY_ID
    WHERE
        t.THEME_NAME = themeName
        AND c.CATEGORY_NAME = categoryName;
END//
DELIMITER ;
CALL proc2('Операційні системи', 'Windows 2000');



#3.Вивести книги видавництва 'BHV', видані після 2000 р
DELIMITER //
CREATE PROCEDURE proc3()
BEGIN
    SELECT m.Title
    FROM maininfo m
    INNER JOIN publishernames p ON m.Publisher = p.PUBLISHER_ID
    WHERE p.PUBLISHER_NAME = 'Видавнича група BHV' AND m.DatePublished > '2000-01-01';
END //
DELIMITER ;
CALL proc3();

#4.Вивести загальну кількість сторінок по кожній назві категорії. Фільтр по спадаючій / зростанню кількості сторінок.
DELIMITER //
CREATE PROCEDURE proc4()
BEGIN
    SELECT
        c.CATEGORY_NAME AS Category,
        SUM(m.Pages) AS TotalPages
    FROM
        maininfo m
    INNER JOIN
        categories c ON m.Category = c.CATEGORY_ID
    GROUP BY
        c.CATEGORY_NAME
    ORDER BY
        TotalPages DESC;
END //
DELIMITER ;
CALL proc4();

#5.Вивести середню вартість книг по темі 'Використання ПК' і категорії 'Linux'.
DELIMITER //

CREATE PROCEDURE proc5()
BEGIN
    SELECT AVG(m.Price) AS AveragePrice
    FROM maininfo m
    INNER JOIN theme t ON m.Theme = t.THEME_ID
    INNER JOIN categories c ON m.Category = c.CATEGORY_ID
    WHERE t.THEME_NAME = 'Використання ПК в цілому' AND c.CATEGORY_NAME = 'Linux';
END //
DELIMITER ;
CALL proc5();

#6.Вивести всі дані універсального відношення.
DELIMITER //
CREATE PROCEDURE proc6()
BEGIN
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
END //
DELIMITER ;
CALL proc6();

#7.Вивести пари книг, що мають однакову кількість сторінок.
DELIMITER //
CREATE PROCEDURE proc7()
BEGIN
    SELECT
        A.Title AS Book_1,
        B.Title AS Book_2,
        A.Pages
    FROM
        maininfo A
    JOIN
        maininfo B ON A.Pages = B.Pages AND A.ID < B.ID;
END //
DELIMITER ;
CALL proc7();

#8.Вивести тріади книг, що мають однакову ціну.
DELIMITER //
CREATE PROCEDURE proc8()
BEGIN
    SELECT DISTINCT
        b1.Title AS Title_1,
        b2.Title AS Title_2,
        b3.Title AS Title_3,
        b1.Price
    FROM
        maininfo AS b1
    JOIN
        maininfo AS b2 ON b1.Price = b2.Price AND b1.ID < b2.ID
    JOIN
        maininfo AS b3 ON b2.Price = b3.Price AND b2.ID < b3.ID;
END //
DELIMITER ;
CALL proc8();

#9.Вивести всі книги категорії 'C ++'.
DELIMITER //
CREATE PROCEDURE proc9()
BEGIN
    SELECT
        m.Title,
        c.CATEGORY_NAME AS Category
    FROM
        maininfo m
    INNER JOIN
        categories c ON m.Category = c.CATEGORY_ID
    WHERE
        c.CATEGORY_NAME = 'C&C++';
END //
DELIMITER ;
CALL proc9();

#10.Вивести список видавництв, у яких розмір книг перевищує 400 сторінок.
DELIMITER //
CREATE PROCEDURE proc10()
BEGIN
    SELECT DISTINCT
        p.PUBLISHER_NAME AS Publisher
    FROM
        maininfo AS m1
    INNER JOIN
        publishernames p ON m1.Publisher = p.PUBLISHER_ID
    WHERE
        (SELECT COUNT(*)
         FROM maininfo AS m2
         WHERE m2.Publisher = m1.Publisher AND m2.Pages > 400) > 0;
END //
DELIMITER ;
CALL proc10();

#11.Вивести список категорій за якими більше 3-х книг.
DELIMITER //

CREATE PROCEDURE proc11()
BEGIN
    SELECT DISTINCT
        c.CATEGORY_NAME AS Category
    FROM
        maininfo AS m1
    INNER JOIN
        categories c ON m1.Category = c.CATEGORY_ID
    WHERE
        (SELECT COUNT(*)
         FROM maininfo AS m2
         WHERE m2.Category = m1.Category) > 3;
END //
DELIMITER ;
CALL proc11();

#12.Вивести список книг видавництва 'BHV', якщо в списку є хоча б одна книга цього видавництва.\
DELIMITER //
CREATE PROCEDURE proc12()
BEGIN
    SELECT *
    FROM maininfo m
    WHERE EXISTS (
        SELECT 1
        FROM publishernames p
        WHERE p.PUBLISHER_NAME = 'Видавнича група BHV'
        AND p.PUBLISHER_ID = m.Publisher
    );
END //
DELIMITER ;
CALL proc12();

#13.Вивести список книг видавництва 'BHV', якщо в списку немає жодної книги цього видавництва.
DELIMITER //
CREATE PROCEDURE proc13()
BEGIN
    SELECT *
    FROM maininfo m
    WHERE NOT EXISTS (
        SELECT 1
        FROM publishernames p
        WHERE p.PUBLISHER_NAME = 'Видавнича група BHV'
        AND p.PUBLISHER_ID = m.Publisher
    );
END //
DELIMITER ;
CALL proc13();

#14.Вивести відсортоване загальний список назв тем і категорій.
DELIMITER //
CREATE PROCEDURE proc14()
BEGIN
    SELECT THEME_NAME AS Name
    FROM theme
    UNION
    SELECT CATEGORY_NAME AS Name
    FROM categories
    ORDER BY Name;
END //
DELIMITER ;
CALL proc14();

#15.Вивести відсортований в зворотному порядку загальний список перших слів назв книг і категорій що не повторюються
DELIMITER //
CREATE PROCEDURE proc15()
BEGIN
    SELECT SUBSTRING_INDEX(Title, ' ', 1) AS First_Word
    FROM maininfo
    UNION
    SELECT SUBSTRING_INDEX(CATEGORY_NAME, ' ', 1) AS First_Word
    FROM categories
    ORDER BY First_Word DESC;
END //
DELIMITER ;
CALL proc15();





