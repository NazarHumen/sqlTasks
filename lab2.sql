#1.Вивести значення наступних колонок: номер, код, новинка, назва, ціна, сторінки
SELECT ID,Code,NewEntry, Title,Price,Pages FROM books;

#2.Вивести значення всіх колонок
SELECT * FROM books;

#3.Вивести значення колонок в наступному порядку: код, назва, новинка, сторінки, ціна, номер
SELECT Code,Title,NewEntry,Pages,Price,ID FROM books;

#4.Вивести значення всіх колонок 10 перших рядків
SELECT * FROM books LIMIT 10;

#5.Вивести значення всіх колонок 10% перших термін
SET @num_rows = (SELECT CEIL(COUNT(*) * 0.1) FROM books);
PREPARE stmt FROM 'SELECT * FROM books LIMIT ?';
EXECUTE stmt USING @num_rows;
DEALLOCATE PREPARE stmt;

#6.Вивести значення колонки код без повторення однакових кодів
SELECT DISTINCT Code FROM books;

#7.Вивести всі книги новинки
SELECT * FROM books WHERE NewEntry = 'YES';


#8.Вивести всі книги новинки з ціною від 20 до 30
SELECT * FROM books WHERE NewEntry = 'YES' AND Price BETWEEN 20 AND 30;

#9.Вивести всі книги новинки з ціною менше 20 і більше 30
SELECT * FROM books WHERE NewEntry = 'YES' AND (Price < 20 OR Price > 30);


#10.Вивести всі книги з кількістю сторінок від 300 до 400 і з ціною більше 20 і менше 30
SELECT * FROM books WHERE Pages BETWEEN 300 AND 400 AND Price > 20 AND Price < 30;

#11.Вивести всі книги видані взимку 2000 року
SELECT * FROM books WHERE EXTRACT(MONTH FROM DatePublished) IN (12,1,2) AND EXTRACT(YEAR FROM DatePublished) = 2000;

#12.Вивести книги зі значеннями кодів 5110, 5141, 4985, 4241
SELECT * FROM books WHERE Code IN (5110,5141,4985,4241);

#13.Вивести книги видані в 1999, 2001, 2003, 2005 р
SELECT * FROM books WHERE EXTRACT(YEAR FROM DatePublished) IN (1999,2001,2003,2005);

#14.Вивести книги назви яких починаються на літери А-К
SELECT * FROM books WHERE Title REGEXP '^[А-К]';

#15.Вивести книги назви яких починаються на літери "АПП", видані в 2000 році з ціною до 20
SELECT * FROM books WHERE Title REGEXP '^АП' AND YEAR(DatePublished) = 2000 AND Price < 20;

#16.Вивести книги назви яких починаються на літери "АПП", закінчуються на "е", видані в першій половині 2000 року
SELECT * FROM books WHERE Title REGEXP '^АП.*е$' AND YEAR(DatePublished) = 2000 AND MONTH(DatePublished) <= 6;

#17.Вивести книги, в назвах яких є слово Microsoft, але немає слова Windows
SELECT * FROM Books WHERE Title LIKE '%Microsoft%' AND Title NOT LIKE '%Windows%';

#18.Вивести книги, в назвах яких присутня як мінімум одна цифра.
SELECT * FROM books WHERE Title REGEXP '[0-9]';

#19.Вивести книги, в назвах яких присутні не менше трьох цифр.
SELECT * FROM books WHERE Title REGEXP '[0-9]{3,}';

#20.Вивести книги, в назвах яких присутній рівно п'ять цифр.
SELECT * FROM books WHERE Title REGEXP '[0-9]{5}';



