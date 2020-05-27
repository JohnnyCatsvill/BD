/*1.Добавить внешние ключи.*/

ALTER TABLE student
	ADD FOREIGN KEY (id_group) REFERENCES "group"(id_group) ON DELETE CASCADE;

ALTER TABLE mark
	ADD FOREIGN KEY (id_student) REFERENCES student(id_student) ON DELETE CASCADE;

ALTER TABLE mark
	ADD FOREIGN KEY (id_lesson) REFERENCES lesson(id_lesson) ON DELETE CASCADE;

ALTER TABLE lesson
	ADD FOREIGN KEY (id_teacher) REFERENCES teacher(id_teacher) ON DELETE CASCADE;

ALTER TABLE lesson
	ADD FOREIGN KEY (id_subject) REFERENCES "subject"(id_subject) ON DELETE CASCADE;

ALTER TABLE lesson
	ADD FOREIGN KEY (id_group) REFERENCES "group"(id_group) ON DELETE NO ACTION;

/*2.Выдать оценки студентов по информатике если они обучаются данному предмету. Оформить выдачу данных с использованием view.*/

USE University;

GO
CREATE VIEW "computer_science_grades" 
AS
SELECT
	student.name AS name, lesson.id_lesson AS lesson, mark.mark AS mark
FROM
	student
	CROSS JOIN lesson
	LEFT JOIN mark ON lesson.id_lesson = mark.id_lesson AND student.id_student = mark.id_student
	LEFT JOIN "subject" ON lesson.id_subject = "subject".id_subject
WHERE
	student.id_group = lesson.id_group and
	"subject".name = 'Информатика'

GO

/*3.Дать информацию о должниках с указанием фамилии студента и названия предмета. 
Должниками считаются студенты, не имеющие оценки по предмету, который ведется в группе. 
Оформить в виде процедуры, на входе идентификатор группы.*/

USE University
GO
CREATE PROCEDURE Students_Deptors
(
	@group_id INT
)
AS
BEGIN
	SELECT
		student.name, "subject".name, lesson.id_lesson, mark.mark
	FROM
		student
		CROSS JOIN lesson
		LEFT JOIN mark ON lesson.id_lesson = mark.id_lesson AND student.id_student = mark.id_student
		LEFT JOIN "group" ON "group".id_group = student.id_group
		LEFT JOIN "subject" ON lesson.id_subject = "subject".id_subject
	WHERE
		student.id_group = lesson.id_group and
		"group".id_group = @group_id and
		mark.mark IS NULL
	
	ORDER BY student.name
END;

EXECUTE Students_Deptors @group_id = 1

/*4.Дать среднюю оценку студентов по каждому предмету для тех предметов, по которым занимается не менее 35 студентов.*/

SELECT
	AVG(CAST(mark as Float)) AS 'AVG(mark)', "subject".id_subject
FROM
	student
	CROSS JOIN lesson
	LEFT JOIN mark ON lesson.id_lesson = mark.id_lesson AND student.id_student = mark.id_student
	LEFT JOIN "group" ON "group".id_group = student.id_group
	LEFT JOIN "subject" ON lesson.id_subject = "subject".id_subject
	LEFT JOIN
	(
		SELECT 
			"subject".id_subject
		FROM
			student
			CROSS JOIN "subject"
			LEFT JOIN 
			(
				SELECT 
					DISTINCT lesson.id_group, lesson.id_subject
				FROM 
					lesson
			) AS Group_Subjects ON Group_Subjects.id_group = student.id_group AND Group_Subjects.id_subject = "subject".id_subject
		WHERE
			Group_Subjects.id_group IS NOT NULL
		GROUP BY
			"subject".id_subject
		HAVING 
			COUNT("subject".id_subject) >= 35
	) AS Subject_35Plus ON subject.id_subject = Subject_35Plus.id_subject
WHERE
	student.id_group = lesson.id_group and
	Subject_35Plus.id_subject IS NOT NULL
GROUP BY
	"subject".id_subject


/*5.Дать оценки студентов специальности ВМ по всем проводимым предметам с указанием группы, фамилии, предмета, даты. 
При отсутствии оценки заполнить значениями NULL поля оценки .*/

SELECT
	"group".name, student.name, "subject".name, lesson.id_lesson AS lesson, mark.mark AS mark
FROM
	student
	CROSS JOIN lesson
	LEFT JOIN mark ON lesson.id_lesson = mark.id_lesson AND student.id_student = mark.id_student
	LEFT JOIN "group" ON "group".id_group = student.id_group
	LEFT JOIN "subject" ON lesson.id_subject = "subject".id_subject
WHERE
	student.id_group = lesson.id_group and
	"group".name = 'ВМ'

ORDER BY student.name

/*6. Всем студентам специальности ПС , получившим оценки меньшие 5 по предмету БД до 12.05, повысить эти оценки на 1 балл.*/

UPDATE
	mark
SET
	mark.mark = mark.mark + 1
WHERE mark.id_mark IN 
(
	SELECT
		id_mark
	FROM
		student
		CROSS JOIN lesson
		LEFT JOIN mark ON lesson.id_lesson = mark.id_lesson AND student.id_student = mark.id_student
		LEFT JOIN "group" ON "group".id_group = student.id_group
		LEFT JOIN "subject" ON lesson.id_subject = "subject".id_subject
	WHERE 
		student.id_student = mark.id_student and
		"group".name = 'ПС' and
		"subject".name = 'БД' and
		lesson.date <= '2019-05-12' and
		mark.mark < 5 and
		mark.mark IS NOT NULL
)

/*7. Добавить необходимые индексы.*/

CREATE INDEX IX_mark_id_lesson
ON mark(id_lesson ASC);

CREATE INDEX IX_mark_id_student
ON mark(id_student ASC);

CREATE INDEX IX_student_id_group
ON student(id_group ASC);

CREATE INDEX IX_lesson_id_subject
ON lesson(id_subject ASC);