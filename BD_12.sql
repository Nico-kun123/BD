/*
ПРАКТИЧЕСКАЯ РАБОТА №12
ПРЕДСТАВЛЕНИЯ

Задание:
Показать в представлении студентов, сдававших сессии на «Отлично». Вывести
Ф.И.О., номер группы и семестр. Группировать по семестрам и группам.
*/

-- Если представления уже существуют, то удаляем их.
If OBJECT_ID(N'BigBrainStudents', 'V') is not NULL
	Drop View BigBrainStudents;
If OBJECT_ID(N'Select_Groups', 'V') is not NULL
	Drop View Select_Groups;
If OBJECT_ID(N'Answer', 'V') is not NULL
	Drop View Answer;
Go

-- Создаём представления.
-- Выбираем группы.
Create View Select_Groups
	As
		Select Группы.Название as [Группа], Count(Дисциплины.ID) as [Кол-во дисциплин]
			From Дисциплины
				Inner Join Группы on Группы.[ID Специальности] = Дисциплины.Специальность
			Group by Группы.Название;

Go
-- Таблица студентов, закрывшие сессию на "Отлично".
Create View BigBrainStudents
	As
		Select Фамилия, Имя, Отчество,
			   Группы.Название as Группа, Семестр, Count(Изучение.Оценка) as [Кол-во сданных дисциплин]
		From Студенты
			Join Группы on Группы.ID = Студенты.[ID_Группы]
			Join Изучение on Студенты.[Номер зачётной книжки] = Изучение.[Номер зачетной книжки студента]
				and Изучение.Оценка in ('Отлично', 'Зачёт')
			Join Дисциплины on Изучение.ID_Дисциплины = Дисциплины.ID
		Group by Фамилия, Имя, Отчество, Группы.Название, Семестр;

Go
Create View Answer
	As
		Select BigBrainStudents.Фамилия, BigBrainStudents.Имя, BigBrainStudents.Отчество,
			   BigBrainStudents.Группа, BigBrainStudents.Семестр
		From BigBrainStudents
			Inner Join Select_Groups on Select_Groups.Группа = BigBrainStudents.Группа
		Where BigBrainStudents.[Кол-во сданных дисциплин] = Select_Groups.[Кол-во дисциплин];
Go

-- Выводим представление на экран.
Select *
	From Answer
Go