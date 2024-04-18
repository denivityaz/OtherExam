-- Создание базы данных Menu
CREATE DATABASE Menu
ON 
(
    NAME = Menu_Data,
    FILENAME = 'C:\SQLData\MenuData.mdf',
    SIZE = 5MB,
    FILEGROWTH = 1MB
)
LOG ON 
(
    NAME = Menu_Log,
    FILENAME = 'C:\SQLData\MenuLog.ldf',
    SIZE = 2MB
);

-- Проверка существования базы данных Menu
SELECT * FROM sys.databases WHERE name = 'Menu'


CREATE TABLE students_menu (
    dish_id INT PRIMARY KEY,
    dish_name NVARCHAR(100),
    dish_type NVARCHAR(50) CHECK (dish_type IN ('Салат', 'Горячее', 'Напиток', 'Десерт')),
    dish_price DECIMAL(10, 2), -- Стоимость блюда
    expiry_date DATE
);

-- Внесение данных в таблицу students_menu
INSERT INTO students_menu (dish_id, dish_name, dish_type, dish_price, expiry_date) VALUES
(1, 'Цезарь с курицей', 'Салат', 150.00, '2024-04-20'),
(2, 'Греческий с оливками', 'Салат', 120.00, '2024-04-21'),
(3, 'Овощной с тунцом', 'Салат', 130.00, '2024-04-22'),
(4, 'Вегетарианский ризотто', 'Горячее', 200.00, '2024-04-23'),
(5, 'Курица табака', 'Горячее', 180.00, '2024-04-24'),
(6, 'Свинина с картошкой', 'Горячее', 220.00, '2024-04-25'),
(7, 'Чай зеленый', 'Напиток', 50.00, '2024-04-26'),
(8, 'Кофе американо', 'Напиток', 80.00, '2024-04-27'),
(9, 'Фруктовый сок', 'Напиток', 60.00, '2024-04-28'),
(10, 'Тирамису', 'Десерт', 100.00, '2024-04-29'),
(11, 'Пирожное эклер', 'Десерт', 90.00, '2024-04-30'),
(12, 'Пирог с яблоками', 'Десерт', 110.00, '2024-05-01');


CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name NVARCHAR(100),
    expiry_date DATE
);

-- Внесение данных в таблицу products
INSERT INTO products (product_id, product_name, expiry_date) VALUES
(1, 'Молоко', '2024-04-18'),
(2, 'Яйца', '2024-04-19'),
(3, 'Мясо', '2024-04-20'),
(4, 'Овощи', '2024-04-21'),
(5, 'Фрукты', '2024-04-22');





-- Создание представления для вывода продуктов с истекающим сроком годности
CREATE VIEW ExpiringProducts AS
SELECT * FROM products WHERE DATEDIFF(DAY, GETDATE(), expiry_date) <= 3;


-- Способ 1: Используя оператор WHERE с условием на стоимость в пределах диапазона
SELECT dish_name
FROM students_menu
WHERE dish_price BETWEEN 10 AND 99;

-- Способ 2: Используя оператор HAVING после группировки по стоимости
SELECT dish_name
FROM students_menu
GROUP BY dish_name
HAVING AVG(dish_price) BETWEEN 10 AND 99;

-- Способ 3: Используя подзапрос для фильтрации стоимости в диапазоне
SELECT dish_name
FROM students_menu
WHERE dish_id IN (
    SELECT dish_id
    FROM students_menu
    WHERE dish_price BETWEEN 10 AND 99
);



-- Создание логина для пользователя "Cook"
USE master;
CREATE LOGIN Cook WITH PASSWORD = 'cook_password'; -- Замените 'cook_password' на реальный пароль

-- Переключение на базу данных, в которой нужно создать пользователя
USE Menu; -- Предположим, что ваша база данных называется "Menu"

-- Создание пользователя "Cook" в базе данных и связь с логином "Cook"
CREATE USER Cook FOR LOGIN Cook;

-- Предоставление разрешений пользователю "Cook" на изменение и добавление блюд в таблицу students_menu
GRANT INSERT, UPDATE ON students_menu TO Cook;


--резервная копия (поменять имя бд)
BACKUP DATABASE Сессия TO DISK = 'C:\Backup\Сессия.bak' WITH INIT, NAME = 'Full Backup of Сессия';



