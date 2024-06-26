﻿Перем НЕ_ЗАГРУЖАТЬ;
Перем СОЗДАТЬ;
Перем ОБНОВИТЬ;
Перем ОТМЕНИТЬ_ПРОВЕДЕНИЕ;

Перем мВнешняяСистема;
Перем ИмяСобытияЖР;

#Область ПодключениеОбработкиКБСП

Функция СведенияОВнешнейОбработке() Экспорт

	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке();

	ПараметрыРегистрации.Вставить("Вид",ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительнаяОбработка());
	ПараметрыРегистрации.Вставить("Версия","1.07");
	//ПараметрыРегистрации.Вставить("Назначение", Новый Массив);
	ПараметрыРегистрации.Вставить("Наименование","Плагин_RabbitMQ_импорт_из_ЕРП_Документ_ЗаказКлиента");
	ПараметрыРегистрации.Вставить("БезопасныйРежим", Ложь);
	ПараметрыРегистрации.Вставить("Информация","Плагин_RabbitMQ_импорт_из_ЕРП_Документ_ЗаказКлиента");
	ПараметрыРегистрации.Вставить("ВерсияБСП", "3.1.5.180");
	//ПараметрыРегистрации.Вставить("ОпределитьНастройкиФормы", Ложь);
	
	
	ТипКоманды = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы();
	ДобавитьКоманду(ПараметрыРегистрации.Команды, 
		"Открыть форму : Плагин_RabbitMQ_импорт_из_ЕРП_Документ_ЗаказКлиента",
		"Форма_Плагин_RabbitMQ_импорт_из_ЕРП_Документ_ЗаказКлиента",
		ТипКоманды, 
		Ложь) ;
	
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование, ПоказыватьОповещение = Ложь, Модификатор = "")

	//ТаблицаКоманд.Колонки.Добавить("Представление", РеквизитыТабличнойЧасти.Представление.Тип);
	//ТаблицаКоманд.Колонки.Добавить("Идентификатор", РеквизитыТабличнойЧасти.Идентификатор.Тип);
	//ТаблицаКоманд.Колонки.Добавить("Использование", Новый ОписаниеТипов("Строка"));
	//ТаблицаКоманд.Колонки.Добавить("ПоказыватьОповещение", РеквизитыТабличнойЧасти.ПоказыватьОповещение.Тип);
	//ТаблицаКоманд.Колонки.Добавить("Модификатор", РеквизитыТабличнойЧасти.Модификатор.Тип);
	//ТаблицаКоманд.Колонки.Добавить("Скрыть",      РеквизитыТабличнойЧасти.Скрыть.Тип);
	//ТаблицаКоманд.Колонки.Добавить("ЗаменяемыеКоманды", РеквизитыТабличнойЧасти.ЗаменяемыеКоманды.Тип);
	
//           ** Использование - Строка - тип команды:
//               "ВызовКлиентскогоМетода",
//               "ВызовСерверногоМетода",
//               "ЗаполнениеФормы",
//               "ОткрытиеФормы" или
//               "СценарийВБезопасномРежиме".
//               Для получения типов команд рекомендуется использовать функции
//               ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКоманды<ИмяТипа>.
//               В комментариях к этим функциям также даны шаблоны процедур-обработчиков команд.

	НоваяКоманда = ТаблицаКоманд.Добавить() ;
	НоваяКоманда.Представление = Представление ;
	НоваяКоманда.Идентификатор = Идентификатор ;
	НоваяКоманда.Использование = Использование ;
	НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение ;
	НоваяКоманда.Модификатор = Модификатор ;
КонецПроцедуры


#КонецОбласти 	


//--------------------


Функция ЗагрузитьОбъект(СтруктураОбъекта, мОрганизация, jsonText = "") Экспорт
		
		Если НЕ СтруктураОбъекта.Свойство("type") Тогда // на случай, если передадут пустой объект
			Возврат Неопределено;
		КонецЕсли;
	
		Если НЕ НРег(СтруктураОбъекта.type) = НРег("документ.ЗаказКлиента") Тогда
			Возврат Неопределено;
		КонецЕсли;

		id = СтруктураОбъекта.identification;
		деф = СтруктураОбъекта.definition;

		Рез = СоздатьОбновитьДокумент(СтруктураОбъекта, мОрганизация);
		
		Возврат Рез;
		
КонецФункции

Функция СоздатьОбновитьДокумент(СтруктураОбъекта, мОрганизация) Экспорт
	
	id = СтруктураОбъекта.identification;
	деф = СтруктураОбъекта.definition;   
	
	ПустойДокумент = Документы.ЗаказКлиента.ПустаяСсылка();
	
	ДокументИзБазаПоказов = "Заявка покупателя (База показов) № " + деф.Number + " от " + строка(деф.Date);
	
	УИД = Новый УникальныйИдентификатор(id.Ref);
	СуществующийДокСсылка = Документы.ЗаказКлиента.ПолучитьСсылку(УИД);
	
	Если ЗначениеЗаполнено(СуществующийДокСсылка.ВерсияДанных) Тогда
		ЭтоНовый = Ложь;
	Иначе   
		ЭтоНовый = Истина;
	КонецЕсли;
	
	Комментарий = "";
	
	// -------------------------------------------- БЛОКИРОВКА
	
	Если НЕ ЭтоНовый Тогда
		МассивСсылок = Новый Массив;
		МассивСсылок.Добавить(СуществующийДокСсылка);
		Блокировка = ксп_Блокировки.СоздатьБлокировкуНесколькихОбъектов(МассивСсылок);
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Если НЕ ЭтоНовый Тогда
		Попытка
			Блокировка.Заблокировать();
		Исключение
			т = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации(ИмяСобытияЖР,УровеньЖурналаРегистрации.Ошибка,,,
				"Объект не загружен! Ошибка блокировки документа для " + ДокументИзБазаПоказов + ". Подробности: " + т);
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
	КонецЕсли;
	
	Рез = Неопределено;
	
	//------------------------------------- Заполнение реквизитов
	
	Попытка			
		
		Действие = ДействиеСДокументом(ЭтоНовый, СуществующийДокСсылка, деф);
		Если Действие = НЕ_ЗАГРУЖАТЬ Тогда
			ОтменитьТранзакцию();
			
			Возврат СуществующийДокСсылка;
		КонецЕсли;
		
		Если Действие = ОТМЕНИТЬ_ПРОВЕДЕНИЕ Тогда
			ОбъектДанных = СуществующийДокСсылка.ПолучитьОбъект();
			ОбъектДанных.Записать(РежимЗаписиДокумента.ОтменаПроведения);
			ЗафиксироватьТранзакцию();
			
			Возврат СуществующийДокСсылка;
		КонецЕсли;
		
		Если Действие = ОБНОВИТЬ Тогда
			ОбъектДанных = СуществующийДокСсылка.ПолучитьОбъект();
			
		ИначеЕсли Действие = СОЗДАТЬ Тогда
			ОбъектДанных = Документы.ЗаказКлиента.СоздатьДокумент();
			СсылкаНового = Документы.ЗаказКлиента.ПолучитьСсылку(УИД);
			ОбъектДанных.УстановитьСсылкуНового(СсылкаНового);
			
		Иначе 
			ОтменитьТранзакцию();
			
			Возврат ПустойДокумент;
		КонецЕсли;
		
		ПредставлениеОбъекта = Строка(ОбъектДанных);
		
		ЗаполнитьРеквизиты(СтруктураОбъекта, ОбъектДанных, мОрганизация);

		ОбъектДанных.ОбменДанными.Загрузка = Ложь;
		
		Если ОбъектДанных.Проведен Тогда
			ОбъектДанных.Записать(РежимЗаписиДокумента.ОтменаПроведения);
		Иначе 
			ОбъектДанных.Записать();
		КонецЕсли;
		
		ОбновитьРегистрСостоянияЗаказов(ОбъектДанных.Ссылка);
		
		// Документ будет помещен в Отложенное проведение
		jsonText = "";
		ксп_ИмпортСлужебный.Документы_ПослеИмпорта_01(ОбъектДанных, мВнешняяСистема, СтруктураОбъекта, jsonText, ЭтотОбъект);
		ксп_ИмпортСлужебный.Документы_ПослеИмпорта_02(ОбъектДанных, мВнешняяСистема, СтруктураОбъекта, jsonText, ЭтотОбъект);
		ксп_ИмпортСлужебный.Документы_ПослеИмпорта_03(ОбъектДанных, мВнешняяСистема, СтруктураОбъекта, jsonText, ЭтотОбъект);
		ксп_ИмпортСлужебный.Документы_ПослеИмпорта_04(ОбъектДанных, мВнешняяСистема, СтруктураОбъекта, jsonText, ЭтотОбъект);
		ксп_ИмпортСлужебный.Документы_ПослеИмпорта_05(ОбъектДанных, мВнешняяСистема, СтруктураОбъекта, jsonText, ЭтотОбъект);	
		
		Рез = ОбъектДанных.ССылка;
		
		ОбъектДанных.ОбъектРасчетов = НайтиСоздатьОбъектРасчетов(ОбъектДанных);
		
		ОбъектДанных.Записать();
	
		ЗафиксироватьТранзакцию();
		
	Исключение
		т = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(ИмяСобытияЖР,УровеньЖурналаРегистрации.Ошибка,,,
			"Объект не загружен! Ошибка в процессе загрузки документа " + ДокументИзБазаПоказов + ". Подробности: " + т);
		Если ТранзакцияАктивна() Тогда
			ОтменитьТранзакцию();
		КонецЕсли;
	КонецПопытки;	
	
	Возврат Рез;
	
КонецФункции

// Заполняет реквизиты объекта и пишет сопутствующие данные. Должна вызываться в транзакции.
Функция ЗаполнитьРеквизиты(СтруктураОбъекта, ОбъектДанных, мОрганизация)
	
	id = СтруктураОбъекта.identification;
	деф = СтруктураОбъекта.definition;
	
	ОбъектДанных.Номер = деф.Number;
	ОбъектДанных.Дата = деф.Date;
	ОбъектДанных.ПометкаУдаления = деф.DeletionMark;
	ОбъектДанных.Комментарий = "[ЕРП №" + деф.Number + " от " + деф.Date + " ]. Ориг. коммент.: "+деф.Комментарий;
	
	ОбъектДанных.Организация = мОрганизация;
	
	ОбъектДанных.Валюта = Константы.ВалютаРегламентированногоУчета.Получить();
	
	ТэгКонтрагента = деф.Контрагент;
	КонтрагентСсылка = ксп_ИмпортСлужебный.НайтиКонтрагента(деф.Контрагент, мВнешняяСистема);
	
	ОбъектДанных.Контрагент = КонтрагентСсылка;
	
	ОбъектДанных.Договор = ксп_ИмпортСлужебный.НайтиДоговор(деф.Договор); //по гуид
	Если НЕ ЗначениеЗаполнено(ОбъектДанных.Договор) Тогда
		ОбъектДанных.Договор = НайтиДоговорРеализации(ОбъектДанных.Контрагент, ОбъектДанных.Организация);  //первый попавшийся "СПокупателем"
	КонецЕсли;
	
	ОбъектДанных.НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС;
	
	ОбъектДанных.ОплатаВВалюте = Ложь;
	
	Если ЗначениеЗаполнено(ОбъектДанных.Контрагент) Тогда
		ОбъектДанных.Партнер = ОбъектДанных.Контрагент.Партнер;
	Иначе 
		ОбъектДанных.Партнер = Неопределено;
	КонецЕсли;
	
	ОбъектДанных.Статус = Перечисления.СтатусыЗаказовКлиентов.НеСогласован;
	
	ОбъектДанных.Соглашение = 
	РегистрыСведений.ксп_ДополнительныеНастройкиИнтеграций.Настройка("Соглашение_ЗаказКлиента", мВнешняяСистема);
	
	ОбъектДанных.СуммаДокумента = деф.СуммаДокумента;
	
	ОбъектДанных.СпособДоставки = Перечисления.СпособыДоставки.Самовывоз;
	
	ОбъектДанных.Приоритет = Справочники.Приоритеты.НайтиПоНаименованию("средний", истина);
	
	ОбъектДанных.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияКлиенту;
	
	ОбъектДанных.ЦенаВключаетНДС = деф.ЦенаВключаетНДС;
	
	ОбъектДанных.СкидкиРассчитаны = Истина;
	
	ОбъектДанных.ДатаСогласования = ОбъектДанных.Дата;
	
	ОбъектДанных.Согласован = Ложь;
	
	//ОбъектДанных.ЭтоЗаказКакСчет = Истина;//нет в 11.5.8
	
	
	////------------------------------------------------------     ТЧ Товары
	
	
	
	ОбъектДанных.Товары.Очистить();
	
	счКлючСвязи = 1;
	Для счТовары = 0 По деф.ТЧТовары.Количество()-1 Цикл
		
		стрк = деф.ТЧТовары[счТовары];
		СтрокаТЧ = ОбъектДанных.Товары.Добавить();
		
		//СтрокаТЧ.Количество = стрк.Количество;
		
		//СтрокаТЧ.КоличествоУпаковок = стрк.Количество;
		
		//Если стрк.Номенклатура.Свойство("identification") Тогда
		//	// это полный объект номенклатуры.
		//	ТэгНоменклатуры = стрк.Номенклатура.identification;
		//Иначе 
		//	ТэгНоменклатуры = стрк.Номенклатура;
		//КонецЕсли;			
		//
		//_Номенклатура = ксп_ИмпортСлужебный.НайтиНоменклатуру(ТэгНоменклатуры);
		//
		//СтрокаТЧ.Номенклатура = _Номенклатура;
		//
		//СтрокаТЧ.Характеристика = ксп_ИмпортСлужебный.НайтиХарактеристику(стрк.ХарактеристикаНоменклатуры);
		//
		
		//СтрокаТЧ.ПроцентАвтоматическойСкидки = стрк.ПроцентАвтоматическихСкидок;
		
		//СтрокаТЧ.СтавкаНДС = СтрокаТЧ.Номенклатура.СтавкаНДС;//ксп_ИмпортСлужебный.ОпределитьСтавкуНДСПоПеречислениюРозницы(стрк.СтавкаНДС);
		
		//СтрокаТЧ.Сумма = стрк.Сумма;
		
		//СтрокаТЧ.СуммаНДС = стрк.СуммаНДС;
		
		//СтрокаТЧ.СуммаСНДС = стрк.Сумма;
		
		////СтрокаТЧ.Упаковка = ксп_ИмпортСлужебный.НайтиЕдиницуИзмерения(стрк.Упаковка, стрк.Номенклатура);
		
		//СтрокаТЧ.Цена = стрк.Цена;
		//
		//СтрокаТЧ.ВариантОбеспечения = Перечисления.ВариантыОбеспечения.Отгрузить;
		//
		//СтрокаТЧ.ДатаОтгрузки = ОбъектДанных.Дата;
		//
		//СтрокаТЧ.КлючСвязи = счКлючСвязи;
		//
		//счКлючСвязи = счКлючСвязи + 1;
		
		СтрокаТЧ.КлючСвязи = стрк.КлючСвязи;
		СтрокаТЧ.КодСтроки = стрк.КодСтроки;
		СтрокаТЧ.Количество = стрк.Количество;
		СтрокаТЧ.КоличествоУпаковок = стрк.КоличествоУпаковок;
		
		СтрокаТЧ.ДатаОтгрузки = стрк.ДатаОтгрузки;
		
		СтрокаТЧ.ИдентификаторСтроки = стрк.ИдентификаторСтроки;
		
		СтрокаТЧ.Подразделение = ксп_ИмпортСлужебный.НайтиПодразделение(стрк.Подразделение, мВнешняяСистема);
		
		//СтрокаТЧ.Обособлено = стрк.Обособлено;
		
		СтрокаТЧ.НоменклатураНабора = ксп_ИмпортСлужебный.НайтиНоменклатуру(Стрк.НоменклатураНабора);
		
		СтрокаТЧ.НоменклатураПартнера = ксп_ИмпортСлужебный.НайтиНоменклатуру(стрк.НоменклатураПартнера);
		
		СтрокаТЧ.Содержание = стрк.Содержание;
		
		СтрокаТЧ.СрокПоставки = стрк.СрокПоставки;
		
		СтрокаТЧ.СтатусУказанияСерий = стрк.СтатусУказанияСерий;
		
		
		СтрокаТЧ.Номенклатура = ксп_ИмпортСлужебный.НайтиНоменклатуру(стрк.Номенклатура);
		
		СтрокаТЧ.Отменено = стрк.Отменено;
		
		СтрокаТЧ.ПричинаОтмены = Неопределено;
		
		СтрокаТЧ.ПроцентАвтоматическойСкидки = стрк.ПроцентАвтоматическойСкидки;
		СтрокаТЧ.ПроцентРучнойСкидки = стрк.ПроцентРучнойСкидки;
		
		СтрокаТЧ.СтавкаНДС = СтрокаТЧ.Номенклатура.СтавкаНДС;
		
		СтрокаТЧ.СуммаНДС = стрк.СуммаНДС;
		СтрокаТЧ.СуммаАвтоматическойСкидки = стрк.СуммаАвтоматическойСкидки;
		//СтрокаТЧ.СуммаБонусныхБалловКСписанию = стрк.СуммаБонусныхБалловКСписанию;
		//СтрокаТЧ.СуммаБонусныхБалловКСписаниюВВалюте = стрк.СуммаБонусныхБалловКСписаниюВВалюте;
		//СтрокаТЧ.СуммаНачисленныхБонусныхБалловВВалюте = стрк.СуммаНачисленныхБонусныхБалловВВалюте;
		СтрокаТЧ.СуммаРучнойСкидки = стрк.СуммаРучнойСкидки;
		СтрокаТЧ.Сумма = стрк.Сумма;
		СтрокаТЧ.СуммаСНДС = стрк.СуммаСНДС;
		
		
		СтрокаТЧ.Характеристика = ксп_ИмпортСлужебный.НайтиХарактеристику(стрк.Характеристика);
		
		СтрокаТЧ.Цена = стрк.Цена;
		
		
		Упаковка = ксп_ИмпортСлужебный.НайтиЕдиницуИзмерения(стрк.Упаковка, стрк.Номенклатура);
		//упаковка может быть не указана в строке ТЧ, тогда используем единицу хранения номенклатуры
		Если НЕ ЗначениеЗаполнено(Упаковка) Тогда
			Упаковка = СтрокаТЧ.Номенклатура.ЕдиницаИзмерения;
		КонецЕсли;
		СтрокаТЧ.Упаковка = Упаковка;
		
		СтрокаТЧ.ВариантОбеспечения = Перечисления.ВариантыОбеспечения.НеТребуется;
		
	КонецЦикла;
	
КонецФункции

// Описание_метода
//
// Параметры:
//	Параметр1 	- Тип1 - 
//
Процедура ОбновитьРегистрСостоянияЗаказов(ЗаказКлиентаСсылка)
	
	НаборЗаписей = РегистрыСведений.СостоянияЗаказовКлиентов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Заказ.Установить(ЗаказКлиентаСсылка);
	
	НовСтр = НаборЗаписей.Добавить();
	НовСтр.Заказ = ЗаказКлиентаСсылка;
	НовСтр.Состояние = Перечисления.СостоянияЗаказовКлиентов.ОжидаетсяСогласование;
	НовСтр.ДатаСобытия = ТекущаяДатаСеанса();
	
	НаборЗаписей.Записать();
		
КонецПроцедуры


//--------------------


// Описание_метода
//
// Параметры:
//	ВариантОбеспечения 	- строка - узел перечисления
//
// Возвращаемое значение:
//	Тип: Булево
//
Функция РезервироватьИлиНет(ВариантОбеспечения)
		
	Если 	НРег(ВариантОбеспечения.Значение) = НРег("СоСклада") 
		ИЛИ НРег(ВариантОбеспечения.Значение) = НРег("Отгрузить") Тогда
		
		Возврат Истина;
		
	КонецЕсли;

	Возврат Ложь;
	
КонецФункции


// Описание_метода
//
// Параметры:
//	Параметр1 	- Тип1 - 
//
// Возвращаемое значение:
//	Тип: Тип_значения
//
Функция СтатусЗаказа(УзелСтатус)

	Если УзелСтатус.Значение = "КОбеспечению" Тогда
		Возврат Перечисления.СтатусыЗаказовПокупателей.Согласован;
	ИначеЕсли УзелСтатус.Значение = "НеСогласован" Тогда
		Возврат Перечисления.СтатусыЗаказовПокупателей.НеСогласован;
	ИначеЕсли УзелСтатус.Значение = "КОтгрузке" Тогда
		Возврат Перечисления.СтатусыЗаказовПокупателей.Согласован;
	ИначеЕсли УзелСтатус.Значение = "Закрыт" Тогда
		Возврат Перечисления.СтатусыЗаказовПокупателей.Закрыт;
	КонецЕсли;

	Возврат Перечисления.СтатусыЗаказовПокупателей.НеСогласован;
	
КонецФункции



// Описание_метода
//
// Параметры:
//	Параметр1 	- Тип1 - 
//
// Возвращаемое значение:
//	Тип: Тип_значения
//
Функция НайтиДоговорРеализации(Контрагент, Организация) Экспорт
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДоговорыКонтрагентов.Ссылка КАК Договор
		|ИЗ
		|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
		|ГДЕ
		|	ДоговорыКонтрагентов.ТипДоговора = &ТипДоговора
		|	И ДоговорыКонтрагентов.Организация = &Организация
		|	И ДоговорыКонтрагентов.Контрагент = &Контрагент";
	
	
	ТипДоговора = Перечисления.ТипыДоговоров.СПокупателем;
	
	Запрос.УстановитьПараметр("ТипДоговора", ТипДоговора);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат ВыборкаДетальныеЗаписи.Договор;
	КонецЦикла;
		
	Возврат Неопределено;
	
КонецФункции

// Описание_метода
//
// Параметры:
//	Параметр1 	- Тип1 - 
//
// Возвращаемое значение:
//	Тип: Тип_значения
//
Функция НайтиСоздатьОбъектРасчетов(ОбъектДанных) Экспорт
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОбъектыРасчетов.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ОбъектыРасчетов КАК ОбъектыРасчетов
		|ГДЕ
		|	ОбъектыРасчетов.Объект = &Объект
		|	И ОбъектыРасчетов.ТипРасчетов = &ТипРасчетов";
	
	Запрос.УстановитьПараметр("Объект", ОбъектДанных.Ссылка);
	Запрос.УстановитьПараметр("ТипРасчетов", Перечисления.ТипыРасчетовСПартнерами.РасчетыСКлиентом);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат ВыборкаДетальныеЗаписи.Ссылка;
	КонецЦикла;
	
	Обк = Справочники.ОбъектыРасчетов.СоздатьЭлемент();
	Обк.Наименование = Строка(ОбъектДанных.Ссылка);
	Обк.Валюта = константы.ВалютаРегламентированногоУчета.Получить();
	Обк.ВалютаВзаиморасчетов = константы.ВалютаРегламентированногоУчета.Получить();
	Обк.ГруппаФинансовогоУчета = Неопределено;
	Обк.Дата = ОбъектДанных.Дата;
	Обк.ДатаВходящегоДокумента = Неопределено;
	Обк.Договор = Неопределено;
	Обк.ИдентификаторПлатежа = "ЗК"+строка(Новый УникальныйИдентификатор);
	Обк.Касса = Неопределено;
	Обк.Комментарий = "";
	Обк.Контрагент = ОбъектДанных.Контрагент;
	Обк.Менеджер = Неопределено;
	Обк.НаименованиеПервичногоДокумента = "";
	Обк.НалогообложениеНДС = перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС;
	Обк.НаправлениеДеятельности = Неопределено;
	Обк.Номер = ОбъектДанных.Номер;
	Обк.НомерВходящегоДокумента = "";
	Обк.Объект = ОбъектДанных.Ссылка;
	Обк.ОплатаВВалюте = Ложь;
	Обк.Организация = ОбъектДанных.Организация;
	Обк.Партнер = ОбъектДанных.Партнер;
	Обк.Подразделение = Неопределено;
	Обк.Соглашение = ОбъектДанных.Соглашение;
	Обк.Состояние = 1;
	Обк.Сумма = ОбъектДанных.СуммаДокумента;
	Обк.СуммаВзаиморасчетов = 0;
	Обк.ТипОбъектаРасчетов = Перечисления.ТипыОбъектовРасчетов.Заказ;
	Обк.ТипРасчетов = Перечисления.ТипыРасчетовСПартнерами.РасчетыСКлиентом;
	Обк.ТипСсылки = Справочники.ИдентификаторыОбъектовМетаданных.НайтиПоРеквизиту("ПолноеИмя","Документ.ЗаказКлиента");
	Обк.ТолькоОстатки = Ложь;
	Обк.УникальныйИдентификатор = Строка(Новый УникальныйИдентификатор);
	Обк.ФормаОплаты = Неопределено;

	
	Обк.Записать();

		
	Возврат Обк.Ссылка;
	
КонецФункции


#Область Тестирование

// Описание_метода
//
// Параметры:
//	Параметр1 	- Тип1 - 
//
// Возвращаемое значение:
//	Тип: Тип_значения
//
Функция ЗагрузитьИзJsonНаСервере(Json) export
	
	мЧтениеJSON = Новый ЧтениеJSON;
	
	мЧтениеJSON.УстановитьСтроку(Json);
	
	СтруктураОбъекта = ПрочитатьJSON(мЧтениеJSON,,,,"ФункцияВосстановленияJSON",ЭтотОбъект);//структура
	
	деф = СтруктураОбъекта.definition;
	мОрганизация = ксп_ИмпортСлужебный.НайтиОрганизацию(деф.Организация, мВнешняяСистема);
	
	Результат = Неопределено;
	Если ЗначениеЗаполнено(мОрганизация.ВерсияДанных) Тогда
		Результат = ЗагрузитьОбъект(СтруктураОбъекта, мОрганизация);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти 	


Функция ФункцияВосстановленияJSON(Свойство, Значение, ДопПараметры) Экспорт
	
	Если Свойство = "Date"Тогда
		Возврат ПрочитатьДатуJSON(Значение, ФорматДатыJSON.ISO);
	КонецЕсли;
	Если Свойство = "Период"Тогда
		Возврат ПрочитатьДатуJSON(Значение, ФорматДатыJSON.ISO);
	КонецЕсли;
	Если Свойство = "Сумма" Тогда
		Если ТипЗнч(Значение) = Тип("Число") Тогда
			Возврат Значение;
		Иначе
			Возврат XMLЗначение(Тип("Число"),Значение);
		КонецЕсли;
	КонецЕсли;
	
КонецФункции



// Описание_метода
//
// Параметры:
//	Параметр1 	- Тип1 - 
//
// Возвращаемое значение:
//	Тип: Тип_значения
//
Функция МассивРеквизитовШапкиДляПроверки() Экспорт
	
	мРеквизиты = Новый Массив;
	мРеквизиты.Добавить("Склад");
	мРеквизиты.Добавить("Организация");
	Возврат мРеквизиты;
	
КонецФункции


// Описание_метода
//
// Параметры:
//	Параметр1 	- Тип1 - 
//
// Возвращаемое значение:
//	Тип: Тип_значения
//
Функция ДействиеСДокументом(ЭтоНовый, СуществующийДокСсылка, деф) Экспорт
	
	
	Если НЕ ЭтоНовый Тогда	
		
		Если СуществующийДокСсылка.ПометкаУдаления Тогда
			
			Если деф.DeletionMark = Истина Тогда
				Возврат НЕ_ЗАГРУЖАТЬ;
			ИначеЕсли НЕ деф.isPosted Тогда
				Возврат НЕ_ЗАГРУЖАТЬ;
			ИначеЕсли деф.isPosted Тогда
				Возврат ОБНОВИТЬ;
			КонецЕсли;		
			
		ИначеЕсли НЕ СуществующийДокСсылка.Проведен Тогда
			
			Если деф.DeletionMark = Истина Тогда
				Возврат НЕ_ЗАГРУЖАТЬ;
			ИначеЕсли НЕ деф.isPosted Тогда
				Возврат НЕ_ЗАГРУЖАТЬ;
			ИначеЕсли деф.isPosted Тогда
				Возврат ОБНОВИТЬ;
			КонецЕсли;
			
		ИначеЕсли СуществующийДокСсылка.Проведен Тогда
			
			Если деф.DeletionMark = Истина Тогда
				Возврат ОТМЕНИТЬ_ПРОВЕДЕНИЕ;
			ИначеЕсли НЕ деф.isPosted Тогда
				Возврат ОТМЕНИТЬ_ПРОВЕДЕНИЕ;
			ИначеЕсли деф.isPosted Тогда
				Возврат ОБНОВИТЬ;
			КонецЕсли;

		КонецЕсли;
		
	Иначе // новый документ
		
		Если деф.DeletionMark = Истина Тогда
			Возврат НЕ_ЗАГРУЖАТЬ;
		ИначеЕсли НЕ деф.isPosted Тогда
			Возврат НЕ_ЗАГРУЖАТЬ;
		ИначеЕсли деф.isPosted Тогда
			Возврат СОЗДАТЬ;
		КонецЕсли;		

	КонецЕсли;
		
	Возврат НЕ_ЗАГРУЖАТЬ;
	
КонецФункции



мВнешняяСистема = "erp";
ИмяСобытияЖР = "Импорт_из_RabbitMQ_ЕРП";


НЕ_ЗАГРУЖАТЬ = 1;
СОЗДАТЬ = 2;
ОБНОВИТЬ = 3;
ОТМЕНИТЬ_ПРОВЕДЕНИЕ = 4;




