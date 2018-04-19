-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Мар 14 2018 г., 19:39
-- Версия сервера: 5.7.19
-- Версия PHP: 5.6.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `lab1`
--

-- --------------------------------------------------------

--
-- Структура таблицы `apartment`
--

DROP TABLE IF EXISTS `apartment`;
CREATE TABLE IF NOT EXISTS `apartment` (
  `id_apartment` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `address` varchar(100) NOT NULL,
  `price` float UNSIGNED NOT NULL,
  PRIMARY KEY (`id_apartment`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `apartment`
--

INSERT INTO `apartment` (`id_apartment`, `address`, `price`) VALUES
(1, 'Йошкар-Ола ул.Ленина', 1000),
(2, 'Москва ул.Строителей', 10000),
(3, 'Волгоград ул.Машиностроителей', 500),
(4, 'Москва ул.Интернационалистов', 2000),
(5, 'Йошкар-Ола ул.Ленина', 3000),
(6, 'Йошкар-Ола, ул.Свердловская', 100000);

-- --------------------------------------------------------

--
-- Структура таблицы `appeal_x_realtor`
--

DROP TABLE IF EXISTS `appeal_x_realtor`;
CREATE TABLE IF NOT EXISTS `appeal_x_realtor` (
  `id_appeal` int(11) NOT NULL AUTO_INCREMENT,
  `id_client` int(11) NOT NULL,
  `id_apartment` int(11) NOT NULL,
  `transaction_amount` int(11) NOT NULL,
  `appeal_date` datetime NOT NULL,
  PRIMARY KEY (`id_appeal`),
  KEY `id_client` (`id_client`),
  KEY `id_apartment` (`id_apartment`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `appeal_x_realtor`
--

INSERT INTO `appeal_x_realtor` (`id_appeal`, `id_client`, `id_apartment`, `transaction_amount`, `appeal_date`) VALUES
(1, 1, 1, 100000, '2018-02-07 00:00:00'),
(2, 2, 2, 300000, '2018-02-26 00:00:00'),
(3, 3, 3, 100000, '2017-10-31 00:00:00'),
(4, 4, 4, 400000, '2018-02-26 00:00:00'),
(5, 5, 5, 60000, '2017-07-10 00:00:00');

-- --------------------------------------------------------

--
-- Структура таблицы `client`
--

DROP TABLE IF EXISTS `client`;
CREATE TABLE IF NOT EXISTS `client` (
  `id_client` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `client_name` varchar(100) NOT NULL,
  PRIMARY KEY (`id_client`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `client`
--

INSERT INTO `client` (`id_client`, `client_name`) VALUES
(1, 'Иван Иванович Иванов'),
(2, 'Пупкин Василий Иванович'),
(3, 'Смирнов Сергей Сергеевич'),
(4, 'Смирнов Андрей Сергеевич'),
(5, 'Васильев Василий Васильевич'),
(6, 'Петров Петр Петрович'),
(7, 'Петров Петр Петрович');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
