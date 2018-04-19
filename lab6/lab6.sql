-- hotel(гостиница)
DROP TABLE IF EXISTS `hotel`;
CREATE TABLE IF NOT EXISTS `hotel` (
  `id_hotel` INT(11) NOT NULL AUTO_INCREMENT,
  `hotel_name` VARCHAR(100) DEFAULT NULL,
  `stars_number` TINYINT UNSIGNED DEFAULT NULL,
  `address` VARCHAR(100) DEFAULT NULL,
  PRIMARY KEY (`id_hotel`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


-- room_kind(категория номеров)
DROP TABLE IF EXISTS `room_kind`;
CREATE TABLE IF NOT EXISTS `room_kind` (
  `id_room_kind` INT(11) NOT NULL AUTO_INCREMENT,
  `category_name` VARCHAR(100) DEFAULT NULL,
  `minimum_area_by_category` FLOAT UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id_room_kind`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


-- room(комната)
DROP TABLE IF EXISTS `room`;
CREATE TABLE IF NOT EXISTS `room` (
  `id_room` INT(11) NOT NULL AUTO_INCREMENT,
  `id_hotel` INT(11) NOT NULL,
  `id_room_kind` INT(11) NOT NULL,
  `room_number_in_hotel` INT(11) UNSIGNED NOT NULL,
  `cost_of_one_night_stay` FLOAT DEFAULT NULL,
  PRIMARY KEY (`id_room`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


-- client(клиент)
DROP TABLE IF EXISTS `client`;
CREATE TABLE IF NOT EXISTS `client` (
  `id_client` INT(11) NOT NULL AUTO_INCREMENT,
  `full_name` VARCHAR(100) NOT NULL,
  `phone_number` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_client`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


-- booking(бронь)
DROP TABLE IF EXISTS `booking`;
CREATE TABLE IF NOT EXISTS `booking` (
  `id_booking` INT(11) NOT NULL AUTO_INCREMENT,
  `id_client` INT(11) NOT NULL,
  `booking_date` DATETIME DEFAULT NULL,
  PRIMARY KEY (`id_booking`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


-- booking_room(комната в брони)
DROP TABLE IF EXISTS `booking_room`;
CREATE TABLE IF NOT EXISTS `booking_room` (
  `id_booking_room` INT(11) NOT NULL AUTO_INCREMENT,
  `id_booking` INT(11) NOT NULL,
  `id_room` INT(11) NOT NULL,
  `order_date` DATETIME NULL,
  `departure_date` DATETIME NULL,
  PRIMARY KEY (`id_booking_room`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


-- 2 Выдать информацию о клиентах гостиницы “Алтай”, проживающих в номерах категории “люкс”.
EXPLAIN SELECT client.id_client, client.full_name, client.phone_number, room_kind.category_name, hotel.hotel_name, hotel.id_hotel
FROM `booking`
  LEFT JOIN `client` ON client.id_client = booking.id_client
  LEFT JOIN `booking_room` ON booking_room.id_booking = booking.id_booking
  LEFT JOIN `room` ON room.id_room = booking_room.id_room
  LEFT JOIN `hotel` ON hotel.id_hotel = room.id_hotel
  LEFT JOIN `room_kind` ON room_kind.id_room_kind = room.id_room_kind
WHERE room_kind.category_name = 'люкс' AND hotel.hotel_name = 'Алтай';

-- 3	Дать список свободных номеров всех гостиниц на 30.05.12.
EXPLAIN SELECT room.room_number_in_hotel AS room_number, room.id_room, hotel.hotel_name, booking_room.order_date, booking_room.departure_date
FROM `room`
  LEFT JOIN `booking_room` ON room.id_room = booking_room.id_room
  LEFT JOIN `hotel` ON room.id_hotel = hotel.id_hotel
WHERE (booking_room.order_date < '2012-05-30' AND booking_room.departure_date < '2012-05-30') OR
      (booking_room.order_date > '2012-05-30' AND booking_room.departure_date > '2012-05-30')
      OR booking_room.order_date IS NULL;

-- 4	Дать количество проживающих в гостинице “Восток” на 25.05.12 по каждой категории номера
EXPLAIN SELECT COUNT(room.id_room_kind) AS clients, room.id_room_kind
FROM `booking_room`
  LEFT JOIN `room` ON room.id_room = booking_room.id_room
  LEFT JOIN `hotel` ON hotel.id_hotel = room.id_hotel
WHERE booking_room.order_date <= '2012-05-25' AND booking_room.departure_date >= '2012-05-25' AND hotel.hotel_name = 'Восток'
GROUP BY room.id_room_kind;

-- 5	Дать список последних проживавших клиентов по всем комнатам гостиницы “Космос”, выехавшим в апреле 2012 с указанием даты выезда.
CREATE TEMPORARY TABLE IF NOT EXISTS tmp_table AS (
  SELECT booking_room.id_room, MAX(booking_room.departure_date) as d_date
  FROM `booking_room`
    LEFT JOIN `room` ON room.id_room = booking_room.id_room
  WHERE room.id_hotel = 7 AND booking_room.departure_date BETWEEN '2012-04-01' AND '2012-04-30'
  GROUP BY booking_room.id_room
);

SELECT client.id_client, client.full_name, tmp_table.d_date AS departure, tmp_table.id_room
FROM `tmp_table`
  LEFT JOIN `booking_room` ON tmp_table.id_room = booking_room.id_room AND tmp_table.d_date = booking_room.departure_date
  LEFT JOIN `booking` ON booking_room.id_booking = booking.id_booking
  LEFT JOIN `client` ON booking.id_client = client.id_client;
DROP TABLE tmp_table;

-- 6  Продлить до 30.05.12 дату проживания в гостинице “Сокол”
-- всем клиентам комнат категории “люкс”, которые заселились 15.05.12, а выезжают 28.05.12
UPDATE `booking_room`
  LEFT JOIN `room` ON room.id_room = booking_room.id_room
SET booking_room.departure_date = '2012-05-30'
  WHERE room.id_hotel = 7 AND room.id_room_kind = 1
    AND booking_room.departure_date = '2012-05-30' AND booking_room.order_date = '2012-05-15';

-- 7  Привести пример транзакции при создании брони.
START TRANSACTION;
INSERT INTO `client` VALUES (NULL, 'Фамилия имя отчество', '+7927-123-12-12');
SELECT @new_id_client := LAST_INSERT_ID();
INSERT INTO `booking`  VALUES (NULL, @new_id_client, '2018-07-10');
SELECT @new_id_booking := LAST_INSERT_ID();
INSERT INTO `booking_room` VALUES (NULL, @new_id_booking, 1, '2018-07-11', '2018-07-20');
COMMIT;