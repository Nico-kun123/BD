/*
Практическая №8, часть 1

Провести оценку количества товара на складе по наименованиям: менее 10 – мало,
от 10 до 100 – достаточно, более 100 – избыточно.
*/
Select Product.Name as [Наименование], sum(Store.Quantity) as [Количество],
	Case
		When sum(Store.Quantity) = 0
			Then 'Отсутствует'
		When sum(Store.Quantity) < 10
			Then 'Мало'
		When sum(Store.Quantity) between 10 and 100
			Then 'Достаточно'
			Else 'Избыточно'
	End as [Оценка]
			
	From Product
		inner join Store on Store.ID_Product = Product.ID
	Group by Product.Name;

-- Вывести наименования товаров, количество которых на складе от 1 до 10.
Select Product.Name as [Наименование], sum(Store.Quantity) as [Количество]
	From Product
		Left join Store on Store.ID_Product = Product.ID
	Group by Product.Name
	Having sum(Store.Quantity) between 1 and 10
	Order by sum(Store.Quantity)
	Desc;

-- Определить тройку товаров, выручка за которые самая большая.
Select TOP(3) Product.Name as [Наименование], sum(Store.Price * Deal.Quantity * (1 - (Deal.Discount+0.0)/100.0) ) as [Сумма]
	From Product
		inner join Store on Store.ID_Product = Product.ID
		inner join Deal on Store.ID = Deal.ID_Store

	Group by Product.Name
	Order by sum(Store.Price * Deal.Quantity * (1 - (Deal.Discount+0.0)/100.0) )
	Desc;

-- Определить суммарную стоимость продаж каждого товара по месяцам.
Select Product.Name as [Наименование],
	   datepart(year, Deal.Datee) as [Год],
	   datename(month, Deal.Datee) as [Месяц],
	   sum( Store.Price * Deal.Quantity * (1 - (Deal.Discount+0.0)/100.0) ) as [Сумма]

	From Product
		inner join Store on Store.ID_Product = Product.ID
		inner join Deal on Store.ID = Deal.ID_Store
	Group by Product.Name, datename(month, Deal.Datee), datepart(year, Deal.Datee)
	Order by sum( Store.Price * Deal.Quantity * (1 - (Deal.Discount+0.0)/100.0) );

/*
Показать месяца, в которых продажи Молока (или любого другого товара,
хранящегося на складе с разны	ми ID) были ниже 300 денег.
*/
Select Product.Name as [Наименование],
	   datepart(year, Deal.Datee) as [Год],
	   datename(month, Deal.Datee) as [Месяц],
	   sum( Store.Price * Deal.Quantity * (1 - (Deal.Discount+0.0)/100.0) ) as [Сумма]

	From Product
		inner join Store on Store.ID_Product = Product.ID
		inner join Deal on Store.ID = Deal.ID_Store

	Where Product.Name = 'Молоко'
		
	Group by Product.Name, Deal.Datee -- "Ну, допустим"
	Having sum( Store.Price * Deal.Quantity * (1 - (Deal.Discount+0.0)/100.0) ) <= 300
	Order by Deal.Datee;