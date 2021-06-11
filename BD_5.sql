/*
������������ �5
*/

--����������� ����������� � ���������� (��������) �������.
--DESC - �� ��������.
Select Name
From dbo.Provider
Order by Name Desc;

--���������(�) � ����� ������� ���������.
Select *
From dbo.Provider
Where len(Name) = (Select max(len(Name)) 
                   From dbo.Provider);

--��� ���������� � ��������, ������������ �� ����� �».
Select Name
From dbo.Client
Where Name Like '�%';

--��� ���������� � ��������, ������������ � ���� � ��������� �� "�" �� "�", ��� ������ ����� ��.
Select Name
From dbo.Client
Where Name Like '[�-�]�%';

--���������� ������ �� ������� ����������� �����.
Select count(*) as ����������_������
From dbo.Deal
Where datename(month, Datee) = datename(month, getdate())
  and datename(year, Datee) = datename(year, getdate());

--���������� ������, ��������������� � �������� ��� ������ (��������, �� �������� � ��������).
Select Count(*) as ����������_������
From dbo.Deal
Where Datepart(weekday, Datee) = 5
   Or Datepart(weekday, Datee) = 6;