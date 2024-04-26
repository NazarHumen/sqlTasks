#Реалізувати набір тригерів, що реалізують такі ділові правила:
#1.Кількість тем може бути в діапазоні від 5 до 10.
DELIMITER $$
CREATE TRIGGER Сheck_Theme_Insert
    BEFORE INSERT
    ON theme
    FOR EACH ROW
BEGIN
    DECLARE Theme_Count INT;
    SELECT COUNT(*) INTO Theme_Count FROM theme;
    IF Theme_Count >= 10 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot insert more than 10 themes.';
    END IF;
END$$
DELIMITER ;
#Перевірки перед вставкою нової теми
INSERT INTO theme (THEME_NAME) VALUES ('Тема 6');
INSERT INTO theme (THEME_NAME) VALUES ('Тема 7');
INSERT INTO theme (THEME_NAME) VALUES ('Тема 8');
INSERT INTO theme (THEME_NAME) VALUES ('Тема 9');
INSERT INTO theme (THEME_NAME) VALUES ('Тема 10');
INSERT INTO theme (THEME_NAME) VALUES ('Тема 11');
DELIMITER ;

DELIMITER $$
CREATE TRIGGER Check_Theme_Delete
    BEFORE DELETE
    ON theme
    FOR EACH ROW
BEGIN
    DECLARE Theme_Count INT;
    SELECT COUNT(*) INTO Theme_Count FROM theme;
    IF Theme_Count <= 5 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot have less than 5 themes.';
    END IF;
END$$
DELIMITER ;

#Перевірки перед видаленням теми
DELETE FROM theme WHERE THEME_ID = 38;
DELETE FROM theme WHERE THEME_ID = 39;
DELETE FROM theme WHERE THEME_ID = 40;
DELETE FROM theme WHERE THEME_ID = 41;
DELETE FROM theme WHERE THEME_ID = 42;
DELETE FROM theme WHERE THEME_ID = 5;

#2.Новинкою може бути тільки книга видана в поточному році.
DELIMITER $$
CREATE TRIGGER Check_New_Entry_Before_Insert
    BEFORE INSERT
    ON maininfo
    FOR EACH ROW
BEGIN
    IF NEW.NewEntry = 'Yes' AND YEAR(NEW.DatePublished) != YEAR(CURRENT_DATE()) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Only books published in the current year can be marked as new.';
    END IF;
END$$

#Вставка нового запису з коректними даними
INSERT INTO maininfo (Code, NewEntry, Title, Price, Publisher, Pages, Format, DatePublished, Edition, Theme, Category)
VALUES (1234, 'Yes', 'Нова книга', 100.00, 1, 200, 1, CURRENT_DATE(), 1, 1, 1);
#Вставка нового запису з некоректними даними
INSERT INTO maininfo (Code, NewEntry, Title, Price, Publisher, Pages, Format, DatePublished, Edition, Theme, Category)
VALUES (1234, 'Yes', 'Стара книга', 100.00, 1, 200, 1, '2020-01-01', 1, 1, 1);

CREATE TRIGGER Check_New_Entry_Before_Update
    BEFORE UPDATE
    ON maininfo
    FOR EACH ROW
BEGIN
    IF NEW.NewEntry = 'Yes' AND YEAR(NEW.DatePublished) != YEAR(CURRENT_DATE()) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Only books published in the current year can be marked as new.';
    END IF;
END$$
DELIMITER ;
#Оновлення існуючого запису з некоректними даними
UPDATE maininfo SET DatePublished = '2000-07-24', NewEntry = 'Yes' WHERE ID = 2;
delete from maininfo where ID = 304;

#3.Книга з кількістю сторінок до 100 не може коштувати більше 10 $, до 200 - 20 $, до 300 - 30 $.
DELIMITER $$
CREATE TRIGGER Check_Book_Price_Before_Insert
BEFORE INSERT ON maininfo
FOR EACH ROW
BEGIN
    IF (NEW.Pages <= 100 AND NEW.Price > 10) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Books up to 100 pages cannot cost more than $10.';
    ELSEIF (NEW.Pages > 100 AND NEW.Pages <= 200 AND NEW.Price > 20) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Books up to 200 pages cannot cost more than $20.';
    ELSEIF (NEW.Pages > 200 AND NEW.Pages <= 300 AND NEW.Price > 30) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Books up to 300 pages cannot cost more than $30.';
    END IF;
END$$

#Вставка книги з некоректною ціною
INSERT INTO maininfo (Code, NewEntry, Title, Price, Publisher, Pages, Format, DatePublished, Edition, Theme, Category)
VALUES (12345, 'No', 'Коротка книга. Завищена ціна', 15.00, 1, 95, 1, '2023-10-01', 1, 1, 1);

#Вставка книги з коректною ціною
INSERT INTO maininfo (Code, NewEntry, Title, Price, Publisher, Pages, Format, DatePublished, Edition, Theme, Category)
VALUES (12346, 'No', 'Середня книга з правильною ціною', 20.00, 1, 150, 1, '2023-10-01', 1, 1, 1);

CREATE TRIGGER Check_Book_Price_Before_Update
BEFORE UPDATE ON maininfo
FOR EACH ROW
BEGIN
    IF (NEW.Pages <= 100 AND NEW.Price > 10) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Books up to 100 pages cannot cost more than $10.';
    ELSEIF (NEW.Pages > 100 AND NEW.Pages <= 200 AND NEW.Price > 20) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Books up to 200 pages cannot cost more than $20.';
    ELSEIF (NEW.Pages > 200 AND NEW.Pages <= 300 AND NEW.Price > 30) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Books up to 300 pages cannot cost more than $30.';
    END IF;
END$$
DELIMITER ;

#Оновлення існуючого запису з некоректною ціною
UPDATE maininfo
SET Price = 25
WHERE ID = 58 AND Pages = 144;

#Оновлення існуючого запису з коректною ціною
UPDATE maininfo
SET Price = 19.00
WHERE ID = 249 AND Pages = 150;

#4.Видавництво "BHV" не випускає книги накладом меншим 5000, а видавництво Diasoft - 10000.
DELIMITER $$
CREATE TRIGGER Check_Minimum_Edition_Before_Insert
BEFORE INSERT ON maininfo
FOR EACH ROW
BEGIN
    IF NEW.Publisher = (SELECT PUBLISHER_ID FROM publishernames WHERE PUBLISHER_NAME = 'BHV') AND NEW.Edition < 5000 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'BHV does not publish books with an edition less than 5000.';
    END IF;
    IF NEW.Publisher = (SELECT PUBLISHER_ID FROM publishernames WHERE PUBLISHER_NAME = 'DiaSoft') AND NEW.Edition < 10000 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'DiaSoft does not publish books with an edition less than 10000.';
    END IF;
END$$

#Вставка запису для Diasoft з недостатнім тиражем
INSERT INTO maininfo (Code, NewEntry, Title, Price, Publisher, Pages, Format, DatePublished, Edition, Theme, Category)
VALUES (43234, 'No', 'Test Book DiaSoft', 20.00, (SELECT PUBLISHER_ID FROM publishernames WHERE PUBLISHER_NAME = 'DiaSoft'), 200, 1, '2023-10-02', 9000, 1, 1);

CREATE TRIGGER Check_Minimum_Edition_Before_Update
BEFORE UPDATE ON maininfo
FOR EACH ROW
BEGIN
    IF NEW.Publisher = (SELECT PUBLISHER_ID FROM publishernames WHERE PUBLISHER_NAME = 'BHV') AND
       NEW.Edition < 5000 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'BHV does not publish books with an edition less than 5000.';
    END IF;
    IF NEW.Publisher = (SELECT PUBLISHER_ID FROM publishernames WHERE PUBLISHER_NAME = 'DiaSoft') AND
       NEW.Edition < 10000 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'DiaSoft does not publish books with an edition less than 10000.';
    END IF;
END$$
DELIMITER ;

#Оновлення існуючого запису для Diasoft з неправильним тиражем
UPDATE maininfo
SET Edition = 10000
WHERE ID = 203 AND Publisher = (SELECT PUBLISHER_ID FROM publishernames WHERE PUBLISHER_NAME = 'DiaSoft');

#5.Книги з однаковим кодом повинні мати однакові дані.
DELIMITER $$
CREATE TRIGGER Check_Book_Code_Before_Insert
BEFORE INSERT ON maininfo
FOR EACH ROW
BEGIN
    DECLARE existing_count INT;
    SELECT COUNT(*) INTO existing_count FROM maininfo WHERE Code = NEW.Code;
    IF existing_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A book with the same code already exists with different data.';
    END IF;
END$$

#Вставка запису з унікальним кодом (має пройти)
INSERT INTO maininfo (Code, Title, Edition, Price) VALUES (123432, 'Test Book 1', 1, 25.00);

#Вставка запису з існуючим кодом, але різними іншими даними (має бути заблоковано)
INSERT INTO maininfo (Code, Title, Edition, Price) VALUES (123432, 'Test Book 2', 1, 30.00);
delete from maininfo where ID = 309;

CREATE TRIGGER Check_Book_Code_Before_Update
BEFORE UPDATE ON maininfo
FOR EACH ROW
BEGIN
    DECLARE existing_count INT;
    SELECT COUNT(*) INTO existing_count FROM maininfo WHERE Code = NEW.Code AND ID != NEW.ID;
    IF existing_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A book with the same code already exists with different data.';
    END IF;
END$$
DELIMITER ;

#Оновлення існуючого запису, зміна ціни (має пройти)
UPDATE maininfo SET Price = 30.00 WHERE Code = 123432;

#Вставка нової книги для подальшого тесту оновлення
INSERT INTO maininfo (Code, Title, Edition, Price) VALUES (12321, 'Test Book 3', 1, 35.00);

#Спроба змінити код на уже існуючий (має бути заблоковано)
UPDATE maininfo SET Code = 12321 WHERE Title = 'Test Book 3';


#6.При спробі видалення книги видається інформація про кількість видалених рядків. Якщо користувач не "dbo", то видалення забороняється.
DELIMITER $$
CREATE TRIGGER Before_Delete_Book
BEFORE DELETE ON maininfo
FOR EACH ROW
BEGIN
    IF SUBSTRING_INDEX(USER(), '@', 1) <> 'dbo' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Only dbo can delete records from this table.';
    END IF;
END$$
DELIMITER ;

INSERT INTO maininfo (Code, Title, Edition, Price) VALUES (15678, 'Test Book 1', 1, 25.00);

#Видалення без коректної ролі
DELETE FROM maininfo WHERE Code = 15678;

#7.Користувач "dbo" не має права змінювати ціну книги.
DELIMITER $$
CREATE TRIGGER Prevent_Price_Change_By_Dbo
BEFORE UPDATE ON maininfo
FOR EACH ROW
BEGIN
    IF SUBSTRING_INDEX(USER(), '@', 1) = 'dbo' AND OLD.Price <> NEW.Price THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User "dbo" is not allowed to change the book price.';
    END IF;
END$$
DELIMITER ;

#Тестування як інший користувач"
INSERT INTO maininfo (Code, Title, Price, Publisher, Pages, Format, DatePublished, Edition, Theme, Category)
VALUES (15473, 'Test Book', 59.99, 1, 400, 1, '2023-04-01', 1, 1, 1);
UPDATE maininfo SET Price = 35.99 WHERE Code = 15473;

#8.Видавництва ДМК і Еком підручники не видають.
DELIMITER $$
CREATE TRIGGER Check_Publisher_Before_Insert
BEFORE INSERT ON maininfo
FOR EACH ROW
BEGIN
    IF (NEW.Publisher IN (5, 9) AND NEW.Category = 1) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Publishers DMK and Ekom cannot publish textbooks.';
    END IF;
END$$
DELIMITER ;
DELIMITER $$

#Спроба вставки (повинна заблокуватися)
INSERT INTO maininfo (Code, Title, Price, Publisher, Pages, Format, DatePublished, Edition, Theme, Category)
VALUES (1121, 'Test Textbook', 69.99, 5, 500, 1, '2023-04-01', 1, 1, 1);

CREATE TRIGGER Check_Publisher_Before_Update
BEFORE UPDATE ON maininfo
FOR EACH ROW
BEGIN
    IF (NEW.Publisher IN (5, 9) AND NEW.Category = 1) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Publishers DMK and Ekom cannot publish textbooks.';
    END IF;
END$$
DELIMITER ;

#Спроба оновлення (повинна заблокуватися)
UPDATE maininfo
SET Publisher = 5, Category = 1
WHERE ID = 313;

#9.Видавництво не може випустити більше 10 новинок протягом одного місяця поточного року.
DELIMITER $$
CREATE TRIGGER Check_New_Releases_Limit
BEFORE INSERT ON maininfo
FOR EACH ROW
BEGIN
    DECLARE total_new_releases INT;
    SELECT COUNT(*) INTO total_new_releases
    FROM maininfo
    WHERE Publisher = NEW.Publisher
      AND YEAR(DatePublished) = YEAR(CURRENT_DATE())
      AND MONTH(DatePublished) = MONTH(CURRENT_DATE())
      AND NewEntry = 'Yes';
    IF total_new_releases >= 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'This publisher cannot release more than 10 new books in a single month.';
    END IF;
END$$
DELIMITER ;

#Спроба вставки нової книги як новинки
INSERT INTO maininfo (Title, Publisher, DatePublished, NewEntry, Price, Pages, Format, Edition, Theme, Category)
VALUES ('Test New Book', 1, CURRENT_DATE(), 'Yes', 19.95, 320, 2, 1, 3, 5);

#10.Видавництво BHV не випускає книги формату 60х88 / 16.
DELIMITER $$
CREATE TRIGGER Prevent_BHV_Format_Insert
BEFORE INSERT ON maininfo
FOR EACH ROW
BEGIN
    IF (NEW.Publisher = 1 AND NEW.Format = 3) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Publisher BHV is not allowed to release books in the format 60х88/16.';
    END IF;
END$$
DELIMITER ;
DELIMITER $$

#Спроба вставки нової книги, яка має бути заблокована
INSERT INTO maininfo (Title, Publisher, Format, DatePublished, Price, Pages, Edition, Theme, Category, NewEntry)
VALUES ('Forbidden Format Book', 1, 3, '2023-01-01', 25.99, 300, 1, 5, 7, 'No');

CREATE TRIGGER Prevent_BHV_Format_Update
BEFORE UPDATE ON maininfo
FOR EACH ROW
BEGIN
    IF (NEW.Publisher = 1 AND NEW.Format = 3) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Publisher BHV is not allowed to release books in the format 60х88/16.';
    END IF;
END$$
DELIMITER ;

#Спроба оновлення існуючої книги до недозволеного формату(помилка)
UPDATE maininfo
SET Format = 3
WHERE ID = 20;














