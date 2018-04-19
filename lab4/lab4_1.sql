-- LEFT JOIN двух таблиц + WHERE по 1 атрибуту
SELECT price, transaction_amount FROM `apartment`
  LEFT JOIN `appeal_x_realtor` ON apartment.id_apartment = appeal_x_realtor.id_apartment
  WHERE apartment.id_apartment > 3;

-- RIGHT JOIN двух таблиц, получить те же записи как в 4.1
SELECT price, transaction_amount FROM `appeal_x_realtor`
  RIGHT JOIN `apartment` ON apartment.id_apartment = appeal_x_realtor.id_apartment
  WHERE apartment.id_apartment > 3;

-- LEFT JOIN двух таблиц + WHERE по 2 атрибутам из 1 таблицы
SELECT price, transaction_amount FROM `apartment`
  LEFT JOIN `appeal_x_realtor` ON apartment.id_apartment = appeal_x_realtor.id_apartment
  WHERE (apartment.id_apartment > 3) AND (apartment.address != 'Йошкар-Ола ул.Ленина');

-- LEFT JOIN двух таблиц + WHERE по 1 атрибуту из каждой таблицы
SELECT price, transaction_amount FROM `apartment`
  LEFT JOIN `appeal_x_realtor` ON apartment.id_apartment = appeal_x_realtor.id_apartment
  WHERE (apartment.id_apartment > 1) AND (appeal_x_realtor.transaction_amount != 100000);

-- LEFT JOIN трех таблиц + WHERE по 1 атрибуту из каждой таблицы
SELECT price, transaction_amount FROM `apartment`
  LEFT JOIN `appeal_x_realtor` ON apartment.id_apartment = appeal_x_realtor.id_apartment
  LEFT JOIN `client` ON client.id_client = appeal_x_realtor.id_client
  WHERE (apartment.id_apartment > 1) AND (appeal_x_realtor.transaction_amount != 100000) AND (client.id_client < 5);
