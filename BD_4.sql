﻿/*
Практическая №4.
*/

--Количество сделок, зафиксированных в БД.
Select count(*)
From dbo.Deal;

--Среднее арифметическое значение количества товаров на складе.
Select avg(Quantity)
From dbo.Store;

--Общее количество товаров на складе.
Select sum(Quantity)
From dbo.Store;

--Максимальное количество товаров на складе.
Select max(Quantity)
From dbo.Store;

--Косинус 60º.
--Radians() - переводит градусы в радианы.
Select cos(radians(60.0));

--Целое случайное число в диапазоне [-7; 2].
--Floor() - округление до меньшего целого значения (Для ЦЕЛЫХ чисел надо его использовать).
--Формат: Промежуток [x1; x2]
--        Rand()*(x2-x1+1)+x1
--        Floor( Rand()*(-0.5+0.2+1))-0.2; Для дробных чисел-????
Select Floor(Rand()*(2+7+1))-7;

--Определить (вывести в виде числа от 1 до 7) текущий день недели.
--dw - weekday.
Select datepart(dw, getdate());