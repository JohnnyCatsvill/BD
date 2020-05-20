CREATE TABLE "Apartment" (
	"id_apartment" INTEGER PRIMARY KEY IDENTITY,
	"firstname_lastname" NVARCHAR(50) NOT NULL,
	"street" NVARCHAR(30) NOT NULL,
	"house_number" INTEGER NOT NULL,
	"apartment_number" INTEGER NOT NULL,
	"area" INTEGER NOT NULL,
	"tenant_amount" INTEGER NOT NULL
);

CREATE TABLE "Apartment_Consumtion" (
	"id_apartment_consumption" INTEGER PRIMARY KEY IDENTITY,
	"id_apartment" INTEGER NOT NULL,
	"date" DATE NOT NULL,
	"water" INTEGER NOT NULL,
	"warm_water" INTEGER NOT NULL,
	"sewerage" INTEGER NOT NULL,
	"electricity" INTEGER NOT NULL,
	"natural_gas" INTEGER NOT NULL,
	"garbage" INTEGER NOT NULL,
	"overhaul" INTEGER NOT NULL,
	"heating" INTEGER NOT NULL
);

CREATE TABLE "Tariff" (
	"id_tariff" INTEGER PRIMARY KEY IDENTITY(1,1),
	"up_to_date" DATE,
	"resource" NVARCHAR(20) NOT NULL,
	"measure_unit" NVARCHAR(20) NOT NULL,
	"price" MONEY NOT NULL
);

CREATE TABLE "Tariff_New" (
	"id_tariff" INTEGER PRIMARY KEY IDENTITY(1,1),
	"up_to_date" DATE,
	"resource" NVARCHAR(20) NOT NULL,
	"measure_unit" NVARCHAR(20) NOT NULL,
	"price" MONEY NOT NULL
);

CREATE TABLE "Bill" (
	"id_bill" INTEGER PRIMARY KEY IDENTITY,
	"id_tariff" INTEGER NOT NULL,
	"id_apartment_consumption" INTEGER NOT NULL,
	"pay_up_to_date" DATE NOT NULL,
	"sum" MONEY NOT NULL,
);

CREATE TABLE "Payment" (
	"id_payment" INTEGER PRIMARY KEY IDENTITY,
	"id_bill" INTEGER NOT NULL,
	"payment_day" DATE,
	"payment" MONEY NOT NULL,
	"payment_place" NVARCHAR(30) NOT NULL,
	"cheque" NVARCHAR(100) NOT NULL
);

/*Just filling*/

INSERT INTO Tariff
VALUES 
('2018-12-31', 'Вода', 'м^3', 17),
('2018-12-31', 'Тёплая вода', 'м^3', 25),
('2019-12-31', 'Тёплая вода', 'м^3', 28),
('2018-12-31', 'Электричество', 'КВт/ч', 3.5),
('2019-12-31', 'Электричество', 'КВт/ч', 4),
('2018-12-31', 'Газ', 'м^3', 10),
('2019-12-31', 'Газ', 'м^3', 12),
('2018-12-31', 'Канализация', 'м^3', 18),
('2019-12-31', 'Канализация', 'м^3', 20);

INSERT INTO Apartment
VALUES 
('Саксаганский Шарль Александрович', 'Umber Gate', 1, 1, 30, 1),
('Плаксий Чарльз Сергеевич', 'Wishing Quail Quay', 5, 2, 30, 2),
('Ефимов Заур Романович', 'Pleasant Knoll', 10, 1, 30, 2),
('Лыткин Люций Романович', 'Stony River Crest', 12, 1, 35, 3),
('Горбунов Цицерон Юхимович', 'Gentle Spring Crescent', 6, 1, 28, 2),
('Барановский Оскар Михайлович', 'Gentle Spring Crescent', 3, 1, 35, 1),
('Гриневская Владлен Эдуардович', 'Gentle Spring Crescent', 3, 2, 35, 2),
('Воробьёв Радислав Алексеевич', 'Wishing Quail Quay', 2, 3, 38, 3),
('Поляков Юлиан Дмитриевич', 'Umber Gate', 7, 2, 30, 3);

INSERT INTO Apartment_Consumtion
VALUES 
(1, '2020-03-30', 3, 1, 4, 20, 20, 1, 1, 1),
(2, '2020-04-02', 5, 2, 7, 23, 18, 1, 1, 1),
(3, '2020-04-06', 10, 1, 12, 39, 17, 1, 1, 1),
(4, '2020-04-23', 12, 1, 13, 34, 20, 1, 1, 1),
(5, '2020-04-27', 6, 1, 7, 28, 19, 1, 1, 1),
(6, '2020-03-31', 3, 1, 4, 26, 22, 1, 1, 1),
(7, '2020-04-02', 3, 2, 5, 22, 25, 1, 1, 1),
(8, '2020-04-10', 2, 3, 5, 15, 23, 1, 1, 1),
(9, '2020-04-15', 7, 2, 10, 45, 22, 1, 1, 1);

INSERT INTO Bill
VALUES 
(1, 1, '2019-11-15', 1001),
(2, 2, '2019-12-15', 1200),
(3, 3, '2019-12-15', 1300),
(4, 4, '2019-12-15', 1400),
(5, 5, '2020-1-15', 1500),
(6, 6, '2020-2-15', 1550),
(7, 7, '2020-2-15', 1650),
(8, 8, '2020-4-15', 1100),
(9, 9, '2020-4-15', 1250);

/*1.INSERT*/

INSERT INTO Tariff
VALUES ('2019-12-31', 'Вода', 'м^3', 18);

INSERT INTO Tariff_New(up_to_date, resource, measure_unit, price)
VALUES ('2020-06-30', 'Вода', 'куб. метр', 20);

INSERT INTO Tariff(up_to_date, resource, measure_unit, price)
SELECT up_to_date, resource, measure_unit, price
FROM Tariff_New;

/*2.DELETE*/

DELETE FROM Tariff_New;

DELETE FROM Tariff
WHERE up_to_date = '2019-12-31';

TRUNCATE TABLE Tariff;

/*3.UPDATE*/

UPDATE Tariff
SET measure_unit = 'м^3';

UPDATE Tariff
SET price = '21'
WHERE id_tariff = 2;

UPDATE Tariff
SET price = '20', measure_unit = '900 л' 
WHERE id_tariff = 2;

/*4.SELECT*/

SELECT id_tariff, resource, price
FROM Tariff;

SELECT *
FROM Tariff;

SELECT *
FROM Tariff
WHERE up_to_date > '2020.06.01';

/*5.SELECT ORDER BY + TOP (LIMIT)*/

SELECT TOP(10) *
FROM Tariff
ORDER BY price ASC;

SELECT *
FROM Tariff
ORDER BY price DESC;

SELECT *
FROM 
	(SELECT price, resource
	FROM Tariff) AS A
ORDER BY price ASC;

/*6.Работа с датами*/

SELECT *
FROM Tariff
WHERE up_to_date > '2020.06.01';

SELECT YEAR(up_to_date) AS 'YEAR'
FROM Tariff
WHERE id_tariff = 2;

/*7.SELECT GROUP BY*/

SELECT resource, MIN(price)
FROM Tariff
GROUP BY "resource";

SELECT resource, MAX(up_to_date)
FROM Tariff
GROUP BY "resource";

SELECT resource, AVG(price)
FROM Tariff
GROUP BY "resource";

SELECT street, SUM(tenant_amount)
FROM Apartment
GROUP BY "street";

SELECT street, COUNT(id_apartment)
FROM Apartment
GROUP BY "street";

/*8.SELECT GROUP BY + HAVING*/

SELECT COUNT(id_apartment), street
FROM Apartment
GROUP BY "street"
HAVING COUNT(id_apartment) > 2;

SELECT AVG(area), street
FROM Apartment
GROUP BY "street"
HAVING AVG(area) > 32;

SELECT AVG(area), street
FROM Apartment
WHERE tenant_amount > 2
GROUP BY "street"
HAVING AVG(area) > 30;

/*8.SELECT JOIN*/

SELECT 
	Apartment.id_apartment, firstname_lastname, street, house_number, apartment_number, water
FROM
	Apartment LEFT JOIN Apartment_Consumtion 
	ON Apartment.id_apartment = Apartment_Consumtion.id_apartment
WHERE
	water > 5;

SELECT 
	Apartment.id_apartment, firstname_lastname, street, house_number, apartment_number, water
FROM
	Apartment_Consumtion RIGHT JOIN Apartment
	ON Apartment_Consumtion.id_apartment = Apartment.id_apartment
WHERE
	water > 5;

SELECT 
	Apartment.id_apartment, firstname_lastname, street, house_number, apartment_number
FROM
	Bill 
	LEFT JOIN Apartment_Consumtion ON Bill.id_apartment_consumption = Apartment_Consumtion.id_apartment_consumption
	LEFT JOIN Apartment ON Apartment_Consumtion.id_apartment = Apartment.id_apartment
WHERE
	sum > 1200 and electricity > 20 and tenant_amount < 2

/*Подзапросы*/

SELECT *
FROM 
	Apartment
WHERE id_apartment IN (
	SELECT id_apartment
	FROM 
		Apartment_Consumtion
	WHERE 
		water > 5);

SELECT "resource", (SELECT count("resource")
	FROM Tariff
	WHERE "resource" = 'Вода')
FROM 
	Tariff
WHERE "resource" = 'Вода'
GROUP BY "resource"
	
