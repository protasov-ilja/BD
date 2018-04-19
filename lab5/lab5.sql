-- pharmacy(оптека)
DROP TABLE IF EXISTS `pharmacy`;
CREATE TABLE IF NOT EXISTS `pharmacy` (
  `id_pharmacy` INT(11) NOT NULL AUTO_INCREMENT,
  `pharmacy_name` VARCHAR(100) DEFAULT NULL,
  `pharmacy_address` VARCHAR(100) DEFAULT NULL,
  PRIMARY KEY (`id_pharmacy`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


ALTER TABLE `pharmacy`
  ADD FOREIGN KEY (`id_pharmacy`)
REFERENCES `order` (`id_pharmacy`)
  ON DELETE RESTRICT ON UPDATE RESTRICT;

-- medicine(лекарство)
DROP TABLE IF EXISTS `medicine`;
CREATE TABLE IF NOT EXISTS `medicine` (
  `id_medicine` INT(11) NOT NULL AUTO_INCREMENT,
  `medicine_name` VARCHAR(100) DEFAULT NULL,
  `duration_of_standard_treatment_course` INT(11) DEFAULT NULL,
  PRIMARY KEY (`id_medicine`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


-- medicines_manufacture(производство лекарств)
DROP TABLE IF EXISTS `medicines_manufacture`;
CREATE TABLE IF NOT EXISTS `medicines_manufacture` (
  `id_lot` INT(11) NOT NULL AUTO_INCREMENT,
  `id_company` INT(11) NOT NULL,
  `id_medicine` INT(11) NOT NULL,
  `unit_value` FLOAT NOT NULL,
  `quality_control` TINYINT UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id_lot`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


-- company_dealer(дилер компании)
DROP TABLE IF EXISTS `company_dealer`;
CREATE TABLE IF NOT EXISTS `company_dealer` (
  `id_dealer` INT(11) NOT NULL AUTO_INCREMENT,
  `id_company` INT(11) NOT NULL,
  `surname` VARCHAR(100) NOT NULL,
  `phone_number` VARCHAR(45) DEFAULT NULL,
  PRIMARY KEY (`id_dealer`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


-- pharmacological_company(фармакологическая компания)
DROP TABLE IF EXISTS `pharmacological_company`;
CREATE TABLE IF NOT EXISTS `pharmacological_company` (
  `id_company` INT(11) NOT NULL AUTO_INCREMENT,
  `company_name` VARCHAR(100) NOT NULL,
  `foundation_year` YEAR(4) NOT NULL,
  PRIMARY KEY (`id_company`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


-- order(заказ)
DROP TABLE IF EXISTS `order`;
CREATE TABLE IF NOT EXISTS `order` (
  `id_order` INT(11) NOT NULL AUTO_INCREMENT,
  `id_lot` INT(11) NOT NULL,
  `id_dealer` INT(11) NOT NULL,
  `id_pharmacy` INT(11) NOT NULL,
  `order_date` DATETIME NOT NULL,
  `medicine_amount` INT(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`id_order`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
TRUNCATE TABLE `order`;

-- 2
-- Выдать информацию по всем заказам лекарства “Кордерон” компании “Аргус” с указанием названий аптек, дат, объема заказов.
EXPLAIN SELECT id_order, pharmacy.pharmacy_name, order_date, medicine_amount, medicine.medicine_name, pharmacological_company.company_name
FROM `order_medicines`
  LEFT JOIN `pharmacy` ON order_medicines.id_pharmacy = pharmacy.id_pharmacy
  LEFT JOIN `medicines_manufacture` ON order_medicines.id_lot = medicines_manufacture.id_lot
  LEFT JOIN `medicine` ON medicines_manufacture.id_medicine = medicine.id_medicine
  LEFT JOIN `pharmacological_company` ON medicines_manufacture.id_company = pharmacological_company.id_company
WHERE medicine.medicine_name = 'Кордерон' AND pharmacological_company.company_name = 'Аргус';

-- 3
-- Дать список лекарств компании “Фарма”, на которые не были сделаны заказы до 1.05.12
EXPLAIN SELECT medicine.medicine_name, MIN(order_date) AS min_order_date, pharmacological_company.company_name
FROM `order_medicines`
  LEFT JOIN `medicines_manufacture` ON order_medicines.id_lot = medicines_manufacture.id_lot
  LEFT JOIN `medicine` ON medicines_manufacture.id_medicine = medicine.id_medicine
  LEFT JOIN `pharmacological_company` ON medicines_manufacture.id_company = pharmacological_company.id_company
WHERE pharmacological_company.company_name = 'Фарма'
GROUP BY medicine.medicine_name
HAVING min_order_date > '2012-05-1 00:00:00';

-- 4
-- Дать минимальный и максимальный баллы по лекарствам каждой фирмы, которая производит не менее 100 препаратов, с указанием названий фирмы и лекарства.
EXPLAIN SELECT MAX(medicines_manufacture.quality_control) as max_quality, MIN(medicines_manufacture.quality_control) as min_quality,
  pharmacological_company.company_name, COUNT(medicines_manufacture.id_company) AS company_count
FROM medicines_manufacture
  LEFT JOIN `pharmacological_company` ON pharmacological_company.id_company = medicines_manufacture.id_company
  LEFT JOIN medicine ON medicine.id_medicine = medicines_manufacture.id_medicine
GROUP BY pharmacological_company.company_name
HAVING company_count >= 10;

-- 5 Дать списки сделавших заказы аптек по всем дилерам компании “Гедеон Рихтер”. Если у дилера нет заказов, в названии аптеки проставить NULL.
EXPLAIN SELECT pharmacy.pharmacy_name,
  order_medicines.id_pharmacy,
  order_medicines.id_dealer,
  pharmacological_company.company_name,
  company_dealer.id_company
FROM `company_dealer`
  LEFT JOIN `order_medicines` ON order_medicines.id_dealer = company_dealer.id_dealer
  LEFT JOIN `pharmacy` ON pharmacy.id_pharmacy = order_medicines.id_pharmacy
  LEFT JOIN `pharmacological_company` ON pharmacological_company.id_company = company_dealer.id_company
WHERE company_dealer.id_company = 21;

-- 6 Уменьшить на 20% стоимость всех лекарств, если она превышает 3000, а длительность лечения не более 7 дней.
UPDATE medicines_manufacture
  LEFT JOIN `medicine` ON medicine.id_medicine = medicines_manufacture.id_medicine
SET unit_value = unit_value * 0.8
WHERE medicines_manufacture.unit_value > 3000 AND medicine.duration_of_standard_treatment_course <= 7;