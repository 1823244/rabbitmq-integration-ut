﻿Перем НЕ_ЗАГРУЖАТЬ;
Перем СОЗДАТЬ;
Перем ОБНОВИТЬ;
Перем ОТМЕНИТЬ_ПРОВЕДЕНИЕ;

Перем мЛоггер;
Перем мИдВызова;

Перем мВнешняяСистема;
Перем ИмяСобытияЖР;

Перем СобиратьНенайденныхКонтрагентов Экспорт;
Перем НеНайденныеКонтрагентыМассив;


#Область ПодключениеОбработкиКБСП

Функция СведенияОВнешнейОбработке() Экспорт
	
	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке();
	
	ПараметрыРегистрации.Вставить("Вид",ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительнаяОбработка());
	ПараметрыРегистрации.Вставить("Версия","1.1");
	//ПараметрыРегистрации.Вставить("Назначение", Новый Массив);
	ПараметрыРегистрации.Вставить("Наименование","Плагин_RabbitMQ_импорт_из_ЕРП_Документ_ПриходныйКассовыйОрдер");
	ПараметрыРегистрации.Вставить("БезопасныйРежим", Ложь);
	ПараметрыРегистрации.Вставить("Информация","Плагин_RabbitMQ_импорт_из_ЕРП_Документ_ПриходныйКассовыйОрдер");
	ПараметрыРегистрации.Вставить("ВерсияБСП", "3.1.5.180");
	//ПараметрыРегистрации.Вставить("ОпределитьНастройкиФормы", Ложь);
	
	ТипКоманды = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы();
	ДобавитьКоманду(ПараметрыРегистрации.Команды, 
		"Открыть форму : Плагин_RabbitMQ_импорт_из_ЕРП_Документ_ПриходныйКассовыйОрдер",
		"Плагин_RabbitMQ_импорт_из_ЕРП_Документ_ПриходныйКассовыйОрдер",
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
	
	//мЛоггер = мис_ЛоггерСервер.getLogger(мИдВызова, "Импорт документов из ЕРП: ПриходныйКассовыйОрдер");
	
	Попытка
		
		Если НЕ СтруктураОбъекта.Свойство("type") Тогда // на случай, если передадут пустой объект
			//мЛоггер.ерр("Неверный тип входящего объекта. сообщение пропущено.");
			Возврат Неопределено;
		КонецЕсли;
		
		Если НЕ НРег(СтруктураОбъекта.type) = НРег("документ.ПриходныйКассовыйОрдер") Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		id = СтруктураОбъекта.identification;
		деф = СтруктураОбъекта.definition;
		
		Рез = СоздатьОбновитьДокумент(СтруктураОбъекта);
		
				
		Попытка
			ксп_ЭкспортСлужебный.ВыполнитьЭкспорт_ГуидовКонтрагентов(НеНайденныеКонтрагентыМассив);
			Сообщить("Выполнен экспорт ненайденных контрагентов - " + Строка(НеНайденныеКонтрагентыМассив.Количество()) + " позиций");
		Исключение
			т = "Ошибка экспорта ненайденных контрагентов в УПП. Подробности: "+ОписаниеОшибки();
			Сообщить(т);
			ЗаписьЖурналаРегистрации(ИмяСобытияЖР, УровеньЖурналаРегистрации.Предупреждение,,,т);
			//мЛоггер.ерр(т);
		КонецПопытки;
		
		Возврат Рез;
		
	Исключение
		
		ЗаписьЖурналаРегистрации(ИмяСобытияЖР, УровеньЖурналаРегистрации.Ошибка,,,
		"Импорт из ЕРП. Плагин: Импорт Документ.ПриходныйКассовыйОрдер. Подробности: "+ОписаниеОшибки());
		ВызватьИсключение;// для помещения в retry
		
	КонецПопытки;
КонецФункции

Функция СоздатьОбновитьДокумент(СтруктураОбъекта) Экспорт
	
	id = СтруктураОбъекта.identification;
	деф = СтруктураОбъекта.definition;   
	
	ПустойДокумент = Документы.ПриходныйКассовыйОрдер.ПустаяСсылка();
	
	ДокументИзУТ = "ПриходныйКассовыйОрдер (ЕРП) № " + деф.Number + " от " + строка(деф.Date);
	
	УИД = Новый УникальныйИдентификатор(id.Ref);
	СуществующийДокСсылка = Документы.ПриходныйКассовыйОрдер.ПолучитьСсылку(УИД);
	
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
			"Объект не загружен! Ошибка блокировки документа для " + ДокументИзУТ+ ". Подробности: " + т);
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
	КонецЕсли;
	
	Рез = Неопределено;
	
	//------------------------------------- Заполнение реквизитов
	
	Попытка
		
		Действие = ДействиеСДокументом(ЭтоНовый, СуществующийДокСсылка, деф);
		 ЗаписьЖурналаРегистрации(ИмяСобытияЖР,УровеньЖурналаРегистрации.Ошибка,,,"Действие= "+строка(Действие));
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
			ОбъектДанных = Документы.ПриходныйКассовыйОрдер.СоздатьДокумент();
			СсылкаНового = Документы.ПриходныйКассовыйОрдер.ПолучитьСсылку(УИД);
			ОбъектДанных.УстановитьСсылкуНового(СсылкаНового);
		Иначе 
			ОтменитьТранзакцию();
			Возврат ПустойДокумент;
		КонецЕсли;
		
		ПредставлениеОбъекта = Строка(ОбъектДанных);
		
		ЗаполнитьРеквизиты(СтруктураОбъекта, ОбъектДанных);
		
		ОбъектДанных.ОбменДанными.Загрузка = Ложь;
		
		Если ОбъектДанных.Проведен Тогда
			ОбъектДанных.Записать(РежимЗаписиДокумента.ОтменаПроведения);
		Иначе 
			ОбъектДанных.Записать(РежимЗаписиДокумента.Запись);
		КонецЕсли; 
		
		jsonText = "";
		ксп_ИмпортСлужебный.Документы_ПослеИмпорта_01(ОбъектДанных, мВнешняяСистема, СтруктураОбъекта, jsonText, ЭтотОбъект);
		ксп_ИмпортСлужебный.Документы_ПослеИмпорта_02(ОбъектДанных, мВнешняяСистема, СтруктураОбъекта, jsonText, ЭтотОбъект);
		ксп_ИмпортСлужебный.Документы_ПослеИмпорта_03(ОбъектДанных, мВнешняяСистема, СтруктураОбъекта, jsonText, ЭтотОбъект);
		ксп_ИмпортСлужебный.Документы_ПослеИмпорта_04(ОбъектДанных, мВнешняяСистема, СтруктураОбъекта, jsonText, ЭтотОбъект);
		ксп_ИмпортСлужебный.Документы_ПослеИмпорта_05(ОбъектДанных, мВнешняяСистема, СтруктураОбъекта, jsonText, ЭтотОбъект);
		
		#Область КодИзКД2
		//ЕНС вместо этого надо добавить запись в РС "РеестрДокументов"
		//Параметры.МассивДокументовДляОтраженияВРеестреДокументов.Добавить(ОбъектДанных.Ссылка);	
		//код%
		
		// ЕНС - это код из конвертации
		//Для Каждого ТекДокСсылка Из Параметры["МассивДокументовДляОтраженияВРеестреДокументов"] Цикл
		//	
		//	ТаблицыДанных = ПроведениеДокументов.ДанныеДокументаДляПроведения(ТекДокСсылка, "РеестрДокументов");
		//	РегистрыСведений.РеестрДокументов.ЗаписатьДанные(ТаблицыДанных, ТекДокСсылка,  Неопределено, Ложь);
		//	
		//КонецЦикла;   
		
		// ЕНС. Новый код для обмена через Рэббит
		ТаблицыДанных = ПроведениеДокументов.ДанныеДокументаДляПроведения(ОбъектДанных.Ссылка, "РеестрДокументов");
		РегистрыСведений.РеестрДокументов.ЗаписатьДанные(ТаблицыДанных, ОбъектДанных.Ссылка,  Неопределено, Ложь);
		
		#КонецОбласти
		
		ЗафиксироватьТранзакцию();
		
		ЗаписьЖурналаРегистрации(ИмяСобытияЖР, УровеньЖурналаРегистрации.Информация,,,"Записан Документ : "+строка(ОбъектДанных)+". Исходный док. УТ "+строка(ДокументИзУТ));
		
		Рез = ОбъектДанных.ССылка;
		
	Исключение
		
		т = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(ИмяСобытияЖР,УровеньЖурналаРегистрации.Ошибка,,,
		"Объект не загружен! Ошибка в процессе загрузки документа " + ДокументИзУТ + ". Подробности: " + т);
		Если ТранзакцияАктивна() Тогда
			ОтменитьТранзакцию();
		КонецЕсли;
		ВызватьИсключение; //отправляем в retry-очередь
		
	КонецПопытки;
	
	Возврат Рез;
	
КонецФункции

// Заполняет реквизиты объекта и пишет сопутствующие данные. Должна вызываться в транзакции.
Функция ЗаполнитьРеквизиты(СтруктураОбъекта, ОбъектДанных, jsonText = "") Экспорт
	
	ЗаполнитьРеквизитыШапки(СтруктураОбъекта, ОбъектДанных, jsonText);
	ЗаполнитьРеквизитыТЧ_РасшифровкаПлатежа(СтруктураОбъекта, ОбъектДанных, jsonText);
	
	// Дальше - код из правил конвертации	

	Для каждого СтрокаТЧ Из ОбъектДанных.РасшифровкаПлатежа Цикл
		
		КурсИКратность = ДенежныеСредстваСервер.КурсЧислительИКурсЗнаменательВзаиморасчетов(
			ОбъектДанных.Валюта, СтрокаТЧ.ВалютаВзаиморасчетов, Константы.ВалютаРегламентированногоУчета.Получить(), ОбъектДанных.Дата);
		СтрокаТЧ.КурсЧислительВзаиморасчетов = КурсИКратность.КурсЧислитель;
		СтрокаТЧ.КурсЗнаменательВзаиморасчетов = КурсИКратность.КурсЗнаменатель;
		
		Если ОбъектДанных.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПогашениеЗаймаСотрудником Тогда
			СтрокаТЧ.ТипСуммыКредитаДепозита = Перечисления.ТипыСуммГрафикаКредитовИДепозитов.ОсновнойДолг;
		КонецЕсли;
		
	КонецЦикла;

	Если Не ЗначениеЗаполнено(ОбъектДанных.СтатьяДвиженияДенежныхСредств) И ОбъектДанных.РасшифровкаПлатежа.Количество() > 0 Тогда
		ОбъектДанных.СтатьяДвиженияДенежныхСредств = ОбъектДанных.РасшифровкаПлатежа[0].СтатьяДвиженияДенежныхСредств;
	КонецЕсли;

		
КонецФункции

Функция ЗаполнитьРеквизитыШапки(СтруктураОбъекта, ОбъектДанных, jsonText = "")
	id = СтруктураОбъекта.identification;
	деф = СтруктураОбъекта.definition;

		
	ОбъектДанных.Номер = деф.Number;
	ОбъектДанных.Дата = деф.Date;
	ОбъектДанных.ПометкаУдаления = деф.DeletionMark;



//	ОбъектДанных.Автор = ксп_ИмпортСлужебный.НайтиАвтор(деф.Автор);

	

	НомерСчета="";
	ЕстьАтрибут = деф.БанковскийСчет.свойство("НомерСчета",НомерСчета);
	Если ЕстьАтрибут Тогда
		БИК = деф.БанковскийСчет.БИК;
		бс = ксп_ИмпортСлужебный.НайтиБанковскийСчет(НомерСчета, БИК);
		ОбъектДанных.БанковскийСчет = бс;
	Иначе
		ОбъектДанных.БанковскийСчет = Неопределено;
	КонецЕсли;
	
	
	ОбъектДанных.Валюта = ксп_ИмпортСлужебный.НайтиВалютуИзУзла(деф.Валюта);
	ОбъектДанных.Валюта = ксп_ИмпортСлужебный.НайтиВалютуИзУзла(деф.ВалютаКонвертации);
	

	ОбъектДанных.ВТомЧислеНДС = деф.ВТомЧислеНДС;

	//гуид="";
	//ЕстьАтрибут = деф.ГлавныйБухгалтер.свойство("Ref",гуид);
	//Если ЕстьАтрибут Тогда
	//	ОбъектДанных.ГлавныйБухгалтер = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( деф.ГлавныйБухгалтер.Ref ) );
	//Иначе
	//	ОбъектДанных.ГлавныйБухгалтер = Неопределено;
	//КонецЕсли;
	//// на случай, если есть метод поиска ссылки:
	//ОбъектДанных.ГлавныйБухгалтер = ксп_ИмпортСлужебный.НайтиГлавныйБухгалтер(деф.ГлавныйБухгалтер);

	//гуид="";
	//ЕстьАтрибут = деф.ГруппаФинансовогоУчета.свойство("Ref",гуид);
	//Если ЕстьАтрибут Тогда
	//	ОбъектДанных.ГруппаФинансовогоУчета = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( деф.ГруппаФинансовогоУчета.Ref ) );
	//Иначе
	//	ОбъектДанных.ГруппаФинансовогоУчета = Неопределено;
	//КонецЕсли;
	//// на случай, если есть метод поиска ссылки:
	//ОбъектДанных.ГруппаФинансовогоУчета = ксп_ИмпортСлужебный.НайтиГруппаФинансовогоУчета(деф.ГруппаФинансовогоУчета);

	//гуид="";
	//ЕстьАтрибут = деф.ДоверенностьВыданная.свойство("Ref",гуид);
	//Если ЕстьАтрибут Тогда
	//	ОбъектДанных.ДоверенностьВыданная = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( деф.ДоверенностьВыданная.Ref ) );
	//Иначе
	//	ОбъектДанных.ДоверенностьВыданная = Неопределено;
	//КонецЕсли;
	//// на случай, если есть метод поиска ссылки:
	//ОбъектДанных.ДоверенностьВыданная = ксп_ИмпортСлужебный.НайтиДоверенностьВыданная(деф.ДоверенностьВыданная);

	ОбъектДанных.Договор = ксп_ИмпортСлужебный.НайтиДоговор(деф.Договор, деф.Контрагент);

	//гуид="";
	//ЕстьАтрибут = деф.ДокументОснование.свойство("Ref",гуид);
	//Если ЕстьАтрибут Тогда
	//	ОбъектДанных.ДокументОснование = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( деф.ДокументОснование.Ref ) );
	//Иначе
	//	ОбъектДанных.ДокументОснование = Неопределено;
	//КонецЕсли;
	//// на случай, если есть метод поиска ссылки:
	//ОбъектДанных.ДокументОснование = ксп_ИмпортСлужебный.НайтиДокументОснование(деф.ДокументОснование);

	ОбъектДанных.ИдентификаторДокумента = деф.ИдентификаторДокумента;

	ОбъектДанных.Исправление = деф.Исправление;

	гуид="";
	ЕстьАтрибут = деф.ИсправляемыйДокумент.свойство("Ref",гуид);
	Если ЕстьАтрибут Тогда
		ОбъектДанных.ИсправляемыйДокумент = Документы.ПриходныйКассовыйОрдер.ПолучитьСсылку( Новый УникальныйИдентификатор( гуид ) );
	Иначе
		ОбъектДанных.ИсправляемыйДокумент = Неопределено;
	КонецЕсли;
	
	гуид="";
	ЕстьАтрибут = деф.Касса.свойство("Ref",гуид);
	Если ЕстьАтрибут Тогда
		ОбъектДанных.Касса = Справочники.Кассы.ПолучитьСсылку( Новый УникальныйИдентификатор( деф.Касса.Ref ) );
	Иначе
		ОбъектДанных.Касса = Неопределено;
	КонецЕсли;

	// НЕ ПЕРЕНОСИТСЯ ИЗ УПП, поэтому из ЕРП тоже не будем
	//гуид="";
	//ЕстьАтрибут = деф.КассаККМ.свойство("Ref",гуид);
	//Если ЕстьАтрибут Тогда
	//	ОбъектДанных.КассаККМ = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( деф.КассаККМ.Ref ) );
	//Иначе
	//	ОбъектДанных.КассаККМ = Неопределено;
	//КонецЕсли;
	//// на случай, если есть метод поиска ссылки:
	//ОбъектДанных.КассаККМ = ксп_ИмпортСлужебный.НайтиКассаККМ(деф.КассаККМ);

	//гуид="";
	//ЕстьАтрибут = деф.КассаОтправитель.свойство("Ref",гуид);
	//Если ЕстьАтрибут Тогда
	//	ОбъектДанных.КассаОтправитель = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( деф.КассаОтправитель.Ref ) );
	//Иначе
	//	ОбъектДанных.КассаОтправитель = Неопределено;
	//КонецЕсли;
	//// на случай, если есть метод поиска ссылки:
	//ОбъектДанных.КассаОтправитель = ксп_ИмпортСлужебный.НайтиКассаОтправитель(деф.КассаОтправитель);

	//гуид="";
	//ЕстьАтрибут = деф.Кассир.свойство("Ref",гуид);
	//Если ЕстьАтрибут Тогда
	//	ОбъектДанных.Кассир = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( деф.Кассир.Ref ) );
	//Иначе
	//	ОбъектДанных.Кассир = Неопределено;
	//КонецЕсли;
	//// на случай, если есть метод поиска ссылки:
	//ОбъектДанных.Кассир = ксп_ИмпортСлужебный.НайтиКассир(деф.Кассир);

	ОбъектДанных.Комментарий = деф.Комментарий;

	ОбъектДанных.Контрагент = ксп_ИмпортСлужебный.НайтиКонтрагента(деф.Контрагент, мВнешняяСистема);

	ОбъектДанных.КратностьКурсаКонвертации = деф.КратностьКурсаКонвертации;

	ОбъектДанных.КурсКонвертации = деф.КурсКонвертации;

	_знч = "";
	ЕстьЗначение = деф.НалогообложениеНДС.свойство("Значение",_знч);
	Если ЕстьЗначение Тогда
		ОбъектДанных.НалогообложениеНДС = ксп_ИмпортСлужебный.НайтиЗначениеПеречисления("ТипыНалогообложенияНДС", _знч);
	Иначе
		ОбъектДанных.НалогообложениеНДС = Неопределено;
	КонецЕсли;

	//гуид="";
	//ЕстьАтрибут = деф.НаправлениеДеятельности.свойство("Ref",гуид);
	//Если ЕстьАтрибут Тогда
	//	ОбъектДанных.НаправлениеДеятельности = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( деф.НаправлениеДеятельности.Ref ) );
	//Иначе
	//	ОбъектДанных.НаправлениеДеятельности = Неопределено;
	//КонецЕсли;
	//// на случай, если есть метод поиска ссылки:
	//ОбъектДанных.НаправлениеДеятельности = ксп_ИмпортСлужебный.НайтиНаправлениеДеятельности(деф.НаправлениеДеятельности);

	//гуид="";
	//ЕстьАтрибут = деф.ОбъектРасчетов.свойство("Ref",гуид);
	//Если ЕстьАтрибут Тогда
	//	ОбъектДанных.ОбъектРасчетов = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( деф.ОбъектРасчетов.Ref ) );
	//Иначе
	//	ОбъектДанных.ОбъектРасчетов = Неопределено;
	//КонецЕсли;
	//// на случай, если есть метод поиска ссылки:
	//ОбъектДанных.ОбъектРасчетов = ксп_ИмпортСлужебный.НайтиОбъектРасчетов(деф.ОбъектРасчетов);
	ОбъектДанных.ОбъектРасчетов = ОбъектДанных.Договор;

	ОбъектДанных.Организация = ксп_ИмпортСлужебный.НайтиОрганизацию(деф.Организация, мВнешняяСистема);

	ОбъектДанных.Основание = деф.Основание;

	ОбъектДанных.Партнер = ОбъектДанных.Контрагент.Партнер;

	//гуид="";
	//ЕстьАтрибут = деф.ПодотчетноеЛицо.свойство("Ref",гуид);
	//Если ЕстьАтрибут Тогда
	//	ОбъектДанных.ПодотчетноеЛицо = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( деф.ПодотчетноеЛицо.Ref ) );
	//Иначе
	//	ОбъектДанных.ПодотчетноеЛицо = Неопределено;
	//КонецЕсли;
	//// на случай, если есть метод поиска ссылки:
	//ОбъектДанных.ПодотчетноеЛицо = ксп_ИмпортСлужебный.НайтиПодотчетноеЛицо(деф.ПодотчетноеЛицо);

	гуид="";
	ЕстьАтрибут = деф.Подразделение.свойство("Ref",гуид);
	Если ЕстьАтрибут Тогда
		ОбъектДанных.Подразделение = Справочники.СтруктураПредприятия.ПолучитьСсылку( Новый УникальныйИдентификатор( гуид ) );
	Иначе
		ОбъектДанных.Подразделение = Неопределено;
	КонецЕсли;

	ОбъектДанных.Приложение = деф.Приложение;

	ОбъектДанных.ПринятоОт = деф.ПринятоОт;

	//гуид="";
	//ЕстьАтрибут = деф.РаспоряжениеНаПеремещениеДенежныхСредств.свойство("Ref",гуид);
	//Если ЕстьАтрибут Тогда
	//	ОбъектДанных.РаспоряжениеНаПеремещениеДенежныхСредств = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( деф.РаспоряжениеНаПеремещениеДенежныхСредств.Ref ) );
	//Иначе
	//	ОбъектДанных.РаспоряжениеНаПеремещениеДенежныхСредств = Неопределено;
	//КонецЕсли;
	//// на случай, если есть метод поиска ссылки:
	//ОбъектДанных.РаспоряжениеНаПеремещениеДенежныхСредств = ксп_ИмпортСлужебный.НайтиРаспоряжениеНаПеремещениеДенежныхСредств(деф.РаспоряжениеНаПеремещениеДенежныхСредств);

	//гуид="";
	//ЕстьАтрибут = деф.СтатьяДвиженияДенежныхСредств.свойство("Ref",гуид);
	//Если ЕстьАтрибут Тогда
	//	ОбъектДанных.СтатьяДвиженияДенежныхСредств = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( деф.СтатьяДвиженияДенежныхСредств.Ref ) );
	//Иначе
	//	ОбъектДанных.СтатьяДвиженияДенежныхСредств = Неопределено;
	//КонецЕсли;
	//// на случай, если есть метод поиска ссылки:
	//ОбъектДанных.СтатьяДвиженияДенежныхСредств = ксп_ИмпортСлужебный.НайтиСтатьяДвиженияДенежныхСредств(деф.СтатьяДвиженияДенежныхСредств);
	имя_="";
	Если деф.СтатьяДвиженияДенежныхСредств.свойство("ИмяПредопределенныхДанных", имя_) Тогда
		ОбъектДанных.СтатьяДвиженияДенежныхСредств = Справочники.СтатьиДвиженияДенежныхСредств[имя_];
	КонецЕсли;

	//гуид="";
	//ЕстьАтрибут = деф.СторнируемыйДокумент.свойство("Ref",гуид);
	//Если ЕстьАтрибут Тогда
	//	ОбъектДанных.СторнируемыйДокумент = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( деф.СторнируемыйДокумент.Ref ) );
	//Иначе
	//	ОбъектДанных.СторнируемыйДокумент = Неопределено;
	//КонецЕсли;
	//// на случай, если есть метод поиска ссылки:
	//ОбъектДанных.СторнируемыйДокумент = ксп_ИмпортСлужебный.НайтиСторнируемыйДокумент(деф.СторнируемыйДокумент);
	гуид="";
	ЕстьАтрибут = деф.СторнируемыйДокумент.свойство("Ref",гуид);
	Если ЕстьАтрибут Тогда
		ОбъектДанных.СторнируемыйДокумент = Документы.ПриходныйКассовыйОрдер.ПолучитьСсылку( Новый УникальныйИдентификатор( гуид ) );
	Иначе
		ОбъектДанных.СторнируемыйДокумент = Неопределено;
	КонецЕсли;
	
	ОбъектДанных.СуммаДокумента = деф.СуммаДокумента;

	ОбъектДанных.СуммаКонвертации = деф.СуммаКонвертации;

	_знч = "";
	ЕстьЗначение = деф.ХозяйственнаяОперация.свойство("Значение",_знч);
	Если ЕстьЗначение Тогда
		ОбъектДанных.ХозяйственнаяОперация = ксп_ИмпортСлужебный.НайтиЗначениеПеречисления("ХозяйственныеОперации", _знч);
	Иначе
		ОбъектДанных.ХозяйственнаяОперация = Неопределено;
	КонецЕсли;
	//// на случай, если есть метод поиска ссылки:
	//ОбъектДанных.ХозяйственнаяОперация = ксп_ИмпортСлужебный.НайтиПеречисление_ХозяйственнаяОперация(деф.ХозяйственнаяОперация);

КонецФункции 
 
Функция ЗаполнитьРеквизитыТЧ_РасшифровкаПлатежа(СтруктураОбъекта, ОбъектДанных, jsonText = "")

	id = СтруктураОбъекта.identification;
	деф = СтруктураОбъекта.definition;

	//------------------------------------------------------     ТЧ РасшифровкаПлатежа



	ОбъектДанных.РасшифровкаПлатежа.Очистить();


	Для счТовары = 0 По деф.ТЧРасшифровкаПлатежа.Количество()-1 Цикл
		стрк = деф.ТЧРасшифровкаПлатежа[счТовары];
		СтрокаТЧ = ОбъектДанных.РасшифровкаПлатежа.Добавить();


	//	гуид="";
	//	ЕстьАтрибут = стрк.АналитикаАктивовПассивов.свойство("Ref",гуид);
	//	Если ЕстьАтрибут Тогда
	//		СтрокаТЧ.АналитикаАктивовПассивов = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( стрк.АналитикаАктивовПассивов.Ref ) );
	//	Иначе
	//		СтрокаТЧ.АналитикаАктивовПассивов = Неопределено;
	//	КонецЕсли;
	//	// на случай, если есть метод поиска ссылки:
	//	СтрокаТЧ.АналитикаАктивовПассивов = ксп_ИмпортСлужебный.НайтиАналитикаАктивовПассивов(стрк.АналитикаАктивовПассивов);

	//	гуид="";
	//	ЕстьАтрибут = стрк.АналитикаДоходов.свойство("Ref",гуид);
	//	Если ЕстьАтрибут Тогда
	//		СтрокаТЧ.АналитикаДоходов = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( стрк.АналитикаДоходов.Ref ) );
	//	Иначе
	//		СтрокаТЧ.АналитикаДоходов = Неопределено;
	//	КонецЕсли;
	//	// на случай, если есть метод поиска ссылки:
	//	СтрокаТЧ.АналитикаДоходов = ксп_ИмпортСлужебный.НайтиАналитикаДоходов(стрк.АналитикаДоходов);

	//	гуид="";
	//	ЕстьАтрибут = стрк.АналитикаРасходов.свойство("Ref",гуид);
	//	Если ЕстьАтрибут Тогда
	//		СтрокаТЧ.АналитикаРасходов = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( стрк.АналитикаРасходов.Ref ) );
	//	Иначе
	//		СтрокаТЧ.АналитикаРасходов = Неопределено;
	//	КонецЕсли;
	//	// на случай, если есть метод поиска ссылки:
	//	СтрокаТЧ.АналитикаРасходов = ксп_ИмпортСлужебный.НайтиАналитикаРасходов(стрк.АналитикаРасходов);

	//	гуид="";
	//	ЕстьАтрибут = стрк.ВалютаВзаиморасчетов.свойство("Ref",гуид);
	//	Если ЕстьАтрибут Тогда
	//		СтрокаТЧ.ВалютаВзаиморасчетов = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( стрк.ВалютаВзаиморасчетов.Ref ) );
	//	Иначе
	//		СтрокаТЧ.ВалютаВзаиморасчетов = Неопределено;
	//	КонецЕсли;
	//	// на случай, если есть метод поиска ссылки:
	//	СтрокаТЧ.ВалютаВзаиморасчетов = ксп_ИмпортСлужебный.НайтиВалютаВзаиморасчетов(стрк.ВалютаВзаиморасчетов);

	//	СтрокаТЧ.ДатаПогашения = стрк.ДатаПогашения;

	//	гуид="";
	//	ЕстьАтрибут = стрк.ДоговорАренды.свойство("Ref",гуид);
	//	Если ЕстьАтрибут Тогда
	//		СтрокаТЧ.ДоговорАренды = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( стрк.ДоговорАренды.Ref ) );
	//	Иначе
	//		СтрокаТЧ.ДоговорАренды = Неопределено;
	//	КонецЕсли;
	//	// на случай, если есть метод поиска ссылки:
	//	СтрокаТЧ.ДоговорАренды = ксп_ИмпортСлужебный.НайтиДоговорАренды(стрк.ДоговорАренды);

	//	гуид="";
	//	ЕстьАтрибут = стрк.ДоговорЗаймаСотруднику.свойство("Ref",гуид);
	//	Если ЕстьАтрибут Тогда
	//		СтрокаТЧ.ДоговорЗаймаСотруднику = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( стрк.ДоговорЗаймаСотруднику.Ref ) );
	//	Иначе
	//		СтрокаТЧ.ДоговорЗаймаСотруднику = Неопределено;
	//	КонецЕсли;
	//	// на случай, если есть метод поиска ссылки:
	//	СтрокаТЧ.ДоговорЗаймаСотруднику = ксп_ИмпортСлужебный.НайтиДоговорЗаймаСотруднику(стрк.ДоговорЗаймаСотруднику);

	//	гуид="";
	//	ЕстьАтрибут = стрк.ДоговорКредитаДепозита.свойство("Ref",гуид);
	//	Если ЕстьАтрибут Тогда
	//		СтрокаТЧ.ДоговорКредитаДепозита = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( стрк.ДоговорКредитаДепозита.Ref ) );
	//	Иначе
	//		СтрокаТЧ.ДоговорКредитаДепозита = Неопределено;
	//	КонецЕсли;
	//	// на случай, если есть метод поиска ссылки:
	//	СтрокаТЧ.ДоговорКредитаДепозита = ксп_ИмпортСлужебный.НайтиДоговорКредитаДепозита(стрк.ДоговорКредитаДепозита);

	//	СтрокаТЧ.ИдентификаторСтроки = стрк.ИдентификаторСтроки;

	//	СтрокаТЧ.КурсЗнаменательВзаиморасчетов = стрк.КурсЗнаменательВзаиморасчетов;

	//	СтрокаТЧ.КурсЧислительВзаиморасчетов = стрк.КурсЧислительВзаиморасчетов;

	//	гуид="";
	//	ЕстьАтрибут = стрк.НаправлениеДеятельности.свойство("Ref",гуид);
	//	Если ЕстьАтрибут Тогда
	//		СтрокаТЧ.НаправлениеДеятельности = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( стрк.НаправлениеДеятельности.Ref ) );
	//	Иначе
	//		СтрокаТЧ.НаправлениеДеятельности = Неопределено;
	//	КонецЕсли;
	//	// на случай, если есть метод поиска ссылки:
	//	СтрокаТЧ.НаправлениеДеятельности = ксп_ИмпортСлужебный.НайтиНаправлениеДеятельности(стрк.НаправлениеДеятельности);

	//	гуид="";
	//	ЕстьАтрибут = стрк.НастройкаСчетовУчета.свойство("Ref",гуид);
	//	Если ЕстьАтрибут Тогда
	//		СтрокаТЧ.НастройкаСчетовУчета = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( стрк.НастройкаСчетовУчета.Ref ) );
	//	Иначе
	//		СтрокаТЧ.НастройкаСчетовУчета = Неопределено;
	//	КонецЕсли;
	//	// на случай, если есть метод поиска ссылки:
	//	СтрокаТЧ.НастройкаСчетовУчета = ксп_ИмпортСлужебный.НайтиНастройкаСчетовУчета(стрк.НастройкаСчетовУчета);

	//	гуид="";
	//	ЕстьАтрибут = стрк.ОбъектРасчетов.свойство("Ref",гуид);
	//	Если ЕстьАтрибут Тогда
	//		СтрокаТЧ.ОбъектРасчетов = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( стрк.ОбъектРасчетов.Ref ) );
	//	Иначе
	//		СтрокаТЧ.ОбъектРасчетов = Неопределено;
	//	КонецЕсли;
	//	// на случай, если есть метод поиска ссылки:
	//	СтрокаТЧ.ОбъектРасчетов = ксп_ИмпортСлужебный.НайтиОбъектРасчетов(стрк.ОбъектРасчетов);

	//	гуид="";
	//	ЕстьАтрибут = стрк.Организация.свойство("Ref",гуид);
	//	Если ЕстьАтрибут Тогда
	//		СтрокаТЧ.Организация = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( стрк.Организация.Ref ) );
	//	Иначе
	//		СтрокаТЧ.Организация = Неопределено;
	//	КонецЕсли;
	//	// на случай, если есть метод поиска ссылки:
	//	СтрокаТЧ.Организация = ксп_ИмпортСлужебный.НайтиОрганизация(стрк.Организация);

	//	гуид="";
	//	ЕстьАтрибут = стрк.ОснованиеПлатежа.свойство("Ref",гуид);
	//	Если ЕстьАтрибут Тогда
	//		СтрокаТЧ.ОснованиеПлатежа = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( стрк.ОснованиеПлатежа.Ref ) );
	//	Иначе
	//		СтрокаТЧ.ОснованиеПлатежа = Неопределено;
	//	КонецЕсли;
	//	// на случай, если есть метод поиска ссылки:
	//	СтрокаТЧ.ОснованиеПлатежа = ксп_ИмпортСлужебный.НайтиОснованиеПлатежа(стрк.ОснованиеПлатежа);

	//	гуид="";
	//	ЕстьАтрибут = стрк.Партнер.свойство("Ref",гуид);
	//	Если ЕстьАтрибут Тогда
	//		СтрокаТЧ.Партнер = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( стрк.Партнер.Ref ) );
	//	Иначе
	//		СтрокаТЧ.Партнер = Неопределено;
	//	КонецЕсли;
	//	// на случай, если есть метод поиска ссылки:
	//	СтрокаТЧ.Партнер = ксп_ИмпортСлужебный.НайтиПартнер(стрк.Партнер);

	//	гуид="";
	//	ЕстьАтрибут = стрк.Подразделение.свойство("Ref",гуид);
	//	Если ЕстьАтрибут Тогда
	//		СтрокаТЧ.Подразделение = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( стрк.Подразделение.Ref ) );
	//	Иначе
	//		СтрокаТЧ.Подразделение = Неопределено;
	//	КонецЕсли;
	//	// на случай, если есть метод поиска ссылки:
	//	СтрокаТЧ.Подразделение = ксп_ИмпортСлужебный.НайтиПодразделение(стрк.Подразделение);

	//	гуид="";
	//	ЕстьАтрибут = стрк.РасчетныйДокументПоАренде.свойство("Ref",гуид);
	//	Если ЕстьАтрибут Тогда
	//		СтрокаТЧ.РасчетныйДокументПоАренде = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( стрк.РасчетныйДокументПоАренде.Ref ) );
	//	Иначе
	//		СтрокаТЧ.РасчетныйДокументПоАренде = Неопределено;
	//	КонецЕсли;
	//	// на случай, если есть метод поиска ссылки:
	//	СтрокаТЧ.РасчетныйДокументПоАренде = ксп_ИмпортСлужебный.НайтиРасчетныйДокументПоАренде(стрк.РасчетныйДокументПоАренде);

	//	гуид="";
	//	ЕстьАтрибут = стрк.СтавкаНДС.свойство("Ref",гуид);
	//	Если ЕстьАтрибут Тогда
	//		СтрокаТЧ.СтавкаНДС = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( стрк.СтавкаНДС.Ref ) );
	//	Иначе
	//		СтрокаТЧ.СтавкаНДС = Неопределено;
	//	КонецЕсли;
	//	// на случай, если есть метод поиска ссылки:
	//	СтрокаТЧ.СтавкаНДС = ксп_ИмпортСлужебный.НайтиСтавкаНДС(стрк.СтавкаНДС);

	//	гуид="";
	//	ЕстьАтрибут = стрк.СтатьяДвиженияДенежныхСредств.свойство("Ref",гуид);
	//	Если ЕстьАтрибут Тогда
	//		СтрокаТЧ.СтатьяДвиженияДенежныхСредств = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( стрк.СтатьяДвиженияДенежныхСредств.Ref ) );
	//	Иначе
	//		СтрокаТЧ.СтатьяДвиженияДенежныхСредств = Неопределено;
	//	КонецЕсли;
	//	// на случай, если есть метод поиска ссылки:
	//	СтрокаТЧ.СтатьяДвиженияДенежныхСредств = ксп_ИмпортСлужебный.НайтиСтатьяДвиженияДенежныхСредств(стрк.СтатьяДвиженияДенежныхСредств);

	//	гуид="";
	//	ЕстьАтрибут = стрк.СтатьяДоходов.свойство("Ref",гуид);
	//	Если ЕстьАтрибут Тогда
	//		СтрокаТЧ.СтатьяДоходов = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( стрк.СтатьяДоходов.Ref ) );
	//	Иначе
	//		СтрокаТЧ.СтатьяДоходов = Неопределено;
	//	КонецЕсли;
	//	// на случай, если есть метод поиска ссылки:
	//	СтрокаТЧ.СтатьяДоходов = ксп_ИмпортСлужебный.НайтиСтатьяДоходов(стрк.СтатьяДоходов);

	//	СтрокаТЧ.Сумма = стрк.Сумма;

	//	СтрокаТЧ.СуммаВзаиморасчетов = стрк.СуммаВзаиморасчетов;

	//	СтрокаТЧ.СуммаНДС = стрк.СуммаНДС;

	//	_знч = "";
	//	ЕстьЗначение = стрк.ТипПлатежаПоАренде.свойство("Значение",_знч);
	//	Если ЕстьЗначение Тогда
	//		СтрокаТЧ.ТипПлатежаПоАренде = стрк.ТипПлатежаПоАренде.Значение;
	//	Иначе
	//		СтрокаТЧ.ТипПлатежаПоАренде = Неопределено;
	//	КонецЕсли;
	//	// на случай, если есть метод поиска ссылки:
	//	СтрокаТЧ.ТипПлатежаПоАренде = ксп_ИмпортСлужебный.НайтиПеречисление_ТипПлатежаПоАренде(стрк.ТипПлатежаПоАренде);

	//	_знч = "";
	//	ЕстьЗначение = стрк.ТипСуммыКредитаДепозита.свойство("Значение",_знч);
	//	Если ЕстьЗначение Тогда
	//		СтрокаТЧ.ТипСуммыКредитаДепозита = стрк.ТипСуммыКредитаДепозита.Значение;
	//	Иначе
	//		СтрокаТЧ.ТипСуммыКредитаДепозита = Неопределено;
	//	КонецЕсли;
	//	// на случай, если есть метод поиска ссылки:
	//	СтрокаТЧ.ТипСуммыКредитаДепозита = ксп_ИмпортСлужебный.НайтиПеречисление_ТипСуммыКредитаДепозита(стрк.ТипСуммыКредитаДепозита);

	//	гуид="";
	//	ЕстьАтрибут = стрк.УдалитьЗаказ.свойство("Ref",гуид);
	//	Если ЕстьАтрибут Тогда
	//		СтрокаТЧ.УдалитьЗаказ = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( стрк.УдалитьЗаказ.Ref ) );
	//	Иначе
	//		СтрокаТЧ.УдалитьЗаказ = Неопределено;
	//	КонецЕсли;
	//	// на случай, если есть метод поиска ссылки:
	//	СтрокаТЧ.УдалитьЗаказ = ксп_ИмпортСлужебный.НайтиУдалитьЗаказ(стрк.УдалитьЗаказ);

	КонецЦикла;


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
	мРеквизиты.Добавить("Контрагент");
	мРеквизиты.Добавить("Партнер");
	мРеквизиты.Добавить("Соглашение");
	//мРеквизиты.Добавить("Договор"); // не нужен, потому что соглашение ведется без договоров
	
	Возврат мРеквизиты;
	
КонецФункции

// Используется в  ксп_ИмпортСлужебный.ПроверитьКачествоДанных()
//
// Параметры:
//  ДокументОбъект  - ДокументСсылка - <описание параметра>
//
// Возвращаемое значение:
//  ТЗ, Колонки:
//   * ИмяТЧ
//   * ИмяКолонки
//
Функция ТабличныеЧастиДляПроверки(ДокументСсылка = Неопределено) Экспорт
	
	ТЗ = Новый ТаблицаЗначений;
	ТЗ.Колонки.Добавить("ИмяТЧ");
	ТЗ.Колонки.Добавить("ИмяКолонки");
	
	НовСтр = ТЗ.Добавить();
	НовСтр.ИмяТЧ = "Товары";
	НовСтр.ИмяКолонки = "Номенклатура";
	НовСтр = ТЗ.Добавить();
	НовСтр.ИмяТЧ = "Товары";
	НовСтр.ИмяКолонки = "Характеристика";
	
	Возврат ТЗ;
	
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
Функция НайтиСоздатьОбъектРасчетов(ДокСсылка) Экспорт
	
	
	
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

// Описание_метода
//
// Параметры:
//  Параметр1   - Тип1 -
//
Функция сетИдВызова(пИдВызова) Экспорт
	
	мИдВызова = пИдВызова;
	Возврат ЭтотОбъект;
	
КонецФункции


мВнешняяСистема = "erp";
ИмяСобытияЖР = "Импорт_из_RabbitMQ_ЕРП";


СобиратьНенайденныхКонтрагентов = Истина;
НеНайденныеКонтрагентыМассив = Новый Массив;


НЕ_ЗАГРУЖАТЬ = 1;
СОЗДАТЬ = 2;
ОБНОВИТЬ = 3;
ОТМЕНИТЬ_ПРОВЕДЕНИЕ = 4;


