CREATE TABLE "Apartment" (
	"id_apartment" INTEGER PRIMARY KEY IDENTITY,
	"owner_name" NVARCHAR(50) NOT NULL,
	"street" NVARCHAR(30) NOT NULL,
	"house_number" INTEGER NOT NULL,
	"apartment_number" INTEGER NOT NULL,
	"area" FLOAT NOT NULL,
	"tenant_amount" INTEGER NOT NULL
);

CREATE TABLE "Tariff" (
	"id_tariff" INTEGER PRIMARY KEY IDENTITY,
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

CREATE TABLE "Apartment_Tariff" (
	"id_apartment_tariff" INTEGER PRIMARY KEY IDENTITY,
	"id_apartment" INTEGER NOT NULL,
	"id_tariff" INTEGER NOT NULL
);

CREATE TABLE "Apartment_Consumtion" (
	"id_apartment_consumtion" INTEGER PRIMARY KEY IDENTITY,
	"id_apartment_tariff" INTEGER NOT NULL,
	"date" DATE NOT NULL,
	"consumtion" FLOAT NOT NULL
);


CREATE TABLE "Bill" (
	"id_bill" INTEGER PRIMARY KEY IDENTITY,
	"id_apartment_tariff" INTEGER NOT NULL,
	"id_apartment_consumption" INTEGER NOT NULL,
	"pay_up_to_date" DATE NOT NULL,
	"sum" MONEY NOT NULL,
);

CREATE TABLE "Payment" (
	"id_payment" INTEGER PRIMARY KEY IDENTITY,
	"id_bill" INTEGER NOT NULL,
	"payment_day" DATE,
	"payment" MONEY NOT NULL,
	"cheque" TEXT NOT NULL
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

INSERT INTO Apartment_Tariff
VALUES 
(1, 1), (1, 2), (1, 4), (1, 6), (1, 8),
(2, 1), (2, 2), (2, 4), (2, 6), (2, 8),
(3, 1), (3, 2), (3, 4), (3, 6), (3, 8),
(4, 1), (4, 2), (4, 4), (4, 6), (4, 8),
(5, 1), (5, 3), (5, 5), (5, 7), (5, 9),
(6, 1), (6, 3), (6, 5), (6, 7), (6, 9),
(7, 1), (7, 3), (7, 5), (7, 7), (7, 9),
(8, 1), (8, 3), (8, 5), (8, 7), (8, 9),
(9, 1), (9, 3), (9, 5), (9, 7), (9, 9)


INSERT INTO Apartment_Consumtion
VALUES 
(1, '2020-03-30', 20),
(2, '2020-04-02', 18),
(3, '2020-04-06', 17),
(4, '2020-04-23', 20),
(5, '2020-04-27', 19),
(6, '2020-03-31', 22),
(7, '2020-04-02', 25),
(8, '2020-04-10', 23),
(9, '2020-04-15', 22);

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
	*
FROM
	Apartment_Tariff
	LEFT JOIN Tariff ON Tariff.id_tariff = Apartment_Tariff.id_tariff
WHERE
	Tariff.resource = 'Вода'

SELECT 
	*
FROM
	Tariff
	RIGHT JOIN Apartment_Tariff ON Tariff.id_tariff = Apartment_Tariff.id_tariff
WHERE
	Tariff.resource = 'Вода'

SELECT 
	id_apartment, consumtion
FROM
	Apartment_Tariff
	LEFT JOIN Tariff ON Tariff.id_tariff = Apartment_Tariff.id_tariff
	LEFT JOIN Apartment_Consumtion ON Apartment_Consumtion.id_apartment_tariff = Apartment_Tariff.id_apartment_tariff
WHERE
	Tariff.resource = 'Вода' and
	Apartment_Consumtion.consumtion > 5

SELECT 
	*
FROM
	Tariff
	FULL OUTER JOIN Apartment_Tariff ON Tariff.id_tariff = Apartment_Tariff.id_tariff

/*Подзапросы*/

SELECT *
FROM 
	Apartment
WHERE id_apartment IN (
	SELECT id_apartment
	FROM 
		Apartment_Tariff
		LEFT JOIN Apartment_Consumtion ON Apartment_Consumtion.id_apartment_tariff = Apartment_Tariff.id_apartment_tariff
		LEFT JOIN Tariff ON Tariff.id_tariff = Apartment_Tariff.id_tariff
	WHERE 
		consumtion > 18 and
		resource = 'Вода');

SELECT "resource", (SELECT count("resource")
	FROM Tariff
	WHERE "resource" = 'Вода')
FROM 
	Tariff
WHERE "resource" = 'Вода'
GROUP BY "resource"
	

		