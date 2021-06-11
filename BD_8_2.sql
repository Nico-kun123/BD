/*
������������ �8, ����� 2

��������� ������� ������� (� �����������), �������� ��������� �������:
*/

-- ���������� ����������� �� ������� ������ � �������� ������ �������.
Select Top(3) Employee.Name as [���������], sum( Store.Price * Deal.Quantity * (1 - (Deal.Discount+0.0)/100.0) ) as [�����],
	   Rank() Over(Order by sum( Store.Price * Deal.Quantity * (1 - (Deal.Discount+0.0)/100.0) ) desc) as [������� �����]
	
	From Deal
		inner join Employee on Deal.ID_Employee = Employee.ID
		inner join Store on Deal.ID_Store = Store.ID
	Group by Employee.Name;

/*
������� ����� ������ �� ������� ��� ������� ���������� � �������� ������� �
���������� �������, � ������� ���� ������������� ������.
*/
Select Employee.Name as [���������],
	   datepart(year, Deal.Datee) as [���],
	   datepart(month, Deal.Datee) as [�����],
       sum( Store.Price*Deal.Quantity*(1 - (Deal.Discount+0.0)/100.0) ) as [����� ������],
	   sum( Store.Price*Deal.Quantity*(1 - (Deal.Discount+0.0)/100.0) )-lag(sum(Store.Price*Deal.Quantity*(1 - (Deal.Discount+0.0)/100.0)), 1,0)
		over( partition by Employee.Name order by Employee.Name, datepart(year, Deal.Datee), datepart(month, Deal.Datee) ) as [������� � ���������� �������]

	From Deal
		inner join Employee on Deal.ID_Employee = Employee.ID
		inner join Store on Deal.ID_Store = Store.ID
	Group by Employee.Name, datepart(year, Deal.Datee), datepart(month, Deal.Datee);