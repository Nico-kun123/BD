/*
������������ �8, ����� 1

�������� ������ ���������� ������ �� ������ �� �������������: ����� 10 � ����,
�� 10 �� 100 � ����������, ����� 100 � ���������.
*/
Select Product.Name as [������������], sum(Store.Quantity) as [����������],
	Case
		When sum(Store.Quantity) = 0
			Then '�����������'
		When sum(Store.Quantity) < 10
			Then '����'
		When sum(Store.Quantity) between 10 and 100
			Then '����������'
			Else '���������'
	End as [������]
			
	From Product
		inner join Store on Store.ID_Product = Product.ID
	Group by Product.Name;

-- ������� ������������ �������, ���������� ������� �� ������ �� 1 �� 10.
Select Product.Name as [������������], sum(Store.Quantity) as [����������]
	From Product
		Left join Store on Store.ID_Product = Product.ID
	Group by Product.Name
	Having sum(Store.Quantity) between 1 and 10
	Order by sum(Store.Quantity)
	Desc;

-- ���������� ������ �������, ������� �� ������� ����� �������.
Select TOP(3) Product.Name as [������������], sum(Store.Price * Deal.Quantity * (1 - (Deal.Discount+0.0)/100.0) ) as [�����]
	From Product
		inner join Store on Store.ID_Product = Product.ID
		inner join Deal on Store.ID = Deal.ID_Store

	Group by Product.Name
	Order by sum(Store.Price * Deal.Quantity * (1 - (Deal.Discount+0.0)/100.0) )
	Desc;

-- ���������� ��������� ��������� ������ ������� ������ �� �������.
Select Product.Name as [������������],
	   datepart(year, Deal.Datee) as [���],
	   datename(month, Deal.Datee) as [�����],
	   sum( Store.Price * Deal.Quantity * (1 - (Deal.Discount+0.0)/100.0) ) as [�����]

	From Product
		inner join Store on Store.ID_Product = Product.ID
		inner join Deal on Store.ID = Deal.ID_Store
	Group by Product.Name, datename(month, Deal.Datee), datepart(year, Deal.Datee)
	Order by sum( Store.Price * Deal.Quantity * (1 - (Deal.Discount+0.0)/100.0) );

/*
�������� ������, � ������� ������� ������ (��� ������ ������� ������,
����������� �� ������ � �����	�� ID) ���� ���� 300 �����.
*/
Select Product.Name as [������������],
	   datepart(year, Deal.Datee) as [���],
	   datename(month, Deal.Datee) as [�����],
	   sum( Store.Price * Deal.Quantity * (1 - (Deal.Discount+0.0)/100.0) ) as [�����]

	From Product
		inner join Store on Store.ID_Product = Product.ID
		inner join Deal on Store.ID = Deal.ID_Store

	Where Product.Name = '������'
		
	Group by Product.Name, Deal.Datee -- "��, ��������"
	Having sum( Store.Price * Deal.Quantity * (1 - (Deal.Discount+0.0)/100.0) ) <= 300
	Order by Deal.Datee;