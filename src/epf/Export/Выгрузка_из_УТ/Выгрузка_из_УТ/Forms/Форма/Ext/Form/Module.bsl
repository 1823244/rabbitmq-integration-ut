﻿



&НаСервере
Процедура ВыполнитьЭкспортНаСервере()
	РеквизитФормыВЗначение("Объект").ВыполнитьЭкспорт();
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЭкспорт(Команда)
	ВыполнитьЭкспортНаСервере();
	ПоказатьПредупреждение(,"Экспорт завершен");
КонецПроцедуры



&НаСервере
Процедура ВыгрузитьПеречисленияНаСервере()
	РеквизитФормыВЗначение("Объект").ВыгрузитьПеречисления();
	РеквизитФормыВЗначение("Объект").ВыгрузитьПеречисленияПредопрСравочники();
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьПеречисления(Команда)
	ВыгрузитьПеречисленияНаСервере();
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЭкспортВерсия2НаСервере()
	РеквизитФормыВЗначение("Объект").ВыполнитьЭкспорт_Версия_2();
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЭкспортВерсия2(Команда)
	ВыполнитьЭкспортВерсия2НаСервере();    
	ПоказатьПредупреждение(,"Экспорт (версия 2) завершен");
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Версия = РеквизитФормыВЗначение("Объект").getVersion();
КонецПроцедуры



&НаСервере
Функция ВыполнитьЭкспортЛюбойСсылкиНаСервере()
	Возврат ксп_ЭкспортСлужебный.ВыгрузитьОбъектПоСсылке(ЛюбаяСсылка);
КонецФункции

&НаКлиенте
Процедура ВыполнитьЭкспортЛюбойСсылки(Команда)
	json = ВыполнитьЭкспортЛюбойСсылкиНаСервере();
	т = Новый ТекстовыйДокумент;
	т.УстановитьТекст(json);
	т.Показать(Строка(ЛюбаяСсылка));
КонецПроцедуры
