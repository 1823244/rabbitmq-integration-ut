﻿Перем мВнешняяСистема;

#Область ПодключениеОбработкиКБСП

Функция СведенияОВнешнейОбработке() Экспорт

	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке();

	ПараметрыРегистрации.Вставить("Вид",ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительнаяОбработка());
	ПараметрыРегистрации.Вставить("Версия","1.2");
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


Функция ЗагрузитьОбъект(СтруктураОбъекта, jsonText = "") Экспорт
	
	Если НЕ НРег(СтруктураОбъекта.type) = НРег("документ.заказклиента") Тогда
		Возврат Неопределено;
	КонецЕсли;

	ИмяСобытияЖР = "Импорт_из_RabbitMQ_ЕРП";

	id = СтруктураОбъекта.identification;
	деф = СтруктураОбъекта.definition;
    ВидОбъекта = "ЗаказКлиента";

	//------------------------------------- работа с GUID	
	ОбъектДанных = Неопределено;
	ДанныеСсылка = Документы[ВидОбъекта].ПолучитьСсылку(Новый УникальныйИдентификатор(id.Ref));
	ПредставлениеОбъекта = Строка(ДанныеСсылка);
	ЭтоНовый = Ложь;
	Если НЕ ЗначениеЗаполнено(ДанныеСсылка.ВерсияДанных) Тогда
		ОбъектДанных = Документы[ВидОбъекта].СоздатьДокумент();
		СсылкаНового = Документы[ВидОбъекта].ПолучитьСсылку(Новый УникальныйИдентификатор(id.Ref));
		ОбъектДанных.УстановитьСсылкуНового(СсылкаНового);
		ПредставлениеОбъекта = Строка(ОбъектДанных);
		ЭтоНовый = Истина;
	КонецЕсли; 
	
	// -------------------------------------------- БЛОКИРОВКА
	Если НЕ ЭтоНовый Тогда
		Блокировка = ксп_Блокировки.СоздатьБлокировкуОдногоОбъекта(ДанныеСсылка);
	КонецЕсли;

	НачатьТранзакцию();
	
	Если НЕ ЭтоНовый Тогда
		Попытка
			Блокировка.Заблокировать();
			ОбъектДанных = ДанныеСсылка.ПолучитьОбъект();
		Исключение
			т=ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации(ИмяСобытияЖР,УровеньЖурналаРегистрации.Ошибка,,ОбъектДанных.Ссылка,
				"Объект не загружен! Ошибка блокировки объекта <"+ПредставлениеОбъекта+">. Подробности: "+т);
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
	КонецЕсли;
		
	//------------------------------------- Заполнение реквизитов
	Попытка			
		ЗаполнитьРеквизиты(ОбъектДанных, СтруктураОбъекта, jsonText);		
		ЗафиксироватьТранзакцию();          		
		Возврат ДанныеСсылка;		
	Исключение
		т=ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(ИмяСобытияЖР,УровеньЖурналаРегистрации.Ошибка,,ДанныеСсылка,
			"Объект не загружен! Ошибка в процессе загрузки объекта: <"+ПредставлениеОбъекта+">. Подробности: "+т);
		Если ТранзакцияАктивна() Тогда
			ОтменитьТранзакцию();
		КонецЕсли;
		ВызватьИсключение;
	КонецПопытки;	
			
КонецФункции

// Заполняет реквизиты объекта и пишет сопутствующие данные. Должна вызываться в транзакции.
Функция ЗаполнитьРеквизиты(ОбъектДанных, СтруктураОбъекта, jsonText = "") Экспорт

	id = СтруктураОбъекта.identification;
	деф = СтруктураОбъекта.definition;
	
	ОбъектДанных.Номер = деф.Number;
	ОбъектДанных.Дата = деф.Date;
	
	ОбъектДанных.ПометкаУдаления = деф.DeletionMark;
	
	СкладГУИД = "";
	Если деф.Склад.Свойство("Ref", СкладГУИД) Тогда
		//ОбъектДанных.Склад = Справочники.Склады.ПолучитьСсылку(Новый УникальныйИдентификатор(СкладГУИД));
		ОбъектДанных.Склад = РегистрыСведений.ксп_МэппингСправочникСклады.ПоМэппингу(СкладГУИД, мВнешняяСистема);
		// попробуем по ГУИД
		Если НЕ ЗначениеЗаполнено(ОбъектДанных.Склад) ИЛИ НЕ ЗначениеЗаполнено(ОбъектДанных.Склад.ВерсияДанных) Тогда
			ОбъектДанных.Склад = Справочники.Склады.ПолучитьСсылку(Новый УникальныйИдентификатор(СкладГУИД));
		КонецЕсли;
	КонецЕсли; 
	
	ОбъектДанных.Организация = ксп_ИмпортСлужебный.НайтиОрганизацию(деф.Организация, мВнешняяСистема);
	
	//Реквизит	Тип	Вид
	ОбъектДанных.АдресДоставки = деф.АдресДоставки;
	ОбъектДанных.АдресДоставкиЗначение = деф.АдресДоставкиЗначение;
	ОбъектДанных.АдресДоставкиЗначенияПолей = деф.АдресДоставкиЗначенияПолей;
	ОбъектДанных.АдресДоставкиПеревозчика = деф.АдресДоставкиПеревозчика;
	ОбъектДанных.АдресДоставкиПеревозчикаЗначение = деф.АдресДоставкиПеревозчикаЗначение;
	ОбъектДанных.АдресДоставкиПеревозчикаЗначенияПолей = деф.АдресДоставкиПеревозчикаЗначенияПолей;
	
	Если деф.БанковскийСчет.Свойство("НомерСчета") И деф.БанковскийСчет.Свойство("БИК") Тогда
		ОбъектДанных.БанковскийСчетОрганизации = ксп_ИмпортСлужебный.НайтиБанковскийСчетОрганизации(деф.БанковскийСчет.НомерСчета, деф.БанковскийСчет.БИК);
		Если НЕ ЗначениеЗаполнено(ОбъектДанных.БанковскийСчетОрганизации) Тогда
			БанкСчетГУИД = "";
			деф.БанковскийСчет.Свойство("Ref", БанкСчетГУИД);
			ОбъектДанных.БанковскийСчетОрганизации = Справочники.БанковскиеСчета.ПолучитьСсылку(Новый УникальныйИдентификатор(БанкСчетГУИД));
		КонецЕсли;
	КонецЕсли;
	
	Если деф.БанковскийСчетГрузоотправителя.Свойство("НомерСчета") И деф.БанковскийСчетГрузоотправителя.Свойство("БИК") Тогда
		ОбъектДанных.БанковскийСчетГрузоотправителя = ксп_ИмпортСлужебный.НайтиБанковскийСчетКонтрагента(деф.БанковскийСчетГрузоотправителя.НомерСчета, деф.БанковскийСчетГрузоотправителя.БИК);
		Если НЕ ЗначениеЗаполнено(ОбъектДанных.БанковскийСчетГрузоотправителя) Тогда
			БанкСчетГУИД = "";
			деф.БанковскийСчетГрузоотправителя.Свойство("Ref", БанкСчетГУИД);
			ОбъектДанных.БанковскийСчетГрузоотправителя = Справочники.БанковскиеСчета.ПолучитьСсылку(Новый УникальныйИдентификатор(БанкСчетГУИД));
		КонецЕсли;
	КонецЕсли;
	
	Если деф.БанковскийСчетГрузополучателя.Свойство("НомерСчета") И деф.БанковскийСчетГрузополучателя.Свойство("БИК") Тогда
		ОбъектДанных.БанковскийСчетГрузополучателя = ксп_ИмпортСлужебный.НайтиБанковскийСчетКонтрагента(деф.БанковскийСчетГрузополучателя.НомерСчета, деф.БанковскийСчетГрузополучателя.БИК);
		Если НЕ ЗначениеЗаполнено(ОбъектДанных.БанковскийСчетГрузополучателя) Тогда
			БанкСчетГУИД = "";
			деф.БанковскийСчетГрузополучателя.Свойство("Ref", БанкСчетГУИД);
			ОбъектДанных.БанковскийСчетГрузоотправителя = Справочники.БанковскиеСчета.ПолучитьСсылку(Новый УникальныйИдентификатор(БанкСчетГУИД));
		КонецЕсли;
	КонецЕсли;

	ОбъектДанных.ВернутьМногооборотнуюТару = деф.ВернутьМногооборотнуюТару;
	
	ОбъектДанных.ВремяДоставкиС = деф.ВремяДоставкиС;
	
	ОбъектДанных.ВремяДоставкиПо = деф.ВремяДоставкиПо;
	
	ОбъектДанных.Грузоотправитель = ксп_ИмпортСлужебный.НайтиКонтрагента(деф.Грузоотправитель, мВнешняяСистема);
	
	ОбъектДанных.Грузополучатель = ксп_ИмпортСлужебный.НайтиКонтрагента(деф.Грузополучатель, мВнешняяСистема);
	
	ОбъектДанных.ГруппаФинансовогоУчета = ксп_ИмпортСлужебный.НайтиГруппуФинансовогоУчета(деф.ГруппаФинансовогоУчета, мВнешняяСистема);
	
	Штрихкод = "";
	МагнитныйКод = "";
	Если деф.КартаЛояльности.Свойство("Штрихкод", Штрихкод) ИЛИ деф.КартаЛояльности.Свойство("МагнитныйКод", МагнитныйКод) Тогда
		ОбъектДанных.ДисконтнаяКарта = ксп_ИмпортСлужебный.НайтиДисконтнуюКарту(Штрихкод, МагнитныйКод);
		Если НЕ ЗначениеЗаполнено(ОбъектДанных.ДисконтнаяКарта) Тогда
			ДисконтнаяКартаГУИД = "";
			деф.КартаЛояльности.Свойство("Ref", ДисконтнаяКартаГУИД);
			ОбъектДанных.ДисконтнаяКарта = Справочники.ИнформационныеКарты.ПолучитьСсылку(Новый УникальныйИдентификатор(ДисконтнаяКартаГУИД));
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОбъектДанных.ДисконтнаяКарта) Тогда
		ОбъектДанных.ВладелецДисконтнойКарты = ОбъектДанных.ДисконтнаяКарта.ВладелецКарты;
	КонецЕсли;
	//
	//ОбъектДанных.ДатаЗаказаНаСайте = деф.ДатаПоДаннымКлиента;
	//ОбъектДанных.ЖелаемаяДатаПродажи = деф.ДатаОтгрузки;
	//Если НЕ ЗначениеЗаполнено(ОбъектДанных.ЖелаемаяДатаПродажи) Тогда
	//	ОбъектДанных.ЖелаемаяДатаПродажи = ОбъектДанных.Дата;
	//КонецЕсли;
	//
	//ОбъектДанных.ИнтернетЗаказ = ЗначениеЗаполнено(СокрЛП(деф.НомерПоДаннымКлиента));
	
	//
	
	ОбъектДанных.ДатаОтгрузки = деф.ДатаОтгрузки;
	
	ОбъектДанных.ДатаПоДаннымКлиента = деф.ДатаПоДаннымКлиента;
	
	ОбъектДанных.ДатаСогласования = деф.ДатаСогласования;
	
	ОбъектДанных.Комментарий = деф.Комментарий;
	
	ОбъектДанных.Договор =  ксп_ИмпортСлужебный.НайтиДоговор(деф.Договор);
	
	ОбъектДанных.ДополнительнаяИнформация = деф.ДополнительнаяИнформация;
	
	ОбъектДанных.ДополнительнаяИнформацияПоДоставке = деф.ДополнительнаяИнформацияПоДоставке;
	
	ОбъектДанных.ИдентификаторПлатежа = деф.ИдентификаторПлатежа;
	
	ОбъектДанных.Контрагент = ксп_ИмпортСлужебный.НайтиКонтрагент(деф.Контрагент,мВнешняяСистема);
	
	ОбъектДанных.МаксимальныйКодСтроки = деф.МаксимальныйКодСтроки;
	
	//ОбъектДанных.Менеджер = 
	
	ОбъектДанных.Назначение = ксп_ИмпортСлужебный.НайтиНазначение(деф.Назначение,мВнешняяСистема);
	
	ОбъектДанных.НазначениеПлатежа = деф.НазначениеПлатежа;
	
	ОбъектДанных.НеОтгружатьЧастями = деф.НеОтгружатьЧастями;
	
	ОбъектДанных.НомерПоДаннымКлиента = деф.НомерПоДаннымКлиента;
	
	ОбъектДанных.ОбъектРасчетов = ксп_ИмпортСлужебный.НайтиОбъектРасчетов(деф.ОбъектРасчетов, мВнешняяСистема);
	
	ОбъектДанных.ОплатаВВалюте = деф.ОплатаВВалюте;
	
	ОбъектДанных.ОсобыеУсловияПеревозки = деф.ОсобыеУсловияПеревозки;
	
	ОбъектДанных.ОсобыеУсловияПеревозкиОписание = деф.ОсобыеУсловияПеревозкиОписание;
	
	ОбъектДанных.Подразделение = ксп_ИмпортСлужебный.НайтиПодразделение(деф.Подразделение, мВнешняяСистема);
	
	ОбъектДанных.Сделка = ксп_ИмпортСлужебный.НайтиСделку(деф.Сделка, мВнешняяСистема);
	
	ОбъектДанных.СкидкиРассчитаны = деф.СкидкиРассчитаны;
	
	ОбъектДанных.Согласован = деф.Согласован;
	
	ОбъектДанных.СрокВозвратаМногооборотнойТары = деф.СрокВозвратаМногооборотнойТары;
	
	ОбъектДанных.СуммаВозвратнойТары = деф.СуммаВозвратнойТары;
	
	ОбъектДанных.СуммаДокумента = деф.СуммаДокумента;
	
	ОбъектДанных.СуммаПредоплатыОтгрузки = деф.СуммаПредоплатыОтгрузки;
	
	ОбъектДанных.ТребуетсяЗалогЗаТару = деф.ТребуетсяЗалогЗаТару;
	
	ОбъектДанных.ЦенаВключаетНДС = деф.ЦенаВключаетНДС;
	
	ОбъектДанных.ЭтапГосконтрактаЕИС = деф.ЭтапГосконтрактаЕИС;
	
	ОбъектДанных.ЭтоЗаказКакСчет = деф.ЭтоЗаказКакСчет;
	
	
	_знч = "";
	ЕстьЗначение = деф.ТипыНалогообложенияНДС.свойство("Значение",_знч);
	Если ЕстьЗначение Тогда
		ОбъектДанных.НалогообложениеНДС = деф.ТипыНалогообложенияНДС.Значение;
	Иначе
		ОбъектДанных.НалогообложениеНДС = Неопределено;
	КонецЕсли;
	
	_знч = "";
	ЕстьЗначение = деф.ПорядокРасчетов.свойство("Значение",_знч);
	Если ЕстьЗначение Тогда
		ОбъектДанных.ПорядокРасчетов = деф.ПорядокРасчетов.Значение;
	Иначе
		ОбъектДанных.ПорядокРасчетов = Неопределено;
	КонецЕсли;
	
	_знч = "";
	ЕстьЗначение = деф.СостоянияЗаполненияМногооборотнойТары.свойство("Значение",_знч);
	Если ЕстьЗначение Тогда
		ОбъектДанных.СостоянияЗаполненияМногооборотнойТары = деф.СостоянияЗаполненияМногооборотнойТары.Значение;
	Иначе
		ОбъектДанных.СостоянияЗаполненияМногооборотнойТары = Неопределено;
	КонецЕсли;
	
	_знч = "";
	ЕстьЗначение = деф.СпособыДоставки.свойство("Значение",_знч);
	Если ЕстьЗначение Тогда
		ОбъектДанных.СпособДоставки = деф.СпособыДоставки.Значение;
	Иначе
		ОбъектДанных.СпособДоставки = Неопределено;
	КонецЕсли;

	
	_знч = "";
	ЕстьЗначение = деф.УдалитьПорядокОплатыПоСоглашениям.свойство("Значение",_знч);
	Если ЕстьЗначение Тогда
		ОбъектДанных.УдалитьПорядокОплаты = деф.УдалитьПорядокОплатыПоСоглашениям.Значение;
	Иначе
		ОбъектДанных.УдалитьПорядокОплаты = Неопределено;
	КонецЕсли;

	_знч = "";
	ЕстьЗначение = деф.ФормыОплаты.свойство("Значение",_знч);
	Если ЕстьЗначение Тогда
		ОбъектДанных.ФормаОплаты = деф.ФормыОплаты.Значение;
	Иначе
		ОбъектДанных.ФормаОплаты = Неопределено;
	КонецЕсли;
	
	_знч = "";
	ЕстьЗначение = деф.ХозяйственныеОперации.свойство("Значение",_знч);
	Если ЕстьЗначение Тогда
		ОбъектДанных.ХозяйственнаяОперация = деф.ХозяйственныеОперации.Значение;
	Иначе
		ОбъектДанных.ХозяйственнаяОперация = Неопределено;
	КонецЕсли;


	
	//КонтрагентГУИД = "";
	//Если деф.Контрагент.Свойство("Ref", КонтрагентГУИД) Тогда
	//	ОбъектДанных.Контрагент = РегистрыСведений.ксп_МэппингСправочникКонтрагенты.ПоМэппингу(КонтрагентГУИД);
	//	Если НЕ ЗначениеЗаполнено(ОбъектДанных.Контрагент) ИЛИ НЕ ЗначениеЗаполнено(ОбъектДанных.Контрагент.ВерсияДанных) Тогда
	//		ОбъектДанных.Контрагент = Справочники.Контрагенты.ПолучитьСсылку(Новый УникальныйИдентификатор(КонтрагентГУИД));
	//	КонецЕсли;
	//КонецЕсли;
		
	ОбъектДанных.Магазин = РегистрыСведений.ксп_МэппингСкладМагазин.ПоМэппингу(ОбъектДанных.Склад, мВнешняяСистема);
		
	ОбъектДанных.НомерЗаказаНаСайте = деф.НомерПоДаннымКлиента;
	
	ПользовательГУИД = ""; 
	Если деф.Автор.Свойство("Ref", ПользовательГУИД) Тогда
		ОбъектДанных.Ответственный = Справочники.Пользователи.ПолучитьСсылку(Новый УникальныйИдентификатор(ПользовательГУИД));
	КонецЕсли;
	
	
	//ОбъектДанных.Отменено = деф.____;
	
	//ОбъектДанных.Продавец = деф.____;
	
	ОбъектДанных.СкидкиРассчитаны = деф.СкидкиРассчитаны;
	
	ОбъектДанных.Статус = СтатусЗаказа(деф.Статус);
	
	ОбъектДанных.СуммаДокумента = деф.СуммаДокумента;
	
	//ОбъектДанных.УдалитьБанковскийСчетОрганизации = деф.____;
	
	ОбъектДанных.УчитыватьНДС = ксп_ИмпортСлужебный.УчитыватьНДС(деф.НалогообложениеНДС);
	
	ОбъектДанных.ЦенаВключаетНДС = деф.ЦенаВключаетНДС;	
	
	
	//---------------------------------------------ТЧ ТОВАРЫ
	
	ОбъектДанных.Товары.Очистить();

	Для счТовары = 0 По деф.ТЧТовары.Количество()-1 Цикл
		стрк = деф.ТЧТовары[счТовары];
		НовСтр = ОбъектДанных.Товары.Добавить();
		
			
		НовСтр.КлючСвязи = стрк.КлючСвязи;
		НовСтр.КодСтроки = стрк.КодСтроки;
		НовСтр.Количество = стрк.Количество;
		НовСтр.КоличествоУпаковок = стрк.КоличествоУпаковок;
		
		НовСтр.ДатаОтгрузки = стрк.ДатаОтгрузки;
		
		НовСтр.ИдентификаторСтроки = стрк.ИдентификаторСтроки;
		
		НовСтр.Подразделение = ксп_ИмпортСлужебный.НайтиПодразделение(стрк.Подразделение, мВнешняяСистема);
		
		НовСтр.Обособлено = стрк.Обособлено;
		
		НовСтр.НоменклатураНабор = ксп_ИмпортСлужебный.НайтиНоменклатуру(Стрк.НоменклатураНабор, мВнешняяСистема);
		
		НовСтр.НоменклатураПартнера = ксп_ИмпортСлужебный.НайтиНоменклатуру(стрк.НоменклатураПартнера, мВнешняяСистема);
		
		НовСтр.Содержание = стрк.Содержание;
		
		НовСтр.СрокПоставки = стрк.СрокПоставки;
		
		НовСтр.СтатусУказанияСерий = стрк.СтатусУказанияСерий;
		
		
		НовСтр.Номенклатура = ксп_ИмпортСлужебный.НайтиНоменклатуру(стрк.Номенклатура);
		
		НовСтр.Отменено = стрк.Отменено;	
		
		НовСтр.ПричинаОтмены = РегистрыСведений.ксп_МэппингПричинаОтменыЗаказаКлиента.ПоМэппингу(стрк.ПричинаОтмены, мВнешняяСистема);
		
		НовСтр.ПроцентАвтоматическойСкидки = стрк.ПроцентАвтоматическойСкидки;
		НовСтр.ПроцентРучнойСкидки = стрк.ПроцентРучнойСкидки;
		
		
		НовСтр.СтавкаНДС = ксп_ИмпортСлужебный.ОпределитьСтавкуНДСПоСправочникуЕРП(стрк.СтавкаНДС);
		
		НовСтр.СуммаНДС = стрк.СуммаНДС;
		НовСтр.СуммаАвтоматическойСкидки = стрк.СуммаАвтоматическойСкидки;
		НовСтр.СуммаБонусныхБалловКСписанию = стрк.СуммаБонусныхБалловКСписанию;
		НовСтр.СуммаБонусныхБалловКСписаниюВВалюте = стрк.СуммаБонусныхБалловКСписаниюВВалюте;
		НовСтр.СуммаНачисленныхБонусныхБалловВВалюте = стрк.СуммаНачисленныхБонусныхБалловВВалюте;
		НовСтр.СуммаРучнойСкидки = стрк.СуммаРучнойСкидки;
		НовСтр.Сумма = стрк.Сумма;
		НовСтр.СуммаСНДС = стрк.СуммаСНДС;
		
		
		НовСтр.Характеристика = ксп_ИмпортСлужебный.НайтиХарактеристику(стрк.Характеристика);
	
		НовСтр.Цена = стрк.Цена;
		
		
		Упаковка = ксп_ИмпортСлужебный.НайтиЕдиницуИзмерения(стрк.Упаковка, стрк.Номенклатура);
		//упаковка может быть не указана в строке ТЧ, тогда используем единицу хранения номенклатуры
		Если НЕ ЗначениеЗаполнено(Упаковка) Тогда
			Упаковка = НовСтр.Номенклатура.ЕдиницаИзмерения;
		КонецЕсли;
		НовСтр.Упаковка = Упаковка;
		
		_знч = "";
		ЕстьЗначение = деф.ВариантыОбеспечения.свойство("Значение",_знч);
		Если ЕстьЗначение Тогда
			ОбъектДанных.ВариантОбеспечения = деф.ВариантыОбеспечения.Значение;
		Иначе
			ОбъектДанных.ВариантОбеспечения = Неопределено;
		КонецЕсли;
		
		_знч = "";
		ЕстьЗначение = деф.ВариантыОбеспечения.свойство("Значение",_знч);
		Если ЕстьЗначение Тогда
			ОбъектДанных.ВариантОбеспеченияДоИзмененияОбновлениемИБ = деф.ВариантыОбеспечения.Значение;
		Иначе
			ОбъектДанных.ВариантОбеспеченияДоИзмененияОбновлениемИБ = Неопределено;
		КонецЕсли;
		
		_знч = "";
		ЕстьЗначение = деф.ВариантОплаты.свойство("Значение",_знч);
		Если ЕстьЗначение Тогда
			ОбъектДанных.ВариантОплаты = деф.ВариантОплаты.Значение;
		Иначе
			ОбъектДанных.ВариантОплаты = Неопределено;
		КонецЕсли;
		
		_знч = "";
		ЕстьЗначение = деф.ВариантОтсчета.свойство("Значение",_знч);
		Если ЕстьЗначение Тогда
			ОбъектДанных.ВариантОтсчета = деф.ВариантОтсчета.Значение;
		Иначе
			ОбъектДанных.ВариантОтсчета = Неопределено;
		КонецЕсли;




				
	КонецЦикла;
	
	
	
	//---------------------------------------------ТЧ ЭтапыГрафикаОплаты
	
	ОбъектДанных.ЭтапыГрафикаОплаты.Очистить();

	Для счОплата = 0 По деф.ТЧЭтапыГрафикаОплаты.Количество()-1 Цикл
		стрк = деф.ТЧЭтапыГрафикаОплаты[счОплата];
		НовСтр = ОбъектДанных.ЭтапыГрафикаОплаты.Добавить();
		
		НовСтр.ДатаПлатежа = стрк.ДатаПлатежа;
		
		НовСтр.ПроцентЗалогаЗаТару = стрк.ПроцентЗалогаЗаТару;
		
		НовСтр.ПроцентПлатежа = стрк.ПроцентПлатежа;
		
		НовСтр.Сдвиг = стрк.Сдвиг;
		
		НовСтр.СуммаЗалогаЗаТару = стрк.СуммаЗалогаЗаТару;
		
		НовСтр.СуммаОтклоненияМерныхТоваров = стрк.СуммаОтклоненияМерныхТоваров;
		
		НовСтр.СуммаПлатежа = стрк.СуммаПлатежа;
						
	КонецЦикла;
	
	ОбъектДанных.СкидкиНаценки.Очистить();

	Для счСкидки = 0 По деф.ТЧСкидкиНаценки.Количество()-1 Цикл
		
		стрк = деф.ТЧСкидкиНаценки[счСкидки];
		НовСтр = ОбъектДанных.СкидкиНаценки.Добавить();
		
		НовСтр.КлючСвязи = стрк.КлючСвязи;
		
		НовСтр.НапомнитьПозже = стрк.НапомнитьПозже;
		
		НовСтр.СкидкаНаценка = ксп_ИмпортСлужебный.НайтиСкидкуНаценку(стрк.СкидкаНаценка, мВнешняяСистема);
		
		НовСтр.Сумма = стрк.Сумма;
		
	КонецЦикла;
	
	
	ОбъектДанных.НачислениеБонусныхБаллов.Очистить();

	Для счБаллы = 0 По деф.ТЧНачислениеБонусныхБаллов.Количество()-1 Цикл
		
		стрк = деф.ТЧНачислениеБонусныхБаллов[счБаллы];
		НовСтр = ОбъектДанных.НачислениеБонусныхБаллов.Добавить();
		
		НовСтр.СкидкаНаценка = ксп_ИмпортСлужебный.НайтиБонуснуюПрограммуЛояльности(стрк.БонуснаяПрограммаЛояльности, мВнешняяСистема);
		
		НовСтр.ДатаНачисления = стрк.ДатаНачисления;
		
		НовСтр.ДатаСписания = стрк.ДатаСписания;
		
		НовСтр.КлючСвязи = стрк.КлючСвязи;
		
		НовСтр.СуммаБонусныхБаллов = стрк.СумммаБонусныхБаллов;
		
	КонецЦикла;


		
	ОбъектДанных.ОбменДанными.Загрузка = Истина;
	
	ОбъектДанных.Записать();

	ксп_ИмпортСлужебный.Документы_ПослеИмпорта_01(ОбъектДанных, мВнешняяСистема, СтруктураОбъекта, jsonText, ЭтотОбъект);
	ксп_ИмпортСлужебный.Документы_ПослеИмпорта_02(ОбъектДанных, мВнешняяСистема, СтруктураОбъекта, jsonText, ЭтотОбъект);
	ксп_ИмпортСлужебный.Документы_ПослеИмпорта_03(ОбъектДанных, мВнешняяСистема, СтруктураОбъекта, jsonText, ЭтотОбъект);
	ксп_ИмпортСлужебный.Документы_ПослеИмпорта_04(ОбъектДанных, мВнешняяСистема, СтруктураОбъекта, jsonText, ЭтотОбъект);
	ксп_ИмпортСлужебный.Документы_ПослеИмпорта_05(ОбъектДанных, мВнешняяСистема, СтруктураОбъекта, jsonText, ЭтотОбъект);

КонецФункции




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

	
	
	Возврат ЗагрузитьОбъект(СтруктураОбъекта);
	
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

мВнешняяСистема = "erp";

