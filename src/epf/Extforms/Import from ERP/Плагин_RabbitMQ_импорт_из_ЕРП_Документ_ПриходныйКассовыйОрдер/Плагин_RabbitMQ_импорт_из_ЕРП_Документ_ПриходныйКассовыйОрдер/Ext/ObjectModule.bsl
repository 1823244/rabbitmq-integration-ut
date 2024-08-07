﻿
#Область СобытияДокументов
//https://wiki.elis.ru/pages/viewpage.action?pageId=362100
Перем НЕ_ЗАГРУЖАТЬ;
Перем СОЗДАТЬ;
Перем ОБНОВИТЬ;
Перем ОТМЕНИТЬ_ПРОВЕДЕНИЕ;
Перем ПОМЕТИТЬ; //добавлено 2024-07-03
#КонецОбласти


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
	ПараметрыРегистрации.Вставить("Версия","1.09");
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
	
	НоваяКоманда = ТаблицаКоманд.Добавить() ;
	НоваяКоманда.Представление = Представление ;
	НоваяКоманда.Идентификатор = Идентификатор ;
	НоваяКоманда.Использование = Использование ;
	НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение ;
	НоваяКоманда.Модификатор = Модификатор ;
	
КонецПроцедуры

#КонецОбласти


Функция ЗагрузитьОбъект(СтруктураОбъекта, мОрганизация, jsonText = "") Экспорт
	Попытка
	    мЛоггер = Вычислить("мис_ЛоггерСервер.getLogger(мИдВызова, ""Импорт документов из ЕРП: ПриходныйКассовыйОрдер"");");
	Исключение
	КонецПопытки;
	Попытка

		Если НЕ ТипЗнч(СтруктураОбъекта) = Тип("Структура") Тогда 
			//мЛоггер.ерр("Неверный тип входящего объекта. сообщение пропущено.");
			Возврат Неопределено;
		КонецЕсли;
		
		Если НЕ СтруктураОбъекта.Свойство("type") Тогда // на случай, если передадут пустой объект
			//мЛоггер.ерр("Неверный тип входящего объекта. сообщение пропущено.");
			Возврат Неопределено;
		КонецЕсли;
		
		Если НЕ НРег(СтруктураОбъекта.type) = НРег("документ.ПриходныйКассовыйОрдер") Тогда
			Возврат Неопределено;
		КонецЕсли;
		
	
		Рез = СоздатьОбновитьДокумент(СтруктураОбъекта, мОрганизация);
		
				
		Попытка
			Если НеНайденныеКонтрагентыМассив.Количество() > 0 Тогда
				ксп_ЭкспортСлужебный.ВыполнитьЭкспорт_ГуидовКонтрагентов(НеНайденныеКонтрагентыМассив);
				Сообщить("Выполнен экспорт ненайденных контрагентов - " + Строка(НеНайденныеКонтрагентыМассив.Количество()) + " позиций");
			КонецЕсли;
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

Функция СоздатьОбновитьДокумент(СтруктураОбъекта, мОрганизация) Экспорт
	
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
		
		Действие = ксп_ИмпортСлужебный.ДействиеСДокументом(ЭтоНовый, СуществующийДокСсылка, деф);
		
		Если Действие = НЕ_ЗАГРУЖАТЬ Тогда
			ОтменитьТранзакцию();                                             
			РегистрыСведений.ксп_ОтложенноеПроведение.УдалитьОтложенноеПроведение(СуществующийДокСсылка);//добавлено 2024-07-03
			Возврат СуществующийДокСсылка;
		КонецЕсли;
		
        // добавлено 2024-07-03
        Если Действие = ПОМЕТИТЬ Тогда
            ОбъектДанных = СуществующийДокСсылка.ПолучитьОбъект();
            ОбъектДанных.УстановитьПометкуУдаления(Истина);
            РегистрыСведений.ксп_ОтложенноеПроведение.УдалитьОтложенноеПроведение(СуществующийДокСсылка);//добавлено 2024-07-03
            ЗафиксироватьТранзакцию();
            Возврат СуществующийДокСсылка;
		КонецЕсли;
		
		Если Действие = ОТМЕНИТЬ_ПРОВЕДЕНИЕ Тогда
			ОбъектДанных = СуществующийДокСсылка.ПолучитьОбъект();
			ОбъектДанных.Записать(РежимЗаписиДокумента.ОтменаПроведения);
			РегистрыСведений.ксп_ОтложенноеПроведение.УдалитьОтложенноеПроведение(СуществующийДокСсылка);//добавлено 2024-07-03
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
		
		ЗаполнитьРеквизиты(СтруктураОбъекта, ОбъектДанных, мОрганизация);
		
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
		ТаблицыДанных = ПроведениеДокументов.ДанныеДокументаДляПроведения(ОбъектДанных.Ссылка, "РеестрДокументов");
		РегистрыСведений.РеестрДокументов.ЗаписатьДанные(ТаблицыДанных, ОбъектДанных.Ссылка,  Неопределено, Ложь);
		
		#КонецОбласти
		
		ЗафиксироватьТранзакцию();
		
		ЗаписьЖурналаРегистрации(ИмяСобытияЖР, УровеньЖурналаРегистрации.Информация,,,
			"Записан Документ : "+строка(ОбъектДанных)+". Исходный док. УТ "+строка(ДокументИзУТ));
		
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
Функция ЗаполнитьРеквизиты(СтруктураОбъекта, ОбъектДанных, мОрганизация)
	
	ЗаполнитьРеквизитыШапки(СтруктураОбъекта, ОбъектДанных, мОрганизация);
	ЗаполнитьРеквизитыТЧ_РасшифровкаПлатежа(СтруктураОбъекта, ОбъектДанных);
	
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

Функция ЗаполнитьРеквизитыШапки(СтруктураОбъекта, ОбъектДанных, мОрганизация)
	
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
	ОбъектДанных.ВалютаКонвертации = ксп_ИмпортСлужебный.НайтиВалютуИзУзла(деф.ВалютаКонвертации);
	

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

	Если ТипЗнч(деф.Договор) = Тип("Структура") Тогда
		ОбъектДанных.Договор = ксп_ИмпортСлужебный.НайтиДоговор(деф.Договор, деф.Контрагент);
	Иначе 
		ОбъектДанных.Договор = Неопределено;
	КонецЕсли;
	
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
	ОбъектДанных.Касса = РегистрыСведений.ксп_МэппингСправочникКассы.ПоМэппингу(гуид, мВнешняяСистема);
	
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

	//ОбъектДанных.ОбъектРасчетов = ОбъектДанных.Договор;

	ОбъектДанных.Организация = мОрганизация;

	ОбъектДанных.Основание = деф.Основание;

	ОбъектДанных.Партнер = ОбъектДанных.Контрагент.Партнер;

	гуид="";
	ЕстьАтрибут = деф.ПодотчетноеЛицо.свойство("Ref",гуид);
	Если ЕстьАтрибут Тогда
		ОбъектДанных.ПодотчетноеЛицо = Справочники.ФизическиеЛица.ПолучитьСсылку( Новый УникальныйИдентификатор( гуид ) );
	Иначе
		ОбъектДанных.ПодотчетноеЛицо = Неопределено;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(ОбъектДанных.ПодотчетноеЛицо) 
		ИЛИ (
		ТипЗнч(ОбъектДанных.ПодотчетноеЛицо)=Тип("СправочникСсылка.ФизическиеЛица") И
			НЕ ЗначениеЗаполнено(ОбъектДанных.ПодотчетноеЛицо.ВерсияДанных)
		)
		Тогда
		
		ОбъектДанных.ПодотчетноеЛицо = РегистрыСведений.ксп_МэппингСправочникФизЛица.ПоМэппингу(гуид, мВнешняяСистема);
		
	КонецЕсли;
	
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

	ОбъектДанных.СтатьяДвиженияДенежныхСредств = ксп_ИмпортСлужебный.НайтиСтатьиДДС(деф.СтатьяДвиженияДенежныхСредств, мВнешняяСистема);

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
 
Функция ЗаполнитьРеквизитыТЧ_РасшифровкаПлатежа(СтруктураОбъекта, ОбъектДанных)

	id = СтруктураОбъекта.identification;
	деф = СтруктураОбъекта.definition;

	//------------------------------------------------------     ТЧ РасшифровкаПлатежа



	ОбъектДанных.РасшифровкаПлатежа.Очистить();


	Для счТовары = 0 По деф.ТЧРасшифровкаПлатежа.Количество()-1 Цикл
		стрк = деф.ТЧРасшифровкаПлатежа[счТовары];
		СтрокаТЧ = ОбъектДанных.РасшифровкаПлатежа.Добавить();

		СтрокаТЧ.СтавкаНДС = ксп_ИмпортСлужебный.ОпределитьСтавкуНДСПоСправочникуЕРП(стрк.СтавкаНДС);

		СтрокаТЧ.СтатьяДвиженияДенежныхСредств = ксп_ИмпортСлужебный.НайтиСтатьиДДС(стрк.СтатьяДвиженияДенежныхСредств, мВнешняяСистема);

		СтрокаТЧ.СуммаВзаиморасчетов	= стрк.СуммаВзаиморасчетов;
		СтрокаТЧ.СуммаНДС 				= стрк.СуммаНДС;
		СтрокаТЧ.ВалютаВзаиморасчетов 	= ОбъектДанных.Валюта;
		СтрокаТЧ.Организация 			= ОбъектДанных.Организация;		
		СтрокаТЧ.Партнер 				= ОбъектДанных.Партнер;
		СтрокаТЧ.Подразделение 			= ОбъектДанных.Подразделение;
		СтрокаТЧ.Сумма 					= стрк.Сумма;
		СтрокаТЧ.ОснованиеПлатежа 		= ОбъектДанных.Договор;

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
	мРеквизиты.Добавить("Организация");
	//мРеквизиты.Добавить("Контрагент");
	
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
	
	//НовСтр = ТЗ.Добавить();
	//НовСтр.ИмяТЧ = "Товары";
	//НовСтр.ИмяКолонки = "Номенклатура";
	//НовСтр = ТЗ.Добавить();
	//НовСтр.ИмяТЧ = "Товары";
	//НовСтр.ИмяКолонки = "Характеристика";
	
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
ПОМЕТИТЬ = 5;

