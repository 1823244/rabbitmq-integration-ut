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
	
	Если НЕ НРег(СтруктураОбъекта.type) = НРег("документ.передачатоваровмеждуорганизациями") Тогда
		Возврат Неопределено;
	КонецЕсли;

	ИмяСобытияЖР = "Импорт_из_RabbitMQ_ЕРП";

	id = СтруктураОбъекта.identification;
	деф = СтруктураОбъекта.definition;
    ВидОбъекта = "ПриобретениеТоваровУслуг";

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
	
	ОбъектДанных.Организация = ксп_ИмпортСлужебный.НайтиОрганизацию(деф.ОрганизацияПолучатель, мВнешняяСистема);
	
	ОбъектДанных.Грузоотправитель = ксп_ИмпортСлужебный.НайтиКонтрагента(деф.Грузоотправитель, мВнешняяСистема);
	
	ОбъектДанных.Контрагент = ксп_ИмпортСлужебный.НайтиКонтрагента(деф.Контрагент, мВнешняяСистема);
	
	ОбъектДанных.Подразделение = ксп_ИмпортСлужебный.НайтиПодразделение(деф.Подразделение, мВнешняяСистема);
	
	ОбъектДанных.СуммаВзаиморасчетов = деф.СуммаВзаиморасчетов;
	
	ОбъектДанных.СуммаДокумента = деф.СуммаДокумента;
	
	ОбъектДанных.НомерВходящегоДокумента = деф.НомерВходящегоДокумента;
	
	ОбъектДанных.ДатаВходящегоДокумента = деф.ДатаВходящегоДокумента;
	
	ОбъектДанных.ГруппаФинансовогоУчета = ксп_ИмпортСлужебный.НайтиГруппуФинансовогоУчета(деф.ГруппаФинансовогоУчета, мВнешняяСистема);
	
	ОбъектДанных.ДоговорПокупки = ксп_ИмпортСлужебный.НайтиДоговор(деф.Договор, мВнешняяСистема);
	
	ОбъектДанных.КурсЧислитель = деф.КурсЧислитель;
	
	ОбъектДанных.КурсЗнаменатель = деф.КурсЗнаменатель;
		
	ОбъектДанных.НаименованиеВходящегоДокумента = деф.НаименованиеВходящегоДокумента;

	
	НаправлениеДеятельностиГУИД = ""; 
	Если деф.НаправлениеДеятельности.Свойство("Ref", НаправлениеДеятельностиГУИД) Тогда
		ОбъектДанных.НаправлениеДеятельности = Справочники.НаправленияДеятельности.ПолучитьСсылку(Новый УникальныйИдентификатор(НаправлениеДеятельностиГУИД));
	КонецЕсли;

	ОбъектДанных.ОплатаВВалюте = деф.ОплатаВВалюте;
	
	
	
	
	////Реквизит	Тип	Вид
	ОбъектДанных.АдресДоставки = деф.АдресДоставки;
		
	Если ЗначениеЗаполнено(ОбъектДанных.ДисконтнаяКарта) Тогда
		ОбъектДанных.ВладелецДисконтнойКарты = ОбъектДанных.ДисконтнаяКарта.ВладелецКарты;
	КонецЕсли;
	
	
	ОбъектДанных.ЦенаВключаетНДС = деф.ЦенаВключаетНДС;  
	
	
	_знч = "";
	ЕстьЗначение = деф.ХозяйственныеОперации.свойство("Значение",_знч);
	Если ЕстьЗначение Тогда
		ОбъектДанных.ХозяйственнаяОперация = деф.ХозяйственныеОперации.Значение;
	Иначе
		ОбъектДанных.ХозяйственнаяОперация = Неопределено;
	КонецЕсли;
	
	_знч = "";
	ЕстьЗначение = деф.НалогообложениеНДС.свойство("Значение",_знч);
	Если ЕстьЗначение Тогда
		ОбъектДанных.НалогообложениеНДС = деф.НалогообложениеНДС.Значение;
	Иначе
		ОбъектДанных.НалогообложениеНДС = Неопределено;
	КонецЕсли;
	
	_знч = "";
	ЕстьЗначение = деф.ФормаОплаты.свойство("Значение",_знч);
	Если ЕстьЗначение Тогда
		ОбъектДанных.ФормаОплаты = деф.ФормаОплаты.Значение;
	Иначе
		ОбъектДанных.ФормаОплаты = Неопределено;
	КонецЕсли;


		
	ПользовательГУИД = ""; 
	Если деф.Автор.Свойство("Ref", ПользовательГУИД) Тогда
		ОбъектДанных.Ответственный = Справочники.Пользователи.ПолучитьСсылку(Новый УникальныйИдентификатор(ПользовательГУИД));
	КонецЕсли;
	
			
	//---------------------------------------------ТЧ ТОВАРЫ
	
	ОбъектДанных.Товары.Очистить();

	Для счТовары = 0 По деф.ТЧТовары.Количество()-1 Цикл
		стрк = деф.ТЧТовары[счТовары];
		НовСтр = ОбъектДанных.Товары.Добавить();
		
			
		НовСтр.Количество = стрк.Количество;
		НовСтр.КоличествоУпаковок = стрк.КоличествоУпаковок;
		
		
		НовСтр.ИдентификаторСтроки = стрк.ИдентификаторСтроки;
		
		НовСтр.Номенклатура = ксп_ИмпортСлужебный.НайтиНоменклатуру(стрк.Номенклатура);		
		
		НовСтр.СтавкаНДС = ксп_ИмпортСлужебный.ОпределитьСтавкуНДСПоСправочникуЕРП(стрк.СтавкаНДС);
		
		НовСтр.СуммаНДС = стрк.СуммаНДС;
		НовСтр.Сумма = стрк.Сумма;
		НовСтр.СуммаСНДС = стрк.СуммаСНДС;
		
		
		НовСтр.Характеристика = ксп_ИмпортСлужебный.НайтиХарактеристику(стрк.Характеристика);
	
		НовСтр.Цена = стрк.Цена;
		
		НовСтр.КоличествоПоРНПТ = стрк.КоличествоПоРНПТ;
		
		НовСтр.СуммаВзаиморасчетов = стрк.СуммаВзаиморасчетов;
		
		НовСтр.СуммаНДСВзаиморасчетов = стрк.СуммаНДСВзаиморасчетов;
		
		НовСтр.СтатусУказанияСерий = стрк.СтатусУказанияСерий;
		
		НовСтр.Подразделение = ксп_ИмпортСлужебный.НайтиПодразделение(стрк.Подразделение, мВнешняяСистема);
		
		НовСтр.АналитикаУчетаНомеклатуры = ксп_ИмпортСлужебный.НайтиАналитикуУчетаНоменклатуры(стрк.АналитикаУчетаНоменклатуры, мВнешняяСистема);
		
		НовСтр.СписатьРасходы = стрк.СписатьРасходы;
		
		
		
		
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

