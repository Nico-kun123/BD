-- ИТОГОВАЯ РАБОТА.
-- (Всякие там запросы)

use Bus_stop
Go

-- 1) Получить данные (время, цену на билет) о рейсах в город Томск из города Новосибирск.
-- ID Томска = 5, ID Новосибирска = 3.
Select [Время отбытия], [Время прибытия], Стоимость
From Маршруты
Where [ID_Города A] = (Select ID from Города Where Название = 'Новосибирск') and
      [ID_Города B] = (Select ID from Города Where Название = 'Томск');

---------------------------------------------------------------------------------------------------------------------------------
-- 2) Получить суммарный доход какой-либо кассы.
Select sum(Маршруты.Стоимость) as [Суммарный доход]
From Билеты
	inner join Поездки on Билеты.[ID Поездки] = Поездки.ID
	inner join Маршруты on Поездки.ID = Маршруты.ID
Where [ID Кассы] = 3;

---------------------------------------------------------------------------------------------------------------------------------
-- 3) Получить суммарные доходы касс в городе Томске.
Select sum(Маршруты.Стоимость) as [Суммарный доход в городе]
From Города
	inner join Кассы on Кассы.[ID Города] = Города.ID
	inner join Билеты on Билеты.[ID Кассы] = Кассы.ID
	inner join Поездки on Билеты.[ID Поездки] = Поездки.ID
	inner join Маршруты on Поездки.ID = Маршруты.ID
Where Города.Название = 'Томск';

---------------------------------------------------------------------------------------------------------------------------------
-- 4) Получить число рейсов, совершенных данным водителем за год.
Select Count(*) as [Кол-во рейсов за год]
From Поездки
	Where Поездки.[ID Водителя] = 1 and
		  DATEADD(month, -6, GETDATE()) < Поездки.[Дата прибытия];

---------------------------------------------------------------------------------------------------------------------------------
-- 5) Назначить водителя на рейс.
IF OBJECT_ID('Trigger_SetDriver', 'Trigger') IS NOT NULL
    DROP TRIGGER Trigger_SetDriver;

go
Create Trigger Trigger_SetDriver on Поездки For Update
	As Begin
		IF(Select Водители.[ID Города]
		   From Водители
		   Where ID = (Select inserted.[ID Водителя] From inserted)) <>
					  (Select [ID_Города A]
					   From Маршруты
					       Join Поездки on Поездки.[ID Маршрута] = Маршруты.ID
					   Where Поездки.[ID Водителя] = (Select inserted.[ID Водителя] From inserted)) 
		Begin
			Rollback Transaction
			Print 'Водитель не проживает в этом городе отправления! :('
	End
	End;
go

Update Поездки
	Set [ID Водителя] = 20
	Where Поездки.ID = 2;

---------------------------------------------------------------------------------------------------------------------------------
-- 6) Оформить билет для клиента в город Новосибирск из Томска, с учётом занятых мест в автобусе.
IF OBJECT_ID('Check_Places') IS NOT NULL
	DROP FUNCTION Check_Places;
go

CREATE FUNCTION Check_Places (@ID_Trip int)
	RETURNS int
	BEGIN
		DECLARE @Count int = 1;
	WHILE (@Count <= (SELECT [Количество Мест] FROM Автобусы
							WHERE ID = (SELECT [ID Автобуса] FROM Поездки WHERE ID = @ID_Trip)))
	BEGIN
		IF (@Count NOT IN (SELECT Место FROM Билеты WHERE [ID Поездки] = @ID_Trip))	
			Break;
			else set @count=@count+1
	END
		RETURN (@Count)
		End;
go

declare @place int = 0;
set @place=(select dbo.Check_Places(1))

Insert Билеты
	Values(2, 1, @place, '21-02-02', 3);

---------------------------------------------------------------------------------------------------------------------------------
-- 7) Получить число рейсов, совершённых автобусами «шКольнЫй» и «Мерседес»
Select Count(*) as [Кол-во рейсов]
From Поездки
Where [ID Автобуса] in (Select ID From Автобусы Where Марка in ('шКольнЫй', 'Мерседес'));

---------------------------------------------------------------------------------------------------------------------------------
-- 8) Проверить все свободные места на рейс.
IF OBJECT_ID('Check_EmptyPlaces') is NOT NULL
	DROP PROCEDURE Check_EmptyPlaces;
go

CREATE PROCEDURE Check_EmptyPlaces (@ID_trip int) AS
BEGIN
	DECLARE @Count int = 1;
	WHILE (@Count <= (SELECT [Количество Мест] FROM Автобусы
							WHERE ID = (SELECT [ID Автобуса] FROM Поездки WHERE ID = @ID_trip)))
	BEGIN
		IF (@Count NOT IN (SELECT Место FROM Билеты WHERE [ID Поездки] = @ID_Trip))
			Print(@Count)
		SET @Count = @Count + 1;
	END		
END

Go
Exec Check_EmptyPlaces 3;

---------------------------------------------------------------------------------------------------------------------------------
-- 9) Показать число билетов, проданных кассами.
Select Count(Билеты.[ID Кассы]) as [Количество билетов], Кассы.Адрес
From Кассы
	Left join Билеты on Кассы.ID = Билеты.[ID Кассы]
Group by Кассы.ID, Кассы.Адрес;

---------------------------------------------------------------------------------------------------------------------------------
-- 10) Показать среднюю цену билетов.
Go
IF OBJECT_ID('Avg_Cost') IS NOT NULL
	DROP FUNCTION Avg_Cost;
Go

CREATE FUNCTION Avg_Cost()
	RETURNS float
	BEGIN
		DECLARE @answer float
		Set @answer = (Select Sum(Стоимость) From Маршруты)/(Select Count(*) From Маршруты)
	RETURN (@answer)
	End;

Go
Select dbo.Avg_Cost() as [Средняя цена];

---------------------------------------------------------------------------------------------------------------------------------
-- 11) Показать рейсы, цена на которые выше средней цены на билеты.
Select *
From Маршруты
Where Стоимость > dbo.Avg_Cost();

---------------------------------------------------------------------------------------------------------------------------------
-- 12) Отменить клиенту билет, после того как он его вернул.
DELETE From Билеты
	Where ID = 4;

---------------------------------------------------------------------------------------------------------------------------------
-- 13) Показать информацию о рейсах из города Томск (включая цену на билет, время рейса).
Select *
From Маршруты
Where [ID_Города A] = (Select ID
					   From Города
					   Where Название = 'Томск') 

---------------------------------------------------------------------------------------------------------------------------------
-- 14) Посчитать количество билетов, проданных по рейсам Томск – Новосибирск за 2014-2015.
Select count(*) as [Кол-во билетов]
From Билеты
	inner join Маршруты on Маршруты.ID = [ID Поездки]
Where YEAR([Дата покупки]) in ('2014', '2015') and
	  Маршруты.[ID_Города A] = (Select ID From Города Where Название = 'Томск') and
	  Маршруты.[ID_Города B] = (Select ID From Города Where Название = 'Новосибирск');
	  
---------------------------------------------------------------------------------------------------------------------------------
-- 15) Назначить автобус на рейс.
Go
IF OBJECT_ID('Set_Bus') is not NULL
	DROP PROCEDURE Set_Bus;
Go

CREATE PROCEDURE Set_Bus @IdBud int, @IdTrip int AS
BEGIN
	IF(SELECT [Количество Мест]
	   FROM Автобусы
	   WHERE ID = @IdBud) > (SELECT [Мин_Кол-во мест]
							 FROM Маршруты
							 WHERE ID = (SELECT [ID Маршрута]
										 FROM Поездки 
										 WHERE ID = @IdTrip))
	BEGIN
		UPDATE Поездки
			SET [ID Автобуса] = @IdBud
			WHERE ID = @IdTrip;
	END
END
Go

Exec Set_Bus 5, 1;

GO
---------------------------------------------------------------------------------------------------------------------------------
-- 16) Получить список рейсов, на которые может быть назначен данный водитель и данный автобус с числом мест, равным 30.
IF OBJECT_ID('GetTrip') is not NULL
	DROP VIEW GetTrip;
GO
IF OBJECT_ID('JOINTRIPANDROUTE') is not NULL
	DROP VIEW JOINTRIPANDROUTE;
GO

CREATE VIEW JOINTRIPANDROUTE AS
	SELECT Поездки.ID, Маршруты.[ID_Города A], Маршруты.[ID_Города B], Маршруты.[Мин_Кол-во мест]
	FROM Поездки 
		 JOIN Маршруты ON Маршруты.ID = Поездки.[ID Маршрута]
GO
CREATE VIEW GetTrip AS
	Select ID as [ID поездки], [ID_Города A] as [Пункт отправления], [ID_Города B] as [Пункт прибытия] 
	From JOINTRIPANDROUTE 
		Where [ID_Города A] = (Select [ID Города] From Водители Where ID=5) and
		[Мин_Кол-во мест] <= (Select [Количество Мест] From Автобусы Where ID=5)
GO

Select *
From GetTrip;

---------------------------------------------------------------------------------------------------------------------------------
-- 17) После ремонта в автобусе добавили 3 места, добавить эти места и в БД.
Go
UPDATE Автобусы
	Set [Количество Мест] = [Количество Мест] + 3
	Where ID=3;