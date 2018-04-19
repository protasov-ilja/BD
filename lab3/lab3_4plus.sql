SELECT * FROM `appeal_x_realtor`
ORDER BY transaction_amount ASC, appeal_date DESC;

--1
--a.	ASC
SELECT * FROM `apartment`
  ORDER BY price;

--b.	DESC
SELECT * FROM `apartment`
  ORDER BY price DESC;

--c.	по двум атрибутам
SELECT * FROM `appeal_x_realtor`
  ORDER BY transaction_amount, appeal_date DESC;

--d.	по первому атрибуту, из списка извлекаемых
SELECT price, address FROM `apartment`
  ORDER BY 1;

--2
--a.	4.1 MIN
SELECT MIN(price) FROM `apartment`
  WHERE id_apartment < 5;

--b.	4.2 MAX
SELECT MAX(price) FROM `apartment`
  WHERE id_apartment > 1;

--c.	4.3 AVG
SELECT AVG(price) FROM `apartment`
  WHERE id_apartment BETWEEN 1 AND 6;

--d.	4.4 SUM
SELECT SUM(price) FROM `apartment`
  WHERE id_apartment BETWEEN 1 AND 6;

--3
--a.	функция агрегации(обьединения) GROUP BY
-- Производим выборку данных
-- и возвращаемого значения агрегированной функции SUM по столбцу price,
-- таблицы apartment, где значения ячеек столбца address
-- равняется одному из значений ряда ('Йошкар-Ола ул.Ленина', 'Йошкар-Ола, ул.Свердловская'),
-- при этом производится группировка по значениям столбца address.
-- выводится по отдельности общая сумма price в строках, где address = 'Йошкар-Ола ул.Ленина', 'Йошкар-Ола, ул.Свердловская'
SELECT address, SUM(price) FROM `apartment`
WHERE address IN ('Йошкар-Ола ул.Ленина', 'Йошкар-Ола, ул.Свердловская')
GROUP BY address;

--b.	функция агрегации(обьединения) GROUP BY HAVING
-- Производим выборку данных
-- и возвращаемого значения агрегированной функции SUM по столбцу price,
-- таблицы apartment, где значения ячеек столбца address
-- равняется одному из значений ряда ('Йошкар-Ола ул.Ленина', 'Йошкар-Ола, ул.Свердловская'),
-- при этом производится группировка по значениям столбца address.
-- далее осуществляяем фильтровку значений по price_sum, где price_sum < 100000
SELECT address, SUM(price) AS price_sum FROM `apartment`
  WHERE address IN ('Йошкар-Ола ул.Ленина')
  GROUP BY address
  HAVING price_sum < 100000;


