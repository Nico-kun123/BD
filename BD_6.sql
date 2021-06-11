/*
������������ �6
*/

--������� ������������ �������, ���������� ������� �� ������ ����������� (��
--������ ������ ���� ��� ������� ��� ������, ���������� ������� ��������� �
--����� �������������).
Select Name
From dbo.Product
Where ID IN (Select ID_Product
             From dbo.Store
			 Where Quantity = (Select max(Quantity) 
			                   From dbo.Store));
			 
--������� � �������, �������� �����������, ������������ �������, ����������
--������� �� ������ ��������� � �������� ���������.
Select Name
From dbo.Product
Where ID IN (Select ID_Product
             From dbo.Store
			 Where Quantity Between 1 and 20) 
Order by Name
Desc;

--������� �����������, ������� ���� �� ��� ����������� ��������, � ���������� �������.
Select Name
From dbo.Provider
Where ID IN (Select ID_Provider
             From dbo.Store)
Order by Name
Asc;

--30 ���� � ���� ��������� ������� ��������� �������������� ������ �� ��� ������.
--������� ������ �����������, ������� ����������� ��������������� ���������
--�������.
Select *
From dbo.Client
Where ID in (Select ID_Client
             From dbo.Deal
			 Where Datee >= Dateadd(day, -30, Getdate()));

--������� ������ �������, �������� ������� ������������ � ���� �Ļ � �˻,
--��������� ������� �� ����� 20% �� ������������.
Select *
From dbo.Product
Where Name Like '[�,�]%'
  And ID IN (Select ID_Product
             From dbo.Store
			 Where Price < ( (Select max(price)
			                  From dbo.Store) * 0.2) );

--������� �����������, ������� �� ���������� ������, �������� �������
--������������ � ���� �Ļ � �˻.
Select Name
From dbo.Provider
Where ID NOT IN (Select ID_Provider
                 From dbo.Store
				 Where ID_Product IN (Select ID
				                      From dbo.Product
									  Where Name Like '[�,�]%') );

--�������� ������ �������� � ��������� �� ���� (�������� ��� ��������).
Select ID, Name, Phone, Address,
Case
    When Sex = 'M'
	  Then '�������'
	When Sex = 'F'
	  Then '�������'
	  Else '��� �� ������'
  End As Sex
From dbo.Client;