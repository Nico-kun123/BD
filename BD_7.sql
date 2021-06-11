/*
������������ �7
*/

-- �������� ����� ��������� �������� ������ ����� �� ����� (INNER JOIN).
Select Distinct dbo.Product.Name as [�����], Provider.Name as [���������]
	From Store 
		Inner Join Provider on Store.ID_Provider = Provider.ID
		inner join Product on Product.ID = Store.ID_Product
	Order by Product.Name;

-- ������� ������ �������, �������� ������� �����, � �� ����������� ��� ����������� �� ������� �������� (LEFT JOIN).
Select distinct Product.Name, Provider.Name, Store.Quantity
	From Product 
		left join Store on Product.id = Store.ID_Product
		left join Provider on Store.ID_Provider = Provider.id
	Order by Product.Name;

-- ������� ���������� � ���������� �� ������ ������� � �� �����������, ������� ������, �������������
-- � ������ ������������� ������� (RIGHT JOIN).
Select distinct Product.Name as [�����],
                isNULL(Client.Name,'�� ��������') as [����������],
				isNull(str(Deal.Quantity),'��� ������') as [����������]
	From Deal
		inner join Client on Deal.ID_Client = Client.ID
		right join Store on Store.ID = Deal.ID_Store
		inner join Product on Product.ID = Store.ID_Product;

--������� ������ �����������, ������� ���� �� ��� ������������ �������� �� ����� (��������������).
Select Distinct Provider.Name as [���������]
	From Store
		Inner Join Provider on Store.ID_Provider = Provider.ID;

-- �������� ������ ����������� � ��������� �� ������ ����������� (��������������). 
-- ��� �������� ���������� � ������� ���������� ������� ��� ���������.
Select x1.Name as [���������], isNull(x2.Name, '�� ���������') as [���������]
	From Employee x1
		left join Employee x2 on x2.ID = x1.ID_Manager;