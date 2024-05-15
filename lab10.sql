# Проектування таблиць з використанням призначених для користувача типів даних (user defined data types), замовчувань (defaults) і правил (rules).
# 1.Створити користувальницький тип даних для зберігання оцінки учня на основі стандартного типу tinyint з можливістю використання порожніх значень.
CREATE TABLE Student_Grade (
    Grade tinyint DEFAULT NULL,
    PRIMARY KEY (Grade)
);

# 2.Створити об'єкт-замовчування (default) зі значенням 3.
ALTER TABLE Student_Grade MODIFY Grade tinyint DEFAULT 3;

# 3.Зв'язати об'єкт-замовчування з призначеним для користувача типом даних для оцінки.
#Це не потрібно, оскільки замовчування прив'язане до самого стовпця.

# 4.Отримати інформацію про призначений для користувача тип даних.
DESCRIBE Student_Grade;

# 5.Створити об'єкт-правило (rule): a> = 1 і a <= 5 і зв'язати його з призначеним для користувача типом даних для оцінки.
ALTER TABLE Student_Grade ADD CHECK (Grade >= 1 AND Grade <= 5);

# 6.Створити таблицю "Успішність студента", використовуючи новий тип даних. У таблиці повинні бути оцінки студента з кількох предметів.
CREATE TABLE Student_Success (
    StudentID int PRIMARY KEY,
    DataBaseGrade tinyint,
    PhilosophyGrade tinyint,
    OptimizationMethodsGrade tinyint,
    FOREIGN KEY (DataBaseGrade) REFERENCES Student_Grade(Grade),
    FOREIGN KEY (PhilosophyGrade) REFERENCES Student_Grade(Grade),
    FOREIGN KEY (OptimizationMethodsGrade) REFERENCES Student_Grade(Grade)
);
DESCRIBE Student_Success;

# 7.Скасувати всі прив'язки і видалити з бази даних тип даних користувача, замовчування і правило.
DROP TABLE Student_Success;
DROP TABLE Student_Grade;
