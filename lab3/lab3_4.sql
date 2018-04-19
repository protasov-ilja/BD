-- 1.
INSERT INTO client
VALUES
  (6, 'Иванов Петр Петрович');

INSERT INTO apartment
  (address, price)
VALUES
  ('Йошкар-Ола, ул.Свердловская', 100000);

INSERT INTO client
  (id_client)
SELECT id_client FROM appeal_x_realtor;

-- 2
DELETE * FROM client;

DELETE * FROM client
WHERE id_client < 2;

TRUNCATE TABLE client;

-- 3
UPDATE client
SET client_name = 'Грозный Иван Васильевич';

UPDATE client
SET client_name = 'Петров Василий Васильевич'
WHERE id_client = 3;

UPDATE apartment
SET address = 'Йошкар-Ола ул.Суворова', price = '2000'
WHERE id_apartment = 1;

-- 4
SELECT id_client, client_name FROM client;

SELECT * FROM client;

SELECT * FROM client
WHERE client_name = 'Грозный Иван Васильевич';