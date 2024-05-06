# Проектування користувальницьких функцій (user defined function). Робота з SQL курсором (cursor).
# 1.    Розробити та перевірити скалярну (scalar) функцію, що повертає загальну вартість книг виданих в певному році.
DELIMITER //
CREATE FUNCTION Total_Books_Cost(year_published YEAR)
RETURNS DECIMAL(10,2)
BEGIN
    DECLARE total_cost DECIMAL(10,2);
    SELECT SUM(Price) INTO total_cost
    FROM maininfo
    WHERE YEAR(DatePublished) = year_published;
    RETURN COALESCE(total_cost, 0);
END //
DELIMITER ;
SELECT Total_Books_Cost(2000) AS Total_Cost;

# 2.Розробити і перевірити табличну (inline) функцію, яка повертає список книг виданих в певному році.
# Табличні функції тільки в SQL Server, немає в MySQL
DELIMITER //
CREATE PROCEDURE Get_Books_By_Year(year_published YEAR)
BEGIN
    SELECT *
    FROM maininfo
    WHERE YEAR(DatePublished) = year_published;
END //
DELIMITER ;
CALL Get_Books_By_Year(2000);

# 3.    Розробити і перевірити функцію типу multi-statement, яка буде:
#      a.приймати в якості вхідного параметра рядок, що містить список назв видавництв, розділених символом ‘;’;
DELIMITER //
CREATE PROCEDURE Insert_Publishers(IN publisherList VARCHAR(4000))
BEGIN
    DECLARE semicolon_index INT DEFAULT 0;
    DECLARE pub_name VARCHAR(255);
    IF TRIM(publisherList) != '' THEN
        SET publisherList = CONCAT(TRIM(publisherList), ';');
        WHILE LOCATE(';', publisherList) > 0
            DO
                SET semicolon_index = LOCATE(';', publisherList);
                SET pub_name = TRIM(SUBSTRING(publisherList, 1, semicolon_index - 1));
                SET publisherList = SUBSTRING(publisherList, semicolon_index + 1);
                IF LENGTH(pub_name) > 0 THEN
                    INSERT IGNORE INTO publishernames (PUBLISHER_NAME) VALUES (pub_name);
                END IF;
            END WHILE;
    END IF;
END //
DELIMITER ;
CALL Insert_Publishers('Видавнича група BHV;Вільямс;МикроАрт;DiaSoft;ДМК;Фабула');

#      b.    виділяти з цього рядка назву видавництва;
DELIMITER //
CREATE PROCEDURE Extract_Publishers(IN publisherList VARCHAR(4000))
BEGIN
    DECLARE semicolon_index INT DEFAULT 0;
    DECLARE pub_name VARCHAR(255);
    DECLARE done INT DEFAULT 0;
    DECLARE cur CURSOR FOR SELECT Publisher_Name FROM TempPublishers;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    CREATE TEMPORARY TABLE IF NOT EXISTS TempPublishers (
        Publisher_Name VARCHAR(255)
    );
    TRUNCATE TABLE TempPublishers;
    SET publisherList = CONCAT(TRIM(publisherList), ';');
    WHILE LOCATE(';', publisherList) > 0 DO
        SET semicolon_index = LOCATE(';', publisherList);
        SET pub_name = TRIM(SUBSTRING(publisherList, 1, semicolon_index - 1));
        SET publisherList = SUBSTRING(publisherList, semicolon_index + 1);
        IF LENGTH(pub_name) > 0 THEN
            INSERT INTO TempPublishers (Publisher_Name) VALUES (pub_name);
        END IF;
    END WHILE;
    OPEN cur;
    fetch_loop: LOOP
        FETCH cur INTO pub_name;
        IF done THEN
            LEAVE fetch_loop;
        END IF;
        SELECT pub_name;
    END LOOP;
    CLOSE cur;
    DROP TABLE TempPublishers;
END //
DELIMITER ;
CALL Extract_Publishers('Видавнича група BHV;Вільямс;МикроАрт;DiaSoft;ДМК;Фабула');

#      c.    формувати нумерований список назв видавництв.
DELIMITER //
CREATE PROCEDURE Extract_And_Number_Publishers(IN publisherList VARCHAR(4000))
BEGIN
    DECLARE semicolon_index INT DEFAULT 0;
    DECLARE pub_name VARCHAR(255);
    DECLARE counter INT DEFAULT 1; -- Змінна для нумерації
    DECLARE done INT DEFAULT 0;
    DECLARE cur CURSOR FOR SELECT Publisher_Name FROM TempPublishers;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    CREATE TEMPORARY TABLE IF NOT EXISTS TempPublishers (
        Publisher_Name VARCHAR(255)
    );
    TRUNCATE TABLE TempPublishers;
    SET publisherList = CONCAT(TRIM(publisherList), ';');
    WHILE LOCATE(';', publisherList) > 0 DO
        SET semicolon_index = LOCATE(';', publisherList);
        SET pub_name = TRIM(SUBSTRING(publisherList, 1, semicolon_index - 1));
        SET publisherList = SUBSTRING(publisherList, semicolon_index + 1);
        IF LENGTH(pub_name) > 0 THEN
            INSERT INTO TempPublishers (Publisher_Name) VALUES (pub_name);
        END IF;
    END WHILE;
    OPEN cur;
    fetch_loop: LOOP
        FETCH cur INTO pub_name;
        IF done THEN
            LEAVE fetch_loop;
        END IF;
        SELECT CONCAT(counter, '. ', pub_name) AS NumberedPublisher;
        SET counter = counter + 1; -- Збільшення лічильника
    END LOOP;
    CLOSE cur;
    DROP TABLE TempPublishers;
END //
DELIMITER ;
CALL Extract_And_Number_Publishers('Видавнича група BHV;Вільямс;МикроАрт;DiaSoft;ДМК;Фабула');

# 4.Виконати набір операцій по роботі з SQL курсором:
# оголосити курсор;
# a.використовувати змінну для оголошення курсору;
# b.відкрити курсор;
# c.переприсвоїти курсор іншої змінної;
# d.виконати вибірку даних з курсору;
# e.закрити курсор;
DELIMITER //
CREATE PROCEDURE Example_With_Cursor()
BEGIN
#     a. Оголошення змінної для зберігання даних з курсору
    DECLARE fetched_data DECIMAL(10,2);
    DECLARE finished INTEGER DEFAULT 0;
#     Оголошення курсора
    DECLARE book_prices CURSOR FOR SELECT Price FROM maininfo WHERE YEAR(DatePublished) = 1997;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
#     b. Відкриття курсора
    OPEN book_prices;
#     d. Читання даних з курсора в циклі
    read_loop: LOOP
        FETCH book_prices INTO fetched_data;
        IF finished = 1 THEN
            LEAVE read_loop;
        END IF;
        SELECT fetched_data;
    END LOOP;
#     e. Закриття курсора
    CLOSE book_prices;
END //
DELIMITER ;
CALL Example_With_Cursor();
# 5.звільнити курсор. Розробити курсор для виводу списка книг виданих у визначеному році.
#Звільнення ресурсів курсора в MySQL не потрібно, оскільки вони автоматично очищуються після закриття
DELIMITER $$
CREATE PROCEDURE Get_Books_By_Year(p_year INT)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_id INT;
    DECLARE v_code INT;
    DECLARE v_title VARCHAR(255);
    DECLARE v_price DECIMAL(10,2);
    DECLARE v_publisher INT;
    DECLARE v_pages INT;
    DECLARE v_format INT;
    DECLARE v_datePublished DATE;
    DECLARE v_edition INT;
    DECLARE v_theme INT;
    DECLARE v_category INT;
    DECLARE book_cursor CURSOR FOR
        SELECT ID, Code, Title, Price, Publisher, Pages, Format, DatePublished, Edition, Theme, Category
        FROM maininfo
        WHERE YEAR(DatePublished) = p_year;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN book_cursor;
    FETCH_LOOP: LOOP
        FETCH book_cursor INTO v_id, v_code, v_title, v_price, v_publisher, v_pages, v_format, v_datePublished, v_edition, v_theme, v_category;
        IF done THEN
            LEAVE FETCH_LOOP;
        END IF;
        SELECT v_id, v_code, v_title, v_price, v_publisher, v_pages, v_format, v_datePublished, v_edition, v_theme, v_category;
    END LOOP;
    CLOSE book_cursor;
END$$
DELIMITER ;
CALL Get_Books_By_Year(2000);




