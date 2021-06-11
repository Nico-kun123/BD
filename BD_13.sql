/*
������������ ������ �13
��������

�������:
������� ��������� ���� �������� ��� ��������������� ������.
*/

-- ������� ��������, ���� ��� ��� ����������.
IF OBJECT_ID('Trigger_Delete', 'Trigger') IS NOT NULL
    DROP TRIGGER Trigger_Delete;
IF OBJECT_ID('Trigger_Update', 'Trigger') IS NOT NULL
    DROP TRIGGER Trigger_Update;
IF OBJECT_ID('Trigger_Add', 'Trigger') IS NOT NULL
    DROP TRIGGER Trigger_Add;

Go
/*
������� �� ��������:
��� �������� ��������� ����������, ������� �� ���� ������� ����������, ��
������� ���� �� ���� ������� ������� ������� (�����).
*/
Create Trigger Trigger_Delete on ���������� instead of DELETE
	As
		If(Select Count(��������.ID_����������)
		   From ��������
		   Where ��������.ID_���������� in (Select ID From deleted)) <> 0
		Begin
			-- �����.
			RollBack Transaction
			Print '��� ���������� ������� ������! :('
		End;

Go
DELETE From dbo.����������
	Where ����������.ID = 3;

Go
/*
������� �� ����������:
��������� ������ �������� � ��������� ������. ���� ����������� �� ���������
�������� ������� �� ������� � ���� ������, ������� �������� ����������.
*/
Create Trigger Trigger_Update on ������ For UPDATE
	As Begin
		If(Select inserted.�������� From inserted) not in
		  (Select ��������.[����� �������� ������]
		   From ��������
		   Where ��������.ID_������ in (Select inserted.id From inserted))
		Begin
			Rollback Transaction
			Print '������� �� ������� � ������ ������! :('
		End
		End;

Go
-- ��������, �������� ��������� �������� �� ������ ��19-06� ��
-- ��������� �������� ������ ��19-09�.
Update ������
	Set �������� = 653490642
	Where ������.ID = 4;

Go
/*
������� �� ����������:
�� ��������� �������� ���������� � ������� �������� (��� ������), ����
���������� �� ������������� ������������� ��������.
*/
Create Trigger Trigger_Add on �������� For INSERT
	As Begin
		Declare @record_book Int
		Select @record_book = (Select [����� �������� ������ ��������] From inserted)
		If(Select �������������
		   From ���������� Join inserted on inserted.ID_���������� = ����������.ID) =
		  (Select ������.[ID �������������]
		   From ������
		   Where ������.ID = (Select ��������.ID_������
								From ��������
									Join inserted on inserted.[����� �������� ������ ��������] = ��������.[����� �������� ������]))
		Begin
			Rollback Transaction
			Print '������� �������� ������ �������� ������ ����������! :('
		End
	End;

-- ��������, ����� �� �������.
Go
Insert ��������
	Values(612345678, 2, '2020-01-15', '������');
Go