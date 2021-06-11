/*
Практическая №6
*/

--Вывести наименования товаров, количество которых на складе максимально (на
--складе должно быть как минимум два товара, количество которых одинаково и
--равно максимальному).
Select Name
From dbo.Product
Where ID IN (Select ID_Product
             From dbo.Store
			 Where Quantity = (Select max(Quantity) 
			                   From dbo.Store));
			 
--Вывести в порядке, обратном алфавитному, наименования товаров, количество
--которых на складе находится в заданном диапазоне.
Select Name
From dbo.Product
Where ID IN (Select ID_Product
             From dbo.Store
			 Where Quantity Between 1 and 20) 
Order by Name
Desc;

--Вывести поставщиков, которые хотя бы раз осуществили поставку, в алфавитном порядке.
Select Name
From dbo.Provider
Where ID IN (Select ID_Provider
             From dbo.Store)
Order by Name
Asc;

--30 дней с даты последней покупки действует дополнительная скидка на все товары.
--Вывести список покупателей, имеющих возможность воспользоваться указанной
--скидкой.
Select *
From dbo.Client
Where ID in (Select ID_Client
             From dbo.Deal
			 Where Datee >= Dateadd(day, -30, Getdate()));

--Вывести список товаров, названия которых начинающиеся с букв «Д» и «Л»,
--стоимость которых не более 20% от максимальной.
Select *
From dbo.Product
Where Name Like '[Д,Л]%'
  And ID IN (Select ID_Product
             From dbo.Store
			 Where Price < ( (Select max(price)
			                  From dbo.Store) * 0.2) );

--Вывести поставщиков, которые не поставляют товары, названия которых
--начинающиеся с букв «Д» и «Л».
Select Name
From dbo.Provider
Where ID NOT IN (Select ID_Provider
                 From dbo.Store
				 Where ID_Product IN (Select ID
				                      From dbo.Product
									  Where Name Like '[Д,Л]%') );

--Показать список клиентов с указанием их пола («мужчина» или «женщина»).
Select ID, Name, Phone, Address,
Case
    When Sex = 'M'
	  Then 'Мужчина'
	When Sex = 'F'
	  Then 'Женщина'
	  Else 'Пол не указан'
  End As Sex
From dbo.Client;