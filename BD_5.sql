/*
Практическая №5
*/

--Сортировать поставщиков в алфавитном (обратном) порядке.
--DESC - по убыванию.
Select Name
From dbo.Provider
Order by Name Desc;

--Поставщик(и) с самым длинным названием.
Select *
From dbo.Provider
Where len(Name) = (Select max(len(Name)) 
                   From dbo.Provider);

--Все покупатели с фамилией, начинающейся на букву «В».
Select Name
From dbo.Client
Where Name Like 'В%';

--Все покупатели с фамилией, начинающейся с букв в диапазоне от "В" до "К", где вторая буква «о».
Select Name
From dbo.Client
Where Name Like '[В-К]о%';

--Количество сделок за текущий календарный месяц.
Select count(*) as Количество_сделок
From dbo.Deal
Where datename(month, Datee) = datename(month, getdate())
  and datename(year, Datee) = datename(year, getdate());

--Количество сделок, зафиксированных в заданные дни недели (например, по пятницам и субботам).
Select Count(*) as Количество_сделок
From dbo.Deal
Where Datepart(weekday, Datee) = 5
   Or Datepart(weekday, Datee) = 6;