/*
ПРАКТИЧЕСКАЯ РАБОТА №13
ТРИГГЕРЫ

Задание:
Создать указанные ниже триггеры для соответствующих таблиц.
*/

-- Удаляем триггеры, если они уже существуют.
IF OBJECT_ID('Trigger_Delete', 'Trigger') IS NOT NULL
    DROP TRIGGER Trigger_Delete;
IF OBJECT_ID('Trigger_Update', 'Trigger') IS NOT NULL
    DROP TRIGGER Trigger_Update;
IF OBJECT_ID('Trigger_Add', 'Trigger') IS NOT NULL
    DROP TRIGGER Trigger_Add;

Go
/*
Триггер на удаление:
При удалении некоторой дисциплины, триггер не дает удалить дисциплины, по
которым хотя бы один человек получил экзамен (зачет).
*/
Create Trigger Trigger_Delete on Дисциплины instead of DELETE
	As
		If(Select Count(Изучение.ID_Дисциплины)
		   From Изучение
		   Where Изучение.ID_Дисциплины in (Select ID From deleted)) <> 0
		Begin
			-- Откат.
			RollBack Transaction
			Print 'Эту дисциплину удалить нельзя! :('
		End;

Go
DELETE From dbo.Дисциплины
	Where Дисциплины.ID = 3;

Go
/*
Триггер на обновление:
Назначить нового старосту в некоторую группу. Если назначаемый на должность
старосты студент не состоит в этой группе, следует отменить транзакцию.
*/
Create Trigger Trigger_Update on Группы For UPDATE
	As Begin
		If(Select inserted.Староста From inserted) not in
		  (Select Студенты.[Номер зачётной книжки]
		   From Студенты
		   Where Студенты.ID_Группы in (Select inserted.id From inserted))
		Begin
			Rollback Transaction
			Print 'Студент не состоит в данной группе! :('
		End
		End;

Go
-- Например, пытаемся назначить студента из группы КИ19-06Б на
-- должность старосты группы КИ19-09Б.
Update Группы
	Set Староста = 653490642
	Where Группы.ID = 4;

Go
/*
Триггер на добавление:
Не позволить добавить информацию о сданном экзамене (или зачете), если
дисциплина не соответствует специальности студента.
*/
Create Trigger Trigger_Add on Изучение For INSERT
	As Begin
		Declare @record_book Int
		Select @record_book = (Select [Номер зачетной книжки студента] From inserted)
		If(Select Специальность
		   From Дисциплины Join inserted on inserted.ID_Дисциплины = Дисциплины.ID) =
		  (Select Группы.[ID Специальности]
		   From Группы
		   Where Группы.ID = (Select Студенты.ID_Группы
								From Студенты
									Join inserted on inserted.[Номер зачетной книжки студента] = Студенты.[Номер зачётной книжки]))
		Begin
			Rollback Transaction
			Print 'Данному студенту нельзя добавить данную дисциплину! :('
		End
	End;

-- Например, зачёт по истории.
Go
Insert Изучение
	Values(612345678, 2, '2020-01-15', 'Хорошо');
Go