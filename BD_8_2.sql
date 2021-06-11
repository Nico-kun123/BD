/*
Практическая №8, часть 2

Используя оконные функции (и группировку), создайте следующие запросы:
*/

-- Ранжируйте сотрудников по объемам продаж и выведите тройку лидеров.
Select Top(3) Employee.Name as [Сотрудник], sum( Store.Price * Deal.Quantity * (1 - (Deal.Discount+0.0)/100.0) ) as [Сумма],
	   Rank() Over(Order by sum( Store.Price * Deal.Quantity * (1 - (Deal.Discount+0.0)/100.0) ) desc) as [Занятое место]
	
	From Deal
		inner join Employee on Deal.ID_Employee = Employee.ID
		inner join Store on Deal.ID_Store = Store.ID
	Group by Employee.Name;

/*
Вывести суммы сделок по месяцам для каждого сотрудника и показать разницу с
предыдущим месяцем, в котором были зафиксированы сделки.
*/
Select Employee.Name as [Сотрудник],
	   datepart(year, Deal.Datee) as [Год],
	   datepart(month, Deal.Datee) as [Месяц],
       sum( Store.Price*Deal.Quantity*(1 - (Deal.Discount+0.0)/100.0) ) as [Сумма сделок],
	   sum( Store.Price*Deal.Quantity*(1 - (Deal.Discount+0.0)/100.0) )-lag(sum(Store.Price*Deal.Quantity*(1 - (Deal.Discount+0.0)/100.0)), 1,0)
		over( partition by Employee.Name order by Employee.Name, datepart(year, Deal.Datee), datepart(month, Deal.Datee) ) as [Разница с предыдущим месяцем]

	From Deal
		inner join Employee on Deal.ID_Employee = Employee.ID
		inner join Store on Deal.ID_Store = Store.ID
	Group by Employee.Name, datepart(year, Deal.Datee), datepart(month, Deal.Datee);