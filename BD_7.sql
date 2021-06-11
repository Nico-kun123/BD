/*
Практическая №7
*/

-- Показать какой поставщик поставил каждый товар на склад (INNER JOIN).
Select Distinct dbo.Product.Name as [Товар], Provider.Name as [Поставщик]
	From Store 
		Inner Join Provider on Store.ID_Provider = Provider.ID
		inner join Product on Product.ID = Store.ID_Product
	Order by Product.Name;

-- Вывести список товаров, которыми торгует фирма, и их поставщиков вне зависимости от наличия поставок (LEFT JOIN).
Select distinct Product.Name, Provider.Name, Store.Quantity
	From Product 
		left join Store on Product.id = Store.ID_Product
		left join Provider on Store.ID_Provider = Provider.id
	Order by Product.Name;

-- Вывести информацию о покупаемых со склада товарах и их покупателях, включая товары, отсутствующие
-- в списке реализованных товаров (RIGHT JOIN).
Select distinct Product.Name as [Товар],
                isNULL(Client.Name,'Не определён') as [Покупатель],
				isNull(str(Deal.Quantity),'Нет продаж') as [Количество]
	From Deal
		inner join Client on Deal.ID_Client = Client.ID
		right join Store on Store.ID = Deal.ID_Store
		inner join Product on Product.ID = Store.ID_Product;

--Вывести список поставщиков, которые хотя бы раз осуществляли поставку на склад (полусоединение).
Select Distinct Provider.Name as [Поставщик]
	From Store
		Inner Join Provider on Store.ID_Provider = Provider.ID;

-- Выведите список сотрудников с указанием их прямых начальников (самосоединение). 
-- Для главного начальника в столбец «Начальник» вывести «не определен».
Select x1.Name as [Сотрудник], isNull(x2.Name, 'Не определен') as [Начальник]
	From Employee x1
		left join Employee x2 on x2.ID = x1.ID_Manager;