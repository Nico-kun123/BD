/*
������������ ������ �12
�������������

�������:
�������� � ������������� ���������, ��������� ������ �� ��������. �������
�.�.�., ����� ������ � �������. ������������ �� ��������� � �������.
*/

-- ���� ������������� ��� ����������, �� ������� ��.
If OBJECT_ID(N'BigBrainStudents', 'V') is not NULL
	Drop View BigBrainStudents;
If OBJECT_ID(N'Select_Groups', 'V') is not NULL
	Drop View Select_Groups;
If OBJECT_ID(N'Answer', 'V') is not NULL
	Drop View Answer;
Go

-- ������ �������������.
-- �������� ������.
Create View Select_Groups
	As
		Select ������.�������� as [������], Count(����������.ID) as [���-�� ���������]
			From ����������
				Inner Join ������ on ������.[ID �������������] = ����������.�������������
			Group by ������.��������;

Go
-- ������� ���������, ��������� ������ �� "�������".
Create View BigBrainStudents
	As
		Select �������, ���, ��������,
			   ������.�������� as ������, �������, Count(��������.������) as [���-�� ������� ���������]
		From ��������
			Join ������ on ������.ID = ��������.[ID_������]
			Join �������� on ��������.[����� �������� ������] = ��������.[����� �������� ������ ��������]
				and ��������.������ in ('�������', '�����')
			Join ���������� on ��������.ID_���������� = ����������.ID
		Group by �������, ���, ��������, ������.��������, �������;

Go
Create View Answer
	As
		Select BigBrainStudents.�������, BigBrainStudents.���, BigBrainStudents.��������,
			   BigBrainStudents.������, BigBrainStudents.�������
		From BigBrainStudents
			Inner Join Select_Groups on Select_Groups.������ = BigBrainStudents.������
		Where BigBrainStudents.[���-�� ������� ���������] = Select_Groups.[���-�� ���������];
Go

-- ������� ������������� �� �����.
Select *
	From Answer
Go