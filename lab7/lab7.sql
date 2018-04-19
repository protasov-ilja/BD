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


-- 2)	Выдать оценки студентов по математике если они обучаются/обучались данному предмету. Оформить выдачу данных с использованием view.
-- 3)	Дать информацию о должниках с указанием фамилии студента и названия предмета.
-- Должниками считаются студенты, не имеющие оценки по предмету, который ведется в группе. Оформить в виде процедуры, на вход название группы.
-- 4)	Дать среднюю оценку студентов по каждому предмету для тех предметов, по которым занимается не менее 10 студентов.
-- 5)	Дать оценки студентов специальности ВМ по всем проводимым предметам с указанием группы, фамилии, предмета, даты. При отсутствии оценки заполнить значениями NULL поля оценки и даты.
-- 6)	Всем студентам специальности ИВТ, получившим оценки меньшие 5 по предмету БД до 12.05, повысить эти оценки на 1 балл.