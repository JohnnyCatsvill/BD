CREATE TABLE "Hotel" (
	"id_hotel" INTEGER PRIMARY KEY IDENTITY,
	"name" NVARCHAR(50) NOT NULL, 
	"stars" INTEGER NOT NULL
);

CREATE TABLE "Room_Category" (
	"id_room_category" INTEGER PRIMARY KEY IDENTITY,
	"name" NVARCHAR(30) NOT NULL, 
	"min_area" INTEGER NOT NULL
);

CREATE TABLE "Room" (
	"id_room" INTEGER PRIMARY KEY IDENTITY, 
	"id_hotel" INTEGER NOT NULL,
	"id_room_category" INTEGER NOT NULL,
	"number" INTEGER NOT NULL,
	"day_cost" MONEY NOT NULL 
);

CREATE TABLE "Client" (
	"id_client" INTEGER PRIMARY KEY IDENTITY, 
	"name" NVARCHAR(50) NOT NULL,
	"phone" NVARCHAR(12) NOT NULL
);

CREATE TABLE "Booking" (
	"id_booking" INTEGER PRIMARY KEY IDENTITY, 
	"id_client" INTEGER NOT NULL,
	"date" DATE NOT NULL
);

CREATE TABLE "Room_in_Booking" (
	"id_room_booking" INTEGER PRIMARY KEY IDENTITY,
	"id_booking" INTEGER NOT NULL,
	"id_room" INTEGER NOT NULL,
	"check_in_date" DATE NOT NULL,
	"check_out_date" DATE NOT NULL
);

BULK INSERT Hotel
FROM 'C:\Users\aleks\OneDrive\Рабочий стол\csv\hotel.csv'
WITH (fieldterminator = ';', rowterminator = '\n', codepage = '65001');

BULK INSERT Room_Category
FROM 'C:\Users\aleks\OneDrive\Рабочий стол\csv\room_category.csv'
WITH (fieldterminator = ';', rowterminator = '\n', codepage = '65001');

BULK INSERT Room
FROM 'C:\Users\aleks\OneDrive\Рабочий стол\csv\room.csv'
WITH (fieldterminator = ';', rowterminator = '\n', codepage = '65001');

BULK INSERT Client
FROM 'C:\Users\aleks\OneDrive\Рабочий стол\csv\client.csv'
WITH (fieldterminator = ';', rowterminator = '\n', codepage = '65001');

BULK INSERT Booking
FROM 'C:\Users\aleks\OneDrive\Рабочий стол\csv\booking.csv'
WITH (fieldterminator = ';', rowterminator = '\n', codepage = '65001');

BULK INSERT Room_in_Booking
FROM 'C:\Users\aleks\OneDrive\Рабочий стол\csv\room_in_booking.csv'
WITH (fieldterminator = ';', rowterminator = '\n', codepage = '65001');

/*1.Добавить внешние ключи.*/

ALTER TABLE Room
	ADD FOREIGN KEY (id_hotel) REFERENCES Hotel(id_hotel) ON DELETE CASCADE;

ALTER TABLE Booking
	ADD FOREIGN KEY (id_client) REFERENCES Client(id_client) ON DELETE CASCADE;

ALTER TABLE Room_in_Booking
	ADD FOREIGN KEY (id_booking) REFERENCES Booking(id_booking) ON DELETE CASCADE;

ALTER TABLE Room_in_Booking
	ADD FOREIGN KEY (id_room) REFERENCES Room(id_room) ON DELETE CASCADE;

ALTER TABLE Room
	ADD FOREIGN KEY (id_room_category) REFERENCES Room_Category(id_room_category) ON DELETE CASCADE;

/*2.Выдать информацию о клиентах гостиницы “Космос”, проживающих в номерах категории “Люкс” на 1 апреля 2019г*/

SELECT 
	Client.name, Client.phone, Hotel.name, Room_Category.name, check_in_date, check_out_date
FROM
	Room_in_Booking
	LEFT JOIN Booking ON Room_in_Booking.id_booking = Booking.id_booking
	LEFT JOIN Room ON Room_in_Booking.id_room = Room.id_room
	LEFT JOIN Room_Category ON Room.id_room_category = Room_Category.id_room_category
	LEFT JOIN Hotel ON Room.id_hotel = Hotel.id_hotel
	LEFT JOIN Client ON Booking.id_client = Client.id_client
WHERE
	Hotel.name = 'Космос' and
	Room_Category.name = 'Люкс' and 
	check_in_date <= '2019-04-01' and 
	check_out_date > '2019-04-01';

/*3.Дать список свободных номеров всех гостиниц на 22 апреля*/

SELECT 
	 Hotel.name, Hotel.stars, Room.id_room, Room.number, Room_Category.name, Room.day_cost
FROM
	Room
	LEFT OUTER JOIN (
		SELECT 
			id_room as occupied
		FROM
			Room_in_Booking
		WHERE
			check_in_date <= '2019-04-22' and 
			check_out_date > '2019-04-22') AS A 
	ON Room.id_room = A.occupied
	LEFT JOIN Room_Category ON Room.id_room_category = Room_Category.id_room_category
	LEFT JOIN Hotel ON Room.id_hotel = Hotel.id_hotel
WHERE
	A.occupied is NULL

/*4.Дать количество проживающих в гостинице “Космос” на 23 марта по каждой категории номеров*/

SELECT 
	Room_Category.name ,COUNT(Room_Category.id_room_category)
FROM
	Room_in_Booking
	LEFT JOIN Room ON Room_in_Booking.id_room = Room.id_room
	LEFT JOIN Room_Category ON Room.id_room_category = Room_Category.id_room_category
	LEFT JOIN Hotel ON Room.id_hotel = Hotel.id_hotel
WHERE
	Hotel.name = 'Космос' and
	check_in_date <= '2019-03-23' and 
	check_out_date > '2019-03-23'
GROUP BY Room_Category.id_room_category, Room_Category.name	

/*5.Дать список последних проживавших клиентов по всем комнатам гостиницы “Космос”, выехавшим в апреле с указанием даты выезда*/

SELECT 
	Room.number ,Client.name, Client.phone, check_out_date
FROM
	Room_in_Booking
	LEFT JOIN Booking ON Room_in_Booking.id_booking = Booking.id_booking
	LEFT JOIN Room ON Room_in_Booking.id_room = Room.id_room
	LEFT JOIN Hotel ON Room.id_hotel = Hotel.id_hotel
	LEFT JOIN Client ON Booking.id_client = Client.id_client
WHERE id_room_booking IN 
(
	SELECT
		MAX(id_room_booking)
	FROM
		Room_in_Booking
	WHERE
		check_out_date >= '2019-04-01' and 
		check_out_date < '2019-05-01'
	GROUP BY
		Room_in_Booking.id_room
) and
	Hotel.name = 'Космос'
ORDER BY number ASC;

/*6.Продлить на 2 дня дату проживания в гостинице “Космос” всем клиентам комнат категории “Бизнес”, которые заселились 10 мая.*/

UPDATE 
	Room_in_Booking
SET 
	check_out_date = DATEADD(DAY, 2, check_out_date)
WHERE 
	check_in_date = '2019-05-10' and
	Room_in_Booking.id_room IN
	(
	SELECT 
		Room.id_room
		FROM
			Room
			LEFT JOIN Room_Category ON Room.id_room_category = Room_Category.id_room_category
			LEFT JOIN Hotel ON Room.id_hotel = Hotel.id_hotel
		WHERE
			Hotel.name = 'Космос' and
			Room_Category.name = 'Бизнес'
	)

/*7. Найти все "пересекающиеся" варианты проживания.*/

SELECT
	*
FROM
	Room_in_Booking as first
	CROSS JOIN Room_in_Booking as second
WHERE
	first.id_room_booking != second.id_room_booking and
	first.id_room = second.id_room and 
	first.check_in_date >= second.check_in_date and first.check_in_date < second.check_out_date

/*8.Создать бронирование в транзакции*/

USE HotelReservation

BEGIN TRANSACTION

INSERT
INTO Client
VALUES 
	('Сидоров Устин Андреевич', 79992356457);

INSERT
INTO Booking
VALUES 
	(SCOPE_IDENTITY(), '2020-05-01');

INSERT
INTO Room_in_Booking
VALUES 
	(SCOPE_IDENTITY(), 15, '2020-05-01', '2020-05-07')

COMMIT;

/*9.Добавить необходимые индексы для всех таблиц.*/

CREATE INDEX IX_Room_in_Booking_id_booking
ON Room_in_Booking(id_booking ASC);

CREATE INDEX IX_Room_id_hotel
ON Room(id_hotel ASC);

CREATE INDEX IX_Booking_id_client
ON Booking(id_client ASC);

CREATE INDEX IX_Room_in_Booking_id_room
ON Room_in_Booking(id_room ASC);

DROP INDEX IX_Room_in_Booking_id_room
ON Room_in_Booking

CREATE INDEX IX_Room_id_room_category
ON Room(id_room_category ASC);
