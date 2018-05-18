# База данных по студентам имеет следующие таблицы:
#
# Группы: id группы, краткое название группы (ПС-21),  id старосты, краткое название специальности (ПС, ВМ, ИВТ).
# Студенты: id студента, фамилия, id группы, год рождения.
# Предметы: id предмета, название, количество учебных часов.
# Преподаватели: id преподавателя, фамилия, должность.
# Занятия: id занятия, id преподавателя, id предмета, id группы дата.
# Оценки: id оценки, номер студента, номер занятия, оценка.

-- 1)	Перенести описание БД в СУБД с проставлением индексов и внешних ключей.

-- group(Группы)
DROP TABLE IF EXISTS `group`;
CREATE TABLE IF NOT EXISTS `group` (
  `id_group` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `short_name` VARCHAR(10) NOT NULL,
  `id_monitor` INT(11) UNSIGNED  NOT NULL,          -- TINYINT UNSIGNED DEFAULT NULL,
  `short_name_of_speciality` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`id_group`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


-- student(Студенты)
DROP TABLE IF EXISTS `student`;
CREATE TABLE IF NOT EXISTS `student` (
  `id_student` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `surname` VARCHAR(100) NOT NULL,
  `id_group` INT(11) UNSIGNED NOT NULL,
  `birth_year` YEAR NOT NULL,
  PRIMARY KEY (`id_student`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


-- subject(Предметы)
DROP TABLE IF EXISTS `subject`;
CREATE TABLE IF NOT EXISTS `subject` (
  `id_subject` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `number_of_study_hours` FLOAT UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id_subject`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


-- teacher(Преподаватели)
DROP TABLE IF EXISTS `teacher`;
CREATE TABLE IF NOT EXISTS `teacher` (
  `id_teacher` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `surname` VARCHAR(100) NOT NULL,
  `position` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id_teacher`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


-- lesson(Занятия)
DROP TABLE IF EXISTS `lesson`;
CREATE TABLE IF NOT EXISTS `lesson` (
  `id_lesson` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_teacher` INT(11) UNSIGNED NOT NULL,
  `id_subject` INT(11) UNSIGNED NOT NULL,
  `id_group` INT(11) UNSIGNED NOT NULL,
  `date` DATETIME DEFAULT NULL,
  PRIMARY KEY (`id_lesson`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


-- grade(Оценки)
DROP TABLE IF EXISTS `grade`;
CREATE TABLE IF NOT EXISTS `grade` (
  `id_grade` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_student` INT(11) UNSIGNED NOT NULL,
  `id_lesson` INT(11) UNSIGNED NOT NULL,
  `mark` INT(11) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id_grade`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


-- 2)	Выдать оценки студентов по математике если они обучаются/обучались данному предмету.
-- Оформить выдачу данных с использованием view.
CREATE VIEW math_marks AS
    SELECT student.surname, grade.mark
    FROM `grade`
      LEFT JOIN `lesson` ON grade.id_lesson = lesson.id_lesson
      LEFT JOIN `student` ON grade.id_student = student.id_student
    WHERE lesson.id_subject = 10;

SELECT * FROM math_marks;


-- 3)	Дать информацию о должниках с указанием фамилии студента и названия предмета.
-- Должниками считаются студенты, не имеющие оценки по предмету, который ведется в группе.
-- Оформить в виде процедуры, на вход название группы.
DROP PROCEDURE IF EXISTS  showDebtors;
DELIMITER //
CREATE PROCEDURE showDebtors (IN groupName VARCHAR(100))
  BEGIN
    DROP TABLE IF EXISTS `group_debtor`;
    CREATE TEMPORARY TABLE `group_debtor` AS (
      SELECT
        student.id_student AS id_student,
        student.surname as st_surname,
        subject.name AS sb_name,
        lesson.id_lesson AS id_lesson
      FROM `lesson`
        LEFT JOIN `subject` ON subject.id_subject = lesson.id_subject
        LEFT JOIN `group` ON `group`.id_group = lesson.id_group
        LEFT JOIN `student` ON `group`.id_group = student.id_group
      WHERE
        `group`.short_name = groupName
    );

    SELECT DISTINCT
      group_debtor.st_surname,
      group_debtor.sb_name
    FROM `group_debtor`
      LEFT JOIN `grade` ON grade.id_student = group_debtor.id_student AND grade.id_lesson = group_debtor.id_lesson
    GROUP BY group_debtor.st_surname, group_debtor.sb_name
      HAVING COUNT(grade.mark) = 0;
    DROP TABLE IF EXISTS `group_debtor`;
  END //
DELIMITER ;

CALL showDebtors('ИВТ-21');
CALL showDebtors('ВМ-22');




-- 4)	Дать среднюю оценку студентов по каждому предмету для тех предметов,
-- по которым занимается не менее 10 студентов.
DROP TABLE IF EXISTS `#avg_students_mark`;
CREATE TEMPORARY TABLE IF NOT EXISTS `#avg_students_mark` AS (
  SELECT
    lesson.id_subject       AS id_sub,
    COUNT(grade.id_student) AS student_amount,
    AVG(grade.mark)         AS avg_mark
  FROM `lesson`
    LEFT JOIN `subject` ON subject.id_subject = lesson.id_subject
    LEFT JOIN `grade` ON grade.id_lesson = lesson.id_lesson
  GROUP BY lesson.id_subject
  HAVING student_amount >= 6
);

SELECT `#avg_students_mark`.id_sub, subject.name AS name_sub, `#avg_students_mark`.avg_mark
FROM `#avg_students_mark`
  LEFT JOIN `subject` ON subject.id_subject = `#avg_students_mark`.id_sub;

DROP TABLE `#avg_students_mark`;

-- 5)	Дать оценки студентов специальности ВМ по всем проводимым предметам с указанием группы,
-- фамилии, предмета, даты. При отсутствии оценки заполнить значениями NULL поля оценки и даты.
DROP TABLE IF EXISTS `avg_students_mark`;
CREATE TEMPORARY TABLE IF NOT EXISTS `avg_students_mark` AS (
  SELECT
    student.id_student AS id_student,
    student.surname AS student_name,
    `group`.short_name AS group_name,
    `subject`.name AS subject_name,
    lesson.date AS lesson_date
  FROM `lesson`
    LEFT JOIN `subject` ON subject.id_subject = lesson.id_subject
    LEFT JOIN `group` ON `group`.id_group = lesson.id_group
    LEFT JOIN `student` ON student.id_group = `group`.id_group
  WHERE `group`.short_name_of_speciality = 'ВМ'
);

SELECT `avg_students_mark`.student_name, `avg_students_mark`.group_name, `avg_students_mark`.subject_name, `avg_students_mark`.lesson_date, grade.mark
FROM `grade`
  RIGHT JOIN `avg_students_mark` ON `avg_students_mark`.id_student = grade.id_student;

DROP TABLE `avg_students_mark`;

-- 6)	Всем студентам специальности ИВТ, получившим оценки меньшие 5 по предмету БД до 12.05,
-- повысить эти оценки на 1 балл.
UPDATE `grade`
  LEFT JOIN `lesson` ON lesson.id_lesson = grade.id_lesson
  LEFT JOIN `group` ON `group`.id_group = lesson.id_group
  LEFT JOIN `student` ON student.id_group = `group`.id_group
SET grade.mark = grade.mark + 1
WHERE `group`.short_name_of_speciality = 'ИВТ'
      AND lesson.id_subject = 1
      AND lesson.date < '2017-05-12'
      AND grade.mark < 5;