CREATE DATABASE IF NOT EXISTS infosystemair
    CHARACTER SET 'utf8'
    COLLATE 'utf8_general_ci';

# 5)Побудувати таблиці опису та зв’язки між ними.
CREATE TABLE Departments (
    Department_ID INT PRIMARY KEY,
    Department_Name VARCHAR(100),
    Manager INT
) ENGINE = InnoDB
  CHARACTER SET 'utf8'
  COLLATE 'utf8_general_ci';

CREATE TABLE Aircrafts (
    Aircraft_ID INT PRIMARY KEY,
    Aircraft_Type VARCHAR(100),
    Arrival_Time DATE,
    Number_Of_Flights INT,
    `Condition` VARCHAR(100)
)ENGINE = InnoDB
  CHARACTER SET 'utf8'
  COLLATE 'utf8_general_ci';

CREATE TABLE Employees (
    Employee_ID INT PRIMARY KEY,
    First_Name VARCHAR(100),
    Last_Name VARCHAR(100),
    Birth_Date DATE,
    Gender CHAR(1),
    Has_Children BOOLEAN,
    Work_Experience INT,
    Salary DECIMAL(10, 2),
    Department INT,
    Team INT,
    Position VARCHAR(100),
    Medical_Exam_Date DATE,
    Medical_Exam_Result BOOLEAN,
    FOREIGN KEY (Department) REFERENCES Departments(Department_ID),
    FOREIGN KEY (Team) REFERENCES Teams(Team_ID)
)ENGINE = InnoDB
  CHARACTER SET 'utf8'
  COLLATE 'utf8_general_ci';

CREATE TABLE Teams (
    Team_ID INT PRIMARY KEY,
    Department INT,
    FOREIGN KEY (Department) REFERENCES Departments(Department_ID)
)ENGINE = InnoDB
  CHARACTER SET 'utf8'
  COLLATE 'utf8_general_ci';

CREATE TABLE Inspections (
    Inspection_ID INT PRIMARY KEY,
    Aircraft INT,
    Inspection_Date DATE,
    Result VARCHAR(100),
    FOREIGN KEY (Aircraft) REFERENCES Aircrafts(Aircraft_ID)
)ENGINE = InnoDB
  CHARACTER SET 'utf8'
  COLLATE 'utf8_general_ci';

CREATE TABLE Repairs (
    Repair_ID INT PRIMARY KEY,
    Aircraft INT,
    Repair_Date DATE,
    Description TEXT,
    FOREIGN KEY (Aircraft) REFERENCES Aircrafts(Aircraft_ID)
)ENGINE = InnoDB
  CHARACTER SET 'utf8'
  COLLATE 'utf8_general_ci';

CREATE TABLE Flights (
    Flight_ID INT PRIMARY KEY,
    Aircraft_Type VARCHAR(100),
    Flight_Number VARCHAR(10),
    Departure_Days VARCHAR(50),
    Departure_Time TIME,
    Arrival_Time TIME,
    Route TEXT,
    Ticket_Price DECIMAL(10, 2),
    Category VARCHAR(50),
    Status VARCHAR(50)
)ENGINE = InnoDB
  CHARACTER SET 'utf8'
  COLLATE 'utf8_general_ci';

CREATE TABLE Passengers (
    Passenger_ID INT PRIMARY KEY,
    First_Name VARCHAR(100),
    Last_Name VARCHAR(100),
    Passport VARCHAR(20),
    Gender CHAR(1),
    Age INT,
    Baggage BOOLEAN
)ENGINE = InnoDB
  CHARACTER SET 'utf8'
  COLLATE 'utf8_general_ci';

CREATE TABLE Tickets (
    Ticket_ID INT PRIMARY KEY,
    Flight INT,
    Passenger INT,
    Price DECIMAL(10, 2),
    Status VARCHAR(50),
    FOREIGN KEY (Flight) REFERENCES Flights(Flight_ID),
    FOREIGN KEY (Passenger) REFERENCES Passengers(Passenger_ID)
)ENGINE = InnoDB
  CHARACTER SET 'utf8'
  COLLATE 'utf8_general_ci';

#Обмеження зовнішнього ключа для таблиці Відділи, щоб посилатися на таблицю Працівники
ALTER TABLE Departments
ADD CONSTRAINT FK_Manager
FOREIGN KEY (Manager) REFERENCES Employees(Employee_ID);


#Заповнення таблиці "Відділи"
INSERT INTO Departments (Department_ID, Department_Name, Manager)
VALUES
    (1, 'Pilot Department', NULL),
    (2, 'Dispatcher Department', NULL),
    (3, 'Technical Department', NULL);

#Заповнення таблиці "Літаки"
INSERT INTO Aircrafts (Aircraft_ID, Aircraft_Type, Arrival_Time, Number_Of_Flights, `Condition`)
VALUES
    (1, 'Boeing 747', '2024-05-15', 100, 'operational'),
    (2, 'Airbus A320', '2024-05-18', 80, 'operational');

#Заповнення таблиці "Працівники"
INSERT INTO Employees (Employee_ID, First_Name, Last_Name, Birth_Date, Gender, Has_Children, Work_Experience, Salary, Department, Team, Position, Medical_Exam_Date, Medical_Exam_Result)
VALUES
    (1, 'Alexander', 'Petrov', '1980-05-15', 'M', TRUE, 10, 5000.00, 1, 1, 'Pilot', '2024-01-10', TRUE),
    (2, 'Maria', 'Ivanenko', '1985-08-25', 'F', TRUE, 8, 4000.00, 2, 2, 'Dispatcher', '2024-03-20', TRUE),
    (3, 'Peter', 'Sidorenko', '1990-11-12', 'M', FALSE, 5, 3000.00, 3, 3, 'Technician', '2024-02-05', TRUE),
    (4, 'Olga', 'Kovalenko', '1982-04-30', 'F', TRUE, 12, 5500.00, 1, 1, 'Cashier', '2024-04-15', FALSE);

# Оновлення таблиці "Відділи" з керівниками після додавання співробітників
UPDATE Departments SET Manager = 1 WHERE Department_ID = 1;
UPDATE Departments SET Manager = 2 WHERE Department_ID = 2;
UPDATE Departments SET Manager = 3 WHERE Department_ID = 3;

#Заповнення таблиці "Бригади"
INSERT INTO Teams (Team_ID, Department)
VALUES
    (1, 1),
    (2, 2),
    (3, 3);

#Заповнення таблиці "Техогляди"
INSERT INTO Inspections (Inspection_ID, Aircraft, Inspection_Date, Result)
VALUES
    (1, 1, '2024-05-10', 'passed'),
    (2, 2, '2024-05-12', 'passed');

#Заповнення таблиці "Ремонти"
INSERT INTO Repairs (Repair_ID, Aircraft, Repair_Date, Description)
VALUES
    (1, 1, '2024-05-17', 'Engine replacement'),
    (2, 2, '2024-05-20', 'Body repaint');

#Заповнення таблиці "Рейси"
INSERT INTO Flights (Flight_ID, Aircraft_Type, Flight_Number, Departure_Days, Departure_Time, Arrival_Time, Route, Ticket_Price, Category, Status)
VALUES
    (1, 'Boeing 747', 'PS101', 'Mon, Wed, Fri', '08:00', '12:00', 'Kyiv - London', 500.00, 'international', 'active'),
    (2, 'Airbus A320', 'PS102', 'Tue, Thu, Sat', '10:00', '14:00', 'London - Kyiv', 550.00, 'international', 'active');
INSERT INTO Flights (Flight_ID, Aircraft_Type, Flight_Number, Departure_Days, Departure_Time, Arrival_Time, Route, Ticket_Price, Category, Status)
VALUES
    (3, 'Boeing 747', 'PS101', 'Mon, Wed, Fri', '11:00', '13:00', 'Kyiv - Paris', 700.00, 'international', 'canceled'),
    (4, 'Airbus A320', 'PS102', 'Tue, Thu, Sat', '12:00', '15:00', 'Paris - Kyiv', 700.00, 'international', 'canceled');

#Заповнення таблиці "Пасажири"
INSERT INTO Passengers (Passenger_ID, First_Name, Last_Name, Passport, Gender, Age, Baggage)
VALUES
    (1, 'Alexey', 'Ivanov', 'AB123456', 'M', 35, TRUE),
    (2, 'Marina', 'Petrova', 'CD654321', 'F', 30, FALSE);

#Заповнення таблиці "Квитки"
INSERT INTO Tickets (Ticket_ID, Flight, Passenger, Price, Status)
VALUES
    (1, 1, 1, 500.00, 'purchased'),
    (2, 2, 2, 550.00, 'purchased');


# Зробити запити.
# Види запитів в інформаційній системі:
# 1.Отримати список і загальну кількість всіх працівників аеропорту, начальників відділів, працівників зазначеного відділу, за стажем роботи в аеропорту, статевою ознакою, віком, ознакою наявності та кількістю дітей, за розміром заробітної плати.
#Отримати список і загальну кількість всіх працівників аеропорту
SELECT * FROM Employees;
SELECT COUNT(*) AS Total_Employees FROM Employees;

#Список начальників відділів і загальна кількість
SELECT e.*
FROM Employees e
JOIN Departments d ON e.Employee_ID = d.Manager;

SELECT COUNT(*) AS Total_Employees
FROM Employees e
JOIN Departments d ON e.Employee_ID = d.Manager;

#Список працівників зазначеного відділу і загальна кількість
SELECT * FROM Employees WHERE Department = 1;
SELECT COUNT(*) AS Total_Employees FROM Employees WHERE Department = 1;

#Список за стажем роботи в аеропорту і загальна кількість
SELECT * FROM Employees WHERE Work_Experience > 5;
SELECT COUNT(*) AS Total_Employees FROM Employees WHERE Work_Experience > 5;


#Список за статевою ознакою і загальна кількість
SELECT * FROM Employees WHERE Gender = 'M';
SELECT COUNT(*) AS Total_Employees FROM Employees WHERE Gender = 'M';


#Список за віком і загальна кількість
SELECT * FROM Employees WHERE TIMESTAMPDIFF(YEAR, Birth_Date, CURDATE()) > 30;
SELECT COUNT(*) AS Total_Employees FROM Employees WHERE TIMESTAMPDIFF(YEAR, Birth_Date, CURDATE()) > 30;

##Список за ознакою наявності дітей і загальна кількість
SELECT * FROM Employees WHERE Has_Children = True;
SELECT COUNT(*)AS Total_Employees  FROM Employees WHERE Has_Children = True;

#Список за  кількістю дітей і загальна кількість
SELECT * FROM Employees WHERE Has_Children = 1;
SELECT COUNT(*) AS Total_Employees FROM Employees WHERE Has_Children = 1;

#Список за розміром заробітної плати і загальна кількість
SELECT * FROM Employees WHERE Salary > 4000.00;
SELECT COUNT(*) AS Total_Employees  FROM Employees WHERE Salary > 4000.00;

# 2.Отримати перелік та загальну кількість працівників у бригаді, по всіх відділах, у зазначеному відділі, які обслуговують конкретний рейс, за віком, сумарною (середньою) зарплатою у бригаді.
#Перелік та загальна кількість працівників у бригаді
SELECT * FROM Employees
ORDER BY Team;

SELECT Team, COUNT(*) AS Total_Employees
FROM Employees
GROUP BY Team;

#Перелік та загальна кількість працівників по всіх відділах
SELECT * FROM Employees
ORDER BY Department;

SELECT Department, COUNT(*) AS Total_Employees
FROM Employees
GROUP BY Department;

#Перелік та загальна кількість працівників у зазначеному відділі
SELECT * FROM Employees
WHERE Department = 1;

SELECT COUNT(*) AS Total_Employees
FROM Employees
WHERE Department = 1;

#Перелік працівників, які обслуговують конкретний рейс
SELECT e.*
FROM Employees e
JOIN Flights f ON e.Position = f.Aircraft_Type
WHERE f.Flight_ID = 1;


SELECT COUNT(*) AS Total_Employees
FROM Employees e
JOIN Flights f ON e.Position = f.Aircraft_Type
WHERE f.Flight_ID = 1;

#Перелік працівників за віком
SELECT *
FROM Employees
WHERE TIMESTAMPDIFF(YEAR, Birth_Date, CURDATE()) > 30;

SELECT COUNT(*) AS Total_Employees
FROM Employees
WHERE TIMESTAMPDIFF(YEAR, Birth_Date, CURDATE()) > 30;

#Сумарна (середня) зарплата у бригаді
SELECT Team, SUM(Salary) AS Total_Salary, AVG(Salary) AS Average_Salary
FROM Employees
GROUP BY Team;


# 3.Отримати список і загальна кількість пілотів, що пройшли медогляд або не пройшли його в зазначений рік, за статевою ознакою, віком, розміром заробітної плати.
#Список і загальна кількість пілотів, що пройшли медогляд у зазначений рік
SELECT *
FROM Employees
WHERE Position = 'Pilot' AND YEAR(Medical_Exam_Date) = 2024 AND Medical_Exam_Result = TRUE;

SELECT COUNT(*) AS Total_Passed_Medical_Exam
FROM Employees
WHERE Position = 'Pilot' AND YEAR(Medical_Exam_Date) = 2024 AND Medical_Exam_Result = TRUE;

#Список і загальна кількість пілотів, що не пройшли медогляд у зазначений рік
SELECT *
FROM Employees
WHERE Position = 'Pilot' AND YEAR(Medical_Exam_Date) = 2024 AND Medical_Exam_Result = FALSE;

SELECT COUNT(*) AS Total_Failed_Medical_Exam
FROM Employees
WHERE Position = 'Pilot' AND YEAR(Medical_Exam_Date) = 2024 AND Medical_Exam_Result = FALSE;

#Список пілотів за статевою ознакою
SELECT *
FROM Employees
WHERE Position = 'Pilot' AND Gender = 'M';

SELECT COUNT(*) AS Total_Male_Pilots
FROM Employees
WHERE Position = 'Pilot' AND Gender = 'M';

#Список пілотів за віком
SELECT *
FROM Employees
WHERE Position = 'Pilot' AND TIMESTAMPDIFF(YEAR, Birth_Date, CURDATE()) > 30;

SELECT COUNT(*) AS Total_Pilots_Over_30
FROM Employees
WHERE Position = 'Pilot' AND TIMESTAMPDIFF(YEAR, Birth_Date, CURDATE()) > 30;

#Список пілотів за розміром заробітної плати
SELECT *
FROM Employees
WHERE Position = 'Pilot' AND Salary > 4000.00;

SELECT COUNT(*) AS Total_Pilots_With_High_Salary
FROM Employees
WHERE Position = 'Pilot' AND Salary > 4000.00;

# 4.Отримати перелік і загальну кількість літаків приписаних до аеропорту, що знаходяться в ньому в зазначений час, за часом надходження в аеропорт, за кількістю скоєних рейсів.
#Перелік і загальна кількість літаків, що знаходяться в аеропорту у зазначений час
SELECT *
FROM Aircrafts
WHERE Arrival_Time <= '2024-05-20';

SELECT COUNT(*) AS Total_Aircrafts_In_Airport
FROM Aircrafts
WHERE Arrival_Time <= '2024-05-20';

#Перелік і загальна кількість літаків за часом надходження в аеропорт
SELECT *
FROM Aircrafts
WHERE Arrival_Time > '2024-01-01';

SELECT COUNT(*) AS Total_Aircrafts_After_Date
FROM Aircrafts
WHERE Arrival_Time > '2024-01-01';

#Перелік і загальна кількість літаків за кількістю скоєних рейсів
SELECT *
FROM Aircrafts
WHERE Number_Of_Flights > 50;

SELECT COUNT(*) AS Total_Aircrafts_With_More_Flights
FROM Aircrafts
WHERE Number_Of_Flights > 50;


# 5.Отримати перелік та загальну кількість літаків, що пройшли техогляд за певний період часу, відправлених у ремонт у зазначений час, ремонтованих задану кількість разів, за кількістю скоєних рейсів до ремонту, за віком літака.
#Перелік та загальна кількість літаків, що пройшли техогляд за певний період часу
SELECT a.*
FROM Aircrafts a
JOIN Inspections i ON a.Aircraft_ID = i.Aircraft
WHERE i.Inspection_Date BETWEEN '2024-01-01' AND '2024-05-20';

SELECT COUNT(DISTINCT a.Aircraft_ID) AS Total_Inspected_Aircrafts
FROM Aircrafts a
JOIN Inspections i ON a.Aircraft_ID = i.Aircraft
WHERE i.Inspection_Date BETWEEN '2024-01-01' AND '2024-05-20';

#Перелік та загальна кількість літаків, відправлених у ремонт у зазначений час
SELECT a.*
FROM Aircrafts a
JOIN Repairs r ON a.Aircraft_ID = r.Aircraft
WHERE r.Repair_Date BETWEEN '2024-05-01' AND '2024-05-31';

SELECT COUNT(DISTINCT a.Aircraft_ID) AS Total_Repaired_Aircrafts
FROM Aircrafts a
JOIN Repairs r ON a.Aircraft_ID = r.Aircraft
WHERE r.Repair_Date BETWEEN '2024-05-01' AND '2024-05-31';

#Перелік та загальна кількість літаків, ремонтованих задану кількість разів
SELECT a.*
FROM Aircrafts a
JOIN (
    SELECT Aircraft, COUNT(*) AS Repair_Count
    FROM Repairs
    GROUP BY Aircraft
    HAVING Repair_Count > 2
) r ON a.Aircraft_ID = r.Aircraft;

SELECT COUNT(*) AS Total_Frequently_Repaired_Aircrafts
FROM (
    SELECT Aircraft, COUNT(*) AS Repair_Count
    FROM Repairs
    GROUP BY Aircraft
    HAVING Repair_Count > 2
) r;

#Перелік та загальна кількість літаків за кількістю скоєних рейсів до ремонту
SELECT a.*
FROM Aircrafts a
JOIN Repairs r ON a.Aircraft_ID = r.Aircraft
WHERE a.Number_Of_Flights > 50;

SELECT COUNT(DISTINCT a.Aircraft_ID) AS Total_Aircrafts_With_More_Flights
FROM Aircrafts a
JOIN Repairs r ON a.Aircraft_ID = r.Aircraft
WHERE a.Number_Of_Flights > 50;

#Перелік та загальна кількість літаків за віком літака
SELECT a.*
FROM Aircrafts a
WHERE DATEDIFF('2024-05-20', a.Arrival_Time) / 365 > 5;

SELECT COUNT(*) AS Total_Older_Aircrafts
FROM Aircrafts a
WHERE DATEDIFF('2024-05-20', a.Arrival_Time) / 365 > 5;

# 6.Отримати перелік і загальну кількість рейсів за вказаним маршрутом, за тривалістю перельоту, за ціною квитка і за всіма цими критеріями відразу.
#Перелік та загальна кількість рейсів за вказаним маршрутом
SELECT *
FROM Flights
WHERE Route = 'Kyiv - London';

SELECT COUNT(*) AS Total_Flights_By_Route
FROM Flights
WHERE Route = 'Kyiv - London';

#Перелік та загальна кількість рейсів за тривалістю перельоту
SELECT *, TIMEDIFF(Arrival_Time, Departure_Time) AS Duration
FROM Flights
WHERE TIMEDIFF(Arrival_Time, Departure_Time) > '02:00:00';

SELECT COUNT(*) AS Total_Flights_By_Duration
FROM Flights
WHERE TIMEDIFF(Arrival_Time, Departure_Time) > '02:00:00';

#Перелік та загальна кількість рейсів за ціною квитка
SELECT *
FROM Flights
WHERE Ticket_Price > 500.00;

SELECT COUNT(*) AS Total_Flights_By_Ticket_Price
FROM Flights
WHERE Ticket_Price > 500.00;

#Перелік та загальна кількість рейсів за всіма цими критеріями відразу
SELECT *, TIMEDIFF(Arrival_Time, Departure_Time) AS Duration
FROM Flights
WHERE Route = 'Kyiv - London'
  AND TIMEDIFF(Arrival_Time, Departure_Time) > '02:00:00'
  AND Ticket_Price > 500.00;

SELECT COUNT(*) AS Total_Flights_By_All_Criteria
FROM Flights
WHERE Route = 'Kyiv - London'
  AND TIMEDIFF(Arrival_Time, Departure_Time) > '02:00:00'
  AND Ticket_Price > 500.00;

# 7.Отримати перелік і загальну кількість скасованих рейсів повністю, у зазначеному напрямку, за вказаним маршрутом, за кількістю незатребуваних місць, за відсотковим співвідношенням незатребуваних місць.
#Перелік і загальна кількість повністю скасованих рейсів
SELECT *
FROM Flights
WHERE Status = 'canceled';

SELECT COUNT(*) AS Total_Canceled_Flights
FROM Flights
WHERE Status = 'canceled';

#Перелік і загальна кількість скасованих рейсів у зазначеному напрямку
SELECT *
FROM Flights
WHERE Status = 'canceled' AND Route = 'Kyiv - Paris';

SELECT COUNT(*) AS Total_Canceled_Flights_By_Route
FROM Flights
WHERE Status = 'canceled' AND Route = 'Kyiv - Paris';

#Перелік і загальна кількість скасованих рейсів за вказаним маршрутом
SELECT *
FROM Flights
WHERE Status = 'canceled' AND Route = 'Kyiv - Paris';

SELECT COUNT(*) AS Total_Canceled_Flights_By_Specified_Route
FROM Flights
WHERE Status = 'canceled' AND Route = 'Kyiv - Paris';

#Перелік і загальна кількість скасованих рейсів за кількістю незатребуваних місць
ALTER TABLE Flights
ADD COLUMN Unclaimed_Seats INT;
UPDATE Flights
SET Unclaimed_Seats = 10
WHERE Flight_ID = 1;

UPDATE Flights
SET Unclaimed_Seats = 15
WHERE Flight_ID = 2;

UPDATE Flights
SET Unclaimed_Seats = 10
WHERE Flight_ID = 3;

UPDATE Flights
SET Unclaimed_Seats = 15
WHERE Flight_ID = 4;

SELECT *
FROM Flights
WHERE Status = 'canceled' AND Unclaimed_Seats > 0;

SELECT COUNT(*) AS Total_Canceled_Flights_By_Unclaimed_Seats
FROM Flights
WHERE Status = 'canceled' AND Unclaimed_Seats > 0;

#Перелік і загальна кількість скасованих рейсів за відсотковим співвідношенням незатребуваних місць
ALTER TABLE Flights
ADD COLUMN Total_Seats INT;

UPDATE Flights
SET Total_Seats = 200
WHERE Flight_ID = 1;

UPDATE Flights
SET Total_Seats = 180
WHERE Flight_ID = 2;

UPDATE Flights
SET Total_Seats = 200
WHERE Flight_ID = 3;

UPDATE Flights
SET Total_Seats = 180
WHERE Flight_ID = 4;

#Перелік і загальна кількість скасованих рейсів за відсотковим співвідношенням незатребуваних місць
SELECT *,
       (Unclaimed_Seats / Total_Seats) * 100 AS Unclaimed_Seats_Percentage
FROM Flights
WHERE Status = 'canceled' AND (Unclaimed_Seats / Total_Seats) * 100 > 5;

SELECT COUNT(*) AS Total_Canceled_Flights_By_Unclaimed_Seats_Percentage
FROM Flights
WHERE Status = 'canceled' AND (Unclaimed_Seats / Total_Seats) * 100 > 5;

# 8.Отримати перелік та загальну кількість затриманих рейсів повністю, за вказаною причиною, за вказаним маршрутом, та кількість зданих квитків за час затримки.
ALTER TABLE Flights
ADD COLUMN Delay_Reason VARCHAR(255),
ADD COLUMN Returned_Tickets_Due_To_Delay INT DEFAULT 0;
ALTER TABLE Flights
ADD COLUMN Status_Delay VARCHAR(50) DEFAULT 'scheduled';
UPDATE Flights
SET Status_Delay = 'delayed', Delay_Reason = 'Technical issues', Returned_Tickets_Due_To_Delay = 5
WHERE Flight_ID = 1;

UPDATE Flights
SET Status_Delay = 'delayed', Delay_Reason = 'Weather conditions', Returned_Tickets_Due_To_Delay = 3
WHERE Flight_ID = 2;

UPDATE Flights
SET Status_Delay = 'delayed', Delay_Reason = 'Technical issues', Returned_Tickets_Due_To_Delay = 4
WHERE Flight_ID = 3;

UPDATE Flights
SET Status_Delay = 'delayed', Delay_Reason = 'Weather conditions', Returned_Tickets_Due_To_Delay = 2
WHERE Flight_ID = 4;

#Перелік та загальна кількість затриманих рейсів повністю
SELECT *
FROM Flights
WHERE Status_Delay = 'delayed';

SELECT COUNT(*) AS Total_Delayed_Flights
FROM Flights
WHERE Status_Delay = 'delayed';

#Перелік та загальна кількість затриманих рейсів за вказаною причиною
SELECT *
FROM Flights
WHERE Status_Delay = 'delayed' AND Delay_Reason = 'Technical issues';

SELECT COUNT(*) AS Total_Delayed_Flights_By_Reason
FROM Flights
WHERE Status_Delay = 'delayed' AND Delay_Reason = 'Technical issues';

#Перелік та загальна кількість затриманих рейсів за вказаним маршрутом
SELECT *
FROM Flights
WHERE Status_Delay = 'delayed' AND Route = 'Kyiv - Paris';

SELECT COUNT(*) AS Total_Delayed_Flights_By_Route
FROM Flights
WHERE Status_Delay = 'delayed' AND Route = 'Kyiv - Paris';

#Кількість зданих квитків за час затримки
SELECT Flight_ID, Flight_Number, Route, Delay_Reason, Returned_Tickets_Due_To_Delay
FROM Flights
WHERE Status_Delay = 'delayed' AND Returned_Tickets_Due_To_Delay > 0;

SELECT SUM(Returned_Tickets_Due_To_Delay) AS Total_Returned_Tickets_Due_To_Delay
FROM Flights
WHERE Status_Delay = 'delayed' AND Returned_Tickets_Due_To_Delay > 0;

# 9.Отримати перелік і загальну кількість рейсів, якими літають літаки заданого типу та середня кількість проданих квитків на певні маршрути, за тривалістю перельоту, за ціною квитка, часу вильоту.
#Список і загальна кількість рейсів для заданого типу літака
SELECT *
FROM Flights
WHERE Aircraft_Type = 'Boeing 747';

SELECT COUNT(*) AS Total_Flights
FROM Flights
WHERE Aircraft_Type = 'Boeing 747';

#Середня кількість проданих квитків на певні маршрути
SELECT Route, AVG(Total_Seats - Unclaimed_Seats) AS Average_Sold_Tickets
FROM Flights
GROUP BY Route;

#Середня кількість проданих квитків за тривалістю перельоту
SELECT TIMEDIFF(Arrival_Time, Departure_Time) AS Flight_Duration, AVG(Total_Seats - Unclaimed_Seats) AS Average_Sold_Tickets
FROM Flights
GROUP BY Flight_Duration;

#Середня кількість проданих квитків за ціною квитка
SELECT Ticket_Price, AVG(Total_Seats - Unclaimed_Seats) AS Average_Sold_Tickets
FROM Flights
GROUP BY Ticket_Price;

#Середня кількість проданих квитків за часом вильоту
SELECT Departure_Time, AVG(Total_Seats - Unclaimed_Seats) AS Average_Sold_Tickets
FROM Flights
GROUP BY Departure_Time;

#Середня кількість проданих квитків за всіма цими критеріями відразу
SELECT Aircraft_Type, Route, TIMEDIFF(Arrival_Time, Departure_Time) AS Flight_Duration, Ticket_Price, Departure_Time,
       AVG(Total_Seats - Unclaimed_Seats) AS Average_Sold_Tickets
FROM Flights
GROUP BY Aircraft_Type, Route, Flight_Duration, Ticket_Price, Departure_Time;

# 10.Отримати перелік та загальну кількість авіарейсів зазначеної категорії, у певному напрямку, із зазначеним типом літака.
#Отримання переліку авіарейсів і загальної кількості зазначеної категорії
SELECT *
FROM Flights
WHERE Category = 'international';

SELECT COUNT(*) AS Total_Flights
FROM Flights
WHERE Category = 'international';

#Отримання переліку і загальної кількості авіарейсів у певному напрямку
SELECT *
FROM Flights
WHERE Route = 'Kyiv - London';

SELECT COUNT(*) AS Total_Flights
FROM Flights
WHERE Route = 'Kyiv - London';

#Отримання переліку і загальної кількості авіарейсів із зазначеним типом літака
SELECT *
FROM Flights
WHERE Aircraft_Type = 'Boeing 747';

SELECT COUNT(*) AS Total_Flights
FROM Flights
WHERE Aircraft_Type = 'Boeing 747';

#Отримання переліку і загальної кількості авіарейсів за всіма критеріями відразу
SELECT *
FROM Flights
WHERE Category = 'international'
  AND Route = 'Kyiv - London'
  AND Aircraft_Type = 'Boeing 747';

SELECT COUNT(*) AS Total_Flights
FROM Flights
WHERE Category = 'international'
  AND Route = 'Kyiv - London'
  AND Aircraft_Type = 'Boeing 747';

# 11.Отримати перелік та загальну кількість пасажирів на даному рейсі, що відлетіли у зазначений день, що відлетіли за кордон у зазначений день, за ознакою здачі речей у багажне відділення, за статевою ознакою, за віком.
ALTER TABLE Flights
ADD COLUMN Flight_Date DATE,
ADD COLUMN Is_International BOOLEAN;

UPDATE Flights
SET Flight_Date = '2024-05-01', Is_International = TRUE
WHERE Flight_ID = 1;

UPDATE Flights
SET Flight_Date = '2024-05-02', Is_International = TRUE
WHERE Flight_ID = 2;

UPDATE Flights
SET Flight_Date = '2024-05-03', Is_International = FALSE
WHERE Flight_ID = 3;

UPDATE Flights
SET Flight_Date = '2024-05-04', Is_International = TRUE
WHERE Flight_ID = 4;

#Отримання переліку і загальної кількості пасажирів на даному рейсі
SELECT DISTINCT Passengers.*
FROM Passengers
JOIN Tickets ON Passengers.Passenger_ID = Tickets.Passenger
WHERE Tickets.Flight = 1;

SELECT COUNT(DISTINCT Passengers.Passenger_ID) AS Total_Passengers
FROM Passengers
JOIN Tickets ON Passengers.Passenger_ID = Tickets.Passenger
WHERE Tickets.Flight = 1;

#Отримання переліку і загальної кількості  пасажирів, що відлетіли у зазначений день
SELECT DISTINCT Passengers.*
FROM Passengers
JOIN Tickets ON Passengers.Passenger_ID = Tickets.Passenger
JOIN Flights ON Tickets.Flight = Flights.Flight_ID
WHERE Flights.Flight_Date = '2024-05-01';

SELECT COUNT(DISTINCT Passengers.Passenger_ID) AS Total_Passengers
FROM Passengers
JOIN Tickets ON Passengers.Passenger_ID = Tickets.Passenger
JOIN Flights ON Tickets.Flight = Flights.Flight_ID
WHERE Flights.Flight_Date = '2024-05-01';

#Перелік і загальна кількість пасажирів, що відлетіли за кордон у зазначений день
SELECT DISTINCT Passengers.*
FROM Passengers
JOIN Tickets ON Passengers.Passenger_ID = Tickets.Passenger
JOIN Flights ON Tickets.Flight = Flights.Flight_ID
WHERE Flights.Flight_Date = '2024-05-01'
  AND Flights.Is_International = TRUE;

SELECT COUNT(DISTINCT Passengers.Passenger_ID) AS Total_Passengers
FROM Passengers
JOIN Tickets ON Passengers.Passenger_ID = Tickets.Passenger
JOIN Flights ON Tickets.Flight = Flights.Flight_ID
WHERE Flights.Flight_Date = '2024-05-01'
  AND Flights.Is_International = TRUE;

#Перелік і загальна кількість пасажирів за ознакою здачі речей у багажне відділення
SELECT Passengers.*
FROM Passengers
WHERE Passengers.Baggage = TRUE;

SELECT COUNT(*) AS Total_Passengers
FROM Passengers
WHERE Passengers.Baggage = TRUE;

#Перелік і загальна кількість пасажирів за статевою ознакою
SELECT Passengers.*
FROM Passengers
WHERE Passengers.Gender = 'M';

SELECT COUNT(*) AS Total_Passengers
FROM Passengers
WHERE Passengers.Gender = 'M';

#Перелік і загальна кількість пасажирів за віком
SELECT Passengers.*
FROM Passengers
WHERE Passengers.Age >= 30;

SELECT COUNT(*) AS Total_Passengers
FROM Passengers
WHERE Passengers.Age >= 30;

# 12.Отримати перелік та загальну кількість вільних та заброньованих місць на вказаному рейсі, на певний день, за вказаним маршрутом, за ціною, за часом вильоту.
ALTER TABLE Flights
ADD COLUMN Booked_Seats INT;

UPDATE Flights
SET Booked_Seats = 150
WHERE Flight_ID = 1;

UPDATE Flights
SET Booked_Seats = 180
WHERE Flight_ID = 2;

UPDATE Flights
SET Booked_Seats = 50
WHERE Flight_ID = 3;

UPDATE Flights
SET Booked_Seats = 100
WHERE Flight_ID = 4;

#Перелік і загальна кількість вільних та заброньованих місць на вказаному рейсі
SELECT Flight_ID, Total_Seats, Booked_Seats, (Total_Seats - Booked_Seats) AS Free_Seats
FROM Flights
WHERE Flight_ID = 1;

SELECT
    SUM(Total_Seats) AS Total_Seats,
    SUM(Booked_Seats) AS Total_Booked_Seats,
    SUM(Total_Seats - Booked_Seats) AS Total_Free_Seats
FROM Flights
WHERE Flight_ID = 1;

#Перелік і загальна кількість вільних та заброньованих місць на певний день
SELECT Flight_ID, Total_Seats, Booked_Seats, (Total_Seats - Booked_Seats) AS Free_Seats
FROM Flights
WHERE Flight_Date = '2024-05-01';

SELECT
    SUM(Total_Seats) AS Total_Seats,
    SUM(Booked_Seats) AS Total_Booked_Seats,
    SUM(Total_Seats - Booked_Seats) AS Total_Free_Seats
FROM Flights
WHERE Flight_Date = '2024-05-01';

#Перелік і загальна кількість вільних та заброньованих місць за вказаним маршрутом
SELECT Flight_ID, Total_Seats, Booked_Seats, (Total_Seats - Booked_Seats) AS Free_Seats
FROM Flights
WHERE Route = 'Kyiv - London';

SELECT
    SUM(Total_Seats) AS Total_Seats,
    SUM(Booked_Seats) AS Total_Booked_Seats,
    SUM(Total_Seats - Booked_Seats) AS Total_Free_Seats
FROM Flights
WHERE Route = 'Kyiv - London';

#Перелік і загальна кількість вільних та заброньованих місць за ціною
SELECT Flight_ID, Total_Seats, Booked_Seats, (Total_Seats - Booked_Seats) AS Free_Seats
FROM Flights
WHERE Ticket_Price = 500.00;

SELECT
    SUM(Total_Seats) AS Total_Seats,
    SUM(Booked_Seats) AS Total_Booked_Seats,
    SUM(Total_Seats - Booked_Seats) AS Total_Free_Seats
FROM Flights
WHERE Ticket_Price = 500.00;

#Перелік і загальна кількість вільних та заброньованих місць за часом вильоту
SELECT Flight_ID, Total_Seats, Booked_Seats, (Total_Seats - Booked_Seats) AS Free_Seats
FROM Flights
WHERE Departure_Time = '08:00';

SELECT
    SUM(Total_Seats) AS Total_Seats,
    SUM(Booked_Seats) AS Total_Booked_Seats,
    SUM(Total_Seats - Booked_Seats) AS Total_Free_Seats
FROM Flights
WHERE Departure_Time = '08:00';

# 13.Отримати загальну кількість зданих квитків на певний рейс, у вказаний день, за певним маршрутом, за ціною квитка, за віком, статтю.
ALTER TABLE Tickets
ADD COLUMN Returned BOOLEAN;

INSERT INTO Tickets (Ticket_ID, Flight, Passenger, Price, Status, Returned)
VALUES
    (3, 1, 1, 500.00, 'returned', TRUE),
    (4, 2, 2, 550.00, 'purchased', FALSE);

#Загальна кількість зданих квитків на певний рейс
SELECT COUNT(*) AS Returned_Tickets_Count
FROM Tickets
WHERE Flight = 1 AND Returned = TRUE;

#Загальна кількість зданих квитків у вказаний день
SELECT COUNT(*) AS Returned_Tickets_Count
FROM Tickets
JOIN Flights ON Tickets.Flight = Flights.Flight_ID
WHERE Flights.Flight_Date = '2024-05-01' AND Tickets.Returned = TRUE;

#Загальна кількість зданих квитків за певним маршрутом
SELECT COUNT(*) AS Returned_Tickets_Count
FROM Tickets
JOIN Flights ON Tickets.Flight = Flights.Flight_ID
WHERE Flights.Route = 'Kyiv - London' AND Tickets.Returned = TRUE;

#Загальна кількість зданих квитків за ціною квитка
SELECT COUNT(*) AS Returned_Tickets_Count
FROM Tickets
WHERE Price = 500.00 AND Returned = TRUE;

#Загальна кількість зданих квитків за віком пасажира
SELECT COUNT(*) AS Returned_Tickets_Count
FROM Tickets
JOIN Passengers ON Tickets.Passenger = Passengers.Passenger_ID
WHERE Passengers.Age > 30 AND Tickets.Returned = TRUE;

#Загальна кількість зданих квитків за статтю пасажира
SELECT COUNT(*) AS Returned_Tickets_Count
FROM Tickets
JOIN Passengers ON Tickets.Passenger = Passengers.Passenger_ID
WHERE Passengers.Gender = 'M' AND Tickets.Returned = TRUE;













