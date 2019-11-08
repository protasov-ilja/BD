# База данных для онлайн магазина поп родажам муз интсрументов
use lab8;


-- manufacturer(производитель)
DROP TABLE IF EXISTS `manufacturer`;
CREATE TABLE IF NOT EXISTS `manufacturer` (
  `id_manufacturer` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `agent_name` VARCHAR(255) NOT NULL,
  `phone` VARCHAR(255) NOT NULL,
  `banking_account` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id_manufacturer`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


-- vendor(поставщик)
DROP TABLE IF EXISTS `vendor`;
CREATE TABLE IF NOT EXISTS `vendor` (
  `id_vendor` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `agent_name` VARCHAR(255) NOT NULL,
  `phone` VARCHAR(255) NOT NULL,
  `banking_account` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id_vendor`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


-- user(пользователь)
DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `id_user` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `full_name` VARCHAR(255) NOT NULL,
  `mail` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `wallet_number` VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (`id_user`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


-- goods_catalog(каталог)
DROP TABLE IF EXISTS `goods_catalog`;
CREATE TABLE IF NOT EXISTS `goods_catalog` (
  `id_catalog` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id_catalog`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


-- goods(товары)
DROP TABLE IF EXISTS `goods`;
CREATE TABLE IF NOT EXISTS `goods` (
  `id_goods` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `image` VARCHAR(255) NOT NULL,
  `description` TEXT NOT NULL,
  `cost` FLOAT UNSIGNED NOT NULL,
  `id_manufacturer` INT(11) UNSIGNED NOT NULL,
  `id_catalog` INT(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`id_goods`),
  KEY `id_manufacturer` (`id_manufacturer`),
  KEY `id_catalog` (`id_catalog`),
  FOREIGN KEY (`id_manufacturer`) REFERENCES `manufacturer`(`id_manufacturer`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  FOREIGN KEY (`id_catalog`) REFERENCES `goods_catalog`(`id_catalog`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


-- lot(партия)
DROP TABLE IF EXISTS `lot`;
CREATE TABLE IF NOT EXISTS `lot` (
  `id_lot` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_vendor` INT(11) UNSIGNED NOT NULL,
  `total_cost` FLOAT UNSIGNED NOT NULL,
  PRIMARY KEY (`id_lot`),
  KEY `id_vendor` (`id_vendor`),
  FOREIGN KEY (`id_vendor`) REFERENCES `vendor`(`id_vendor`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


-- goods_in_lot(товары в партии)
DROP TABLE IF EXISTS `goods_in_lot`;
CREATE TABLE IF NOT EXISTS `goods_in_lot` (
  `id_goods_in_lot` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_goods` INT(11) UNSIGNED NOT NULL,
  `id_lot` INT(11) UNSIGNED NOT NULL,
  `amount` INT(11) UNSIGNED NOT NULL,
  `total_cost` FLOAT UNSIGNED NOT NULL,
  PRIMARY KEY (`id_goods_in_lot`),
  KEY `id_goods` (`id_goods`),
  KEY `id_lot` (`id_lot`),
  FOREIGN KEY (`id_goods`) REFERENCES `goods`(`id_goods`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  FOREIGN KEY (`id_lot`) REFERENCES `lot`(`id_lot`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


-- order(заказ)
DROP TABLE IF EXISTS `order`;
CREATE TABLE IF NOT EXISTS `order` (
  `id_order` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_user` INT(11) UNSIGNED NOT NULL,
  `amount` INT(11) UNSIGNED DEFAULT 1,
  `total_cost` FLOAT UNSIGNED NOT NULL,
  PRIMARY KEY (`id_order`),
  KEY `id_user` (`id_user`),
  FOREIGN KEY (`id_user`) REFERENCES `user`(`id_user`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- order(заказ)
DROP TABLE IF EXISTS `goods_in_order`;
CREATE TABLE IF NOT EXISTS `goods_in_order` (
  `id_goods_in_order` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_order` INT(11) UNSIGNED NOT NULL,
  `id_goods` INT(11) UNSIGNED NOT NULL,
  `amount` INT(11) UNSIGNED DEFAULT 1,
  PRIMARY KEY (`id_goods_in_order`),
  KEY `id_order` (`id_order`),
  KEY `id_goods` (`id_goods`),
  FOREIGN KEY (`id_order`) REFERENCES `order`(`id_order`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  FOREIGN KEY (`id_goods`) REFERENCES `goods`(`id_goods`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;