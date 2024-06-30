﻿Перем НЕ_ЗАГРУЖАТЬ;
Перем СОЗДАТЬ;
Перем ОБНОВИТЬ;
Перем ОТМЕНИТЬ_ПРОВЕДЕНИЕ;

Перем мЛоггер;
Перем мИдВызова;

Перем мВнешняяСистема;
Перем ИмяСобытияЖР;

Перем СобиратьНенайденнуюНоменклатуру Экспорт;
Перем НеНайденнаяНоменклатураМассив;

Перем СобиратьНенайденныхКонтрагентов Экспорт;
Перем НеНайденныеКонтрагентыМассив;


#Область ПодключениеОбработкиКБСП

Функция СведенияОВнешнейОбработке() Экспорт
	
	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке();
	
	ПараметрыРегистрации.Вставить("Вид",ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительнаяОбработка());
	ПараметрыРегистрации.Вставить("Версия","1.06");
	//ПараметрыРегистрации.Вставить("Назначение", Новый Массив);
	ПараметрыРегистрации.Вставить("Наименование","Плагин_RabbitMQ_импорт_из_ЕРП_Документ_СписаниеБезналичныхДенежныхСредств");
	ПараметрыРегистрации.Вставить("БезопасныйРежим", Ложь);
	ПараметрыРегистрации.Вставить("Информация","Плагин_RabbitMQ_импорт_из_ЕРП_Документ_СписаниеБезналичныхДенежныхСредств");
	ПараметрыРегистрации.Вставить("ВерсияБСП", "3.1.5.180");
	//ПараметрыРегистрации.Вставить("ОпределитьНастройкиФормы", Ложь);
	
	ТипКоманды = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы();
	ДобавитьКоманду(ПараметрыРегистрации.Команды, 
		"Открыть форму : Плагин_RabbitMQ_импорт_из_ЕРП_Документ_СписаниеБезналичныхДенежныхСредств",
		"Плагин_RabbitMQ_импорт_из_ЕРП_Документ_СписаниеБезналичныхДенежныхСредств",
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


Функция ЗагрузитьОбъект(СтруктураОбъекта, мОрганизация, jsonText = "") Экспорт
	
	//мЛоггер = мис_ЛоггерСервер.getLogger(мИдВызова, "Импорт документов из УТ: Приобретение товаров услуг");
	
	Попытка
		
		Если НЕ СтруктураОбъекта.Свойство("type") Тогда // на случай, если передадут пустой объект
			//мЛоггер.ерр("Неверный тип входящего объекта. сообщение пропущено.");
			Возврат Неопределено;
		КонецЕсли;
		
		Если НЕ НРег(СтруктураОбъекта.type) = НРег("Документ.СписаниеБезналичныхДенежныхСредств") Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		id = СтруктураОбъекта.identification;
		деф = СтруктураОбъекта.definition;
		
		Рез = СоздатьОбновитьДокумент(СтруктураОбъекта, мОрганизация);
		
		Возврат Рез;
		
	Исключение
		
		ЗаписьЖурналаРегистрации(ИмяСобытияЖР, УровеньЖурналаРегистрации.Ошибка,,,
		"Импорт из УТ. Плагин: Импорт Документ.СписаниеБезналичныхДенежныхСредств. Подробности: "+ОписаниеОшибки());
		ВызватьИсключение;// для помещения в retry
		
	КонецПопытки;
	
КонецФункции

Функция СоздатьОбновитьДокумент(СтруктураОбъекта, мОрганизация) Экспорт
	
	id = СтруктураОбъекта.identification;
	деф = СтруктураОбъекта.definition;   
	
	ПустойДокумент = Документы.СписаниеБезналичныхДенежныхСредств.ПустаяСсылка();
	
	ДокументИзУТ = "СписаниеБезналичныхДенежныхСредств (УТ) № " + деф.Number + " от " + строка(деф.Date);
	
	УИД = Новый УникальныйИдентификатор(id.Ref);
	СуществующийДокСсылка = Документы.СписаниеБезналичныхДенежныхСредств.ПолучитьСсылку(УИД);
	
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
			ОбъектДанных = Документы.СписаниеБезналичныхДенежныхСредств.СоздатьДокумент();
			СсылкаНового = Документы.СписаниеБезналичныхДенежныхСредств.ПолучитьСсылку(УИД);
			ОбъектДанных.УстановитьСсылкуНового(СсылкаНового);
			//ОбъектДанных.УстановитьНовыйНомер();
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
		
		//РегистрыСведений.ксп_СоответствиеДокументовУстановкаПорядковыхНомеров.ДобавитьЗапись(ОбъектДанных.Ссылка, деф.Number, id.ref);
		
		jsonText = "";
		ксп_ИмпортСлужебный.Документы_ПослеИмпорта_01(ОбъектДанных, мВнешняяСистема, СтруктураОбъекта, jsonText, ЭтотОбъект);
		ксп_ИмпортСлужебный.Документы_ПослеИмпорта_02(ОбъектДанных, мВнешняяСистема, СтруктураОбъекта, jsonText, ЭтотОбъект);
		ксп_ИмпортСлужебный.Документы_ПослеИмпорта_03(ОбъектДанных, мВнешняяСистема, СтруктураОбъекта, jsonText, ЭтотОбъект);
		ксп_ИмпортСлужебный.Документы_ПослеИмпорта_04(ОбъектДанных, мВнешняяСистема, СтруктураОбъекта, jsonText, ЭтотОбъект);
		ксп_ИмпортСлужебный.Документы_ПослеИмпорта_05(ОбъектДанных, мВнешняяСистема, СтруктураОбъекта, jsonText, ЭтотОбъект);
		
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
Функция ЗаполнитьРеквизиты(СтруктураОбъекта, ОбъектДанных, мОрганизация) 
	
	ЗаполнитьРеквизитыШапки(СтруктураОбъекта, ОбъектДанных, мОрганизация);
	ЗаполнитьРеквизитыТЧ_РасшифровкаПлатежа(СтруктураОбъекта, ОбъектДанных);
	
КонецФункции

Функция ЗаполнитьРеквизитыШапки(СтруктураОбъекта, ОбъектДанных, мОрганизация)
	
	id = СтруктураОбъекта.identification;
	деф = СтруктураОбъекта.definition;

	НомерДок = деф.Number;
	Если СтрДлина(НомерДок) > 11 Тогда
		НомерДок = ПрефиксацияОбъектовКлиентСервер.УдалитьПрефиксыИзНомераОбъекта(НомерДок, Ложь, Истина);
	КонецЕсли;
	ОбъектДанных.Номер = НомерДок;
	
	ОбъектДанных.Дата = деф.Date;
	ОбъектДанных.ПометкаУдаления = деф.DeletionMark;

//Автор

	//гуид="";
	//ЕстьАтрибут = деф.АналитикаРасходов.свойство("Ref",гуид);
	//Если ЕстьАтрибут Тогда
	//	ОбъектДанных.АналитикаРасходов = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( деф.АналитикаРасходов.Ref ) );
	//Иначе
	//	ОбъектДанных.АналитикаРасходов = Неопределено;
	//КонецЕсли;
	//// на случай, если есть метод поиска ссылки:
	//ОбъектДанных.АналитикаРасходов = ксп_ИмпортСлужебный.НайтиАналитикаРасходов(деф.АналитикаРасходов);

	Если деф.БанковскийСчет.Свойство("НомерСчета") Тогда
		ОбъектДанных.БанковскийСчет = ксп_ИмпортСлужебный.НайтиБанковскийСчет(деф.БанковскийСчет.НомерСчета, деф.БанковскийСчет.БИК);
	КонецЕсли;
	
	Если деф.БанковскийСчетКонтрагента.Свойство("НомерСчета") Тогда
		ОбъектДанных.БанковскийСчетКонтрагента = ксп_ИмпортСлужебный.НайтиБанковскийСчет(деф.БанковскийСчетКонтрагента.НомерСчета, деф.БанковскийСчетКонтрагента.БИК);
	КонецЕсли;

	Если деф.БанковскийСчетПолучатель.Свойство("НомерСчета") Тогда
		ОбъектДанных.БанковскийСчетПолучатель = ксп_ИмпортСлужебный.НайтиБанковскийСчет(деф.БанковскийСчетПолучатель.НомерСчета, деф.БанковскийСчетПолучатель.БИК);
	КонецЕсли;

//БанковскийСчетСписанияКомиссии

	ОбъектДанных.Валюта = ксп_ИмпортСлужебный. НайтиВалютуИзУзла(деф.Валюта);
	ОбъектДанных.ВалютаКонвертации = ксп_ИмпортСлужебный. НайтиВалютуИзУзла(деф.ВалютаКонвертации);

//ВидПеречисленияВБюджет
//ВидПлатежа

	//гуид="";
	//ЕстьАтрибут = деф.ГруппаФинансовогоУчета.свойство("Ref",гуид);
	//Если ЕстьАтрибут Тогда
	//	ОбъектДанных.ГруппаФинансовогоУчета = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( деф.ГруппаФинансовогоУчета.Ref ) );
	//Иначе
	//	ОбъектДанных.ГруппаФинансовогоУчета = Неопределено;
	//КонецЕсли;
	//// на случай, если есть метод поиска ссылки:
	//ОбъектДанных.ГруппаФинансовогоУчета = ксп_ИмпортСлужебный.НайтиГруппаФинансовогоУчета(деф.ГруппаФинансовогоУчета);

	ОбъектДанных.ДанныеВыписки = деф.ДанныеВыписки;

//ДатаАвансовогоОтчета
//ДатаВедомостиНаВыплатуЗарплаты

	Если ЗначениеЗаполнено(деф.ДатаВходящегоДокумента) Тогда
		Если ТипЗнч(деф.ДатаВходящегоДокумента) = Тип("Строка") Тогда
			ОбъектДанных.ДатаВходящегоДокумента = XMLЗначение(Тип("Дата"), деф.ДатаВходящегоДокумента);
		Иначе
			ОбъектДанных.ДатаВходящегоДокумента = деф.ДатаВходящегоДокумента;
		КонецЕсли; 
	КонецЕсли; 

	Если ЗначениеЗаполнено(деф.ДатаВыгрузки) Тогда
		Если ТипЗнч(деф.ДатаВыгрузки) = Тип("Строка") Тогда
			ОбъектДанных.ДатаВыгрузки = XMLЗначение(Тип("Дата"), деф.ДатаВыгрузки);
		Иначе
			ОбъектДанных.ДатаВыгрузки = деф.ДатаВыгрузки;
		КонецЕсли; 
	КонецЕсли; 

//ДатаВыгрузкиРеестра
//ДатаДоговораСБанком

	Если ЗначениеЗаполнено(деф.ДатаЗагрузки) Тогда
		Если ТипЗнч(деф.ДатаЗагрузки) = Тип("Строка") Тогда
			ОбъектДанных.ДатаЗагрузки = XMLЗначение(Тип("Дата"), деф.ДатаЗагрузки);
		Иначе
			ОбъектДанных.ДатаЗагрузки = деф.ДатаЗагрузки;
		КонецЕсли;
	КонецЕсли;

	Если ЗначениеЗаполнено(деф.ДатаПроведенияБанком) Тогда
		Если ТипЗнч(деф.ДатаПроведенияБанком) = Тип("Строка") Тогда
			ОбъектДанных.ДатаПроведенияБанком = XMLЗначение(Тип("Дата"), деф.ДатаПроведенияБанком);
		Иначе
			ОбъектДанных.ДатаПроведенияБанком = деф.ДатаПроведенияБанком;
		КонецЕсли; 
	КонецЕсли; 

	ОбъектДанных.Договор = ксп_ИмпортСлужебный.НайтиДоговор(деф.Договор, деф.Контрагент);

//ДоговорСЗаказчиком
//ДоговорСУчастникомГОЗ

	//гуид="";
	//ЕстьАтрибут = деф.ДоговорЭквайринга.свойство("Ref",гуид);
	//Если ЕстьАтрибут Тогда
	//	ОбъектДанных.ДоговорЭквайринга = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( деф.ДоговорЭквайринга.Ref ) );
	//Иначе
	//	ОбъектДанных.ДоговорЭквайринга = Неопределено;
	//КонецЕсли;
	//// на случай, если есть метод поиска ссылки:
	//ОбъектДанных.ДоговорЭквайринга = ксп_ИмпортСлужебный.НайтиДоговорЭквайринга(деф.ДоговорЭквайринга);

	//гуид="";
	//ЕстьАтрибут = деф.ДокументОснование.свойство("Ref",гуид);
	//Если ЕстьАтрибут Тогда
	//	ОбъектДанных.ДокументОснование = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( деф.ДокументОснование.Ref ) );
	//Иначе
	//	ОбъектДанных.ДокументОснование = Неопределено;
	//КонецЕсли;
	//// на случай, если есть метод поиска ссылки:
	//ОбъектДанных.ДокументОснование = ксп_ИмпортСлужебный.НайтиДокументОснование(деф.ДокументОснование);

//ЗаявкаНаРасходованиеДенежныхСредств

	ОбъектДанных.ИдентификаторДокумента = деф.ИдентификаторДокумента;

	ОбъектДанных.ИдентификаторПлатежа = деф.ИдентификаторПлатежа;

	ОбъектДанных.ИмяКонтрагента = деф.ИмяКонтрагента;

//ИННПлательщика
//ИнформацияДляВалютногоКонтроля
//ИнформацияДляРегулирующихОрганов
//ИнформацияПолучателюПлатежа

	ОбъектДанных.Исправление = деф.Исправление;

	гуид="";
	ЕстьАтрибут = деф.ИсправляемыйДокумент.свойство("Ref",гуид);
	Если ЕстьАтрибут Тогда
		ОбъектДанных.ИсправляемыйДокумент = Документы.СписаниеБезналичныхДенежныхСредств.ПолучитьСсылку( Новый УникальныйИдентификатор( деф.ИсправляемыйДокумент.Ref ) );
	Иначе
		ОбъектДанных.ИсправляемыйДокумент = Неопределено;
	КонецЕсли;

	ОбъектДанных.КассаПолучатель = ксп_ИмпортСлужебный.НайтиКассу(деф.КассаПолучатель, мВнешняяСистема);

//КодБК

	//гуид="";
	//ЕстьАтрибут = деф.КодВалютнойОперации.свойство("Ref",гуид);
	//Если ЕстьАтрибут Тогда
	//	ОбъектДанных.КодВалютнойОперации = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( деф.КодВалютнойОперации.Ref ) );
	//Иначе
	//	ОбъектДанных.КодВалютнойОперации = Неопределено;
	//КонецЕсли;
	//// на случай, если есть метод поиска ссылки:
	//ОбъектДанных.КодВалютнойОперации = ксп_ИмпортСлужебный.НайтиКодВалютнойОперации(деф.КодВалютнойОперации);

//КодВидаДохода
//КодВыплат
//КодировкаФайла
//КодОКАТО

	ОбъектДанных.Комментарий = деф.Комментарий;

	ОбъектДанных.Контрагент = ксп_ИмпортСлужебный.НайтиКонтрагента(деф.Контрагент, мВнешняяСистема);

//КПППлательщика

	ОбъектДанных.КратностьКурсаКонвертации = деф.КратностьКурсаКонвертации;

	ОбъектДанных.КурсКонвертации = деф.КурсКонвертации;

	ОбъектДанных.НазначениеПлатежа = деф.НазначениеПлатежа;

	Если деф.НалогообложениеНДС.Свойство("Значение") Тогда
		ОбъектДанных.НалогообложениеНДС = ксп_ИмпортСлужебный.НайтиЗначениеПеречисления("ТипыНалогообложенияНДС", деф.НалогообложениеНДС.Значение);
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

//НастройкаСчетовУчета
//НДФЛПоВедомостям
//НеКонтролироватьЗаполнениеЗаявки
//НомерВедомостиНаВыплатуЗарплаты

	ОбъектДанных.НомерВходящегоДокумента = деф.НомерВходящегоДокумента;

//НомерДоговораСБанком

	//гуид="";
	//ЕстьАтрибут = деф.ОбъектРасчетов.свойство("Ref",гуид);
	//Если ЕстьАтрибут Тогда
	//	ОбъектДанных.ОбъектРасчетов = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( деф.ОбъектРасчетов.Ref ) );
	//Иначе
	//	ОбъектДанных.ОбъектРасчетов = Неопределено;
	//КонецЕсли;
	//// на случай, если есть метод поиска ссылки:
	//ОбъектДанных.ОбъектРасчетов = ксп_ИмпортСлужебный.НайтиОбъектРасчетов(деф.ОбъектРасчетов);

//ОплатаПоЗаявкам

	ОбъектДанных.Организация = мОрганизация;

	//гуид="";
	//ЕстьАтрибут = деф.Ответственный.свойство("Ref",гуид);
	//Если ЕстьАтрибут Тогда
	//	ОбъектДанных.Ответственный = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( деф.Ответственный.Ref ) );
	//Иначе
	//	ОбъектДанных.Ответственный = Неопределено;
	//КонецЕсли;
	//// на случай, если есть метод поиска ссылки:
	//ОбъектДанных.Ответственный = ксп_ИмпортСлужебный.НайтиОтветственный(деф.Ответственный);

//ОтделениеБанка

	ОбъектДанных.ОтражатьКомиссию = деф.ОтражатьКомиссию;
	ОбъектДанных.ОшибкиЗагрузки = деф.ОшибкиЗагрузки;
	ОбъектДанных.Партнер = ОбъектДанных.Контрагент.Партнер;

//ПеречислениеВБюджет
//ПеречислениеСотрудникуЧерезБанк
//ПериодРегистрации
//ПлатежиПо275ФЗ
//ПлатежСКонвертацией

	//гуид="";
	//ЕстьАтрибут = деф.ПодотчетноеЛицо.свойство("Ref",гуид);
	//Если ЕстьАтрибут Тогда
	//	ОбъектДанных.ПодотчетноеЛицо = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( деф.ПодотчетноеЛицо.Ref ) );
	//Иначе
	//	ОбъектДанных.ПодотчетноеЛицо = Неопределено;
	//КонецЕсли;
	//// на случай, если есть метод поиска ссылки:
	//ОбъектДанных.ПодотчетноеЛицо = ксп_ИмпортСлужебный.НайтиПодотчетноеЛицо(деф.ПодотчетноеЛицо);

	ОбъектДанных.Подразделение = ксп_ИмпортСлужебный.НайтиПодразделение(деф.Подразделение, мВнешняяСистема);

//ПоказательДаты
//ПоказательНомера
//ПоказательОснования
//ПоказательПериода
//ПоказательТипа

	ОбъектДанных.ПроведеноБанком = деф.ПроведеноБанком;

	ОбъектДанных.ПроводкиПоРаботникам = деф.ПроводкиПоРаботникам;

//РаспоряжениеНаПеремещениеДенежныхСредств
//РегистрацияВНалоговомОргане
//СписокКонтрагентов
//СписокФизЛиц
//СтатусСоставителя

	ОбъектДанных.СтатьяДвиженияДенежныхСредств = ксп_ИмпортСлужебный.НайтиСтатьиДДС(деф.СтатьяДвиженияДенежныхСредств, мВнешняяСистема);

//СтатьяДвиженияДенежныхСредствКонвертация

	//гуид="";
	//ЕстьАтрибут = деф.СтатьяРасходов.свойство("Ref",гуид);
	//Если ЕстьАтрибут Тогда
	//	ОбъектДанных.СтатьяРасходов = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( деф.СтатьяРасходов.Ref ) );
	//Иначе
	//	ОбъектДанных.СтатьяРасходов = Неопределено;
	//КонецЕсли;
	//// на случай, если есть метод поиска ссылки:
	//ОбъектДанных.СтатьяРасходов = ксп_ИмпортСлужебный.НайтиСтатьяРасходов(деф.СтатьяРасходов);

//СтатьяЦелевыхСредств

	гуид="";
	ЕстьАтрибут = деф.СторнируемыйДокумент.свойство("Ref",гуид);
	Если ЕстьАтрибут Тогда
		ОбъектДанных.СторнируемыйДокумент = Документы.СписаниеБезналичныхДенежныхСредств.ПолучитьСсылку( Новый УникальныйИдентификатор( деф.СторнируемыйДокумент.Ref ) );
	Иначе
		ОбъектДанных.СторнируемыйДокумент = Неопределено;
	КонецЕсли;

//СуммаВВалютеОтправителя

	ОбъектДанных.СуммаДокумента = деф.СуммаДокумента;

	ОбъектДанных.СуммаКомиссии = деф.СуммаКомиссии;

	ОбъектДанных.СуммаКонвертации = деф.СуммаКонвертации;

//ТекстПлательщика
//ТипКомиссииЗаПеревод
//ТипНалога
//ТипПлатежаФЗ275

	ОбъектДанных.ТипПлатежногоДокумента = ксп_ИмпортСлужебный.НайтиЗначениеПеречисления("ТипыПлатежныхДокументов", деф.ТипПлатежногоДокумента.Значение);

//УведомлениеОЗачисленииВалюты
//УсловиеСделкиКонвертации
//ФилиалОтделенияБанка

	ОбъектДанных.ФорматированноеНазначениеПлатежа = деф.ФорматированноеНазначениеПлатежа;

	ОбъектДанных.ХозяйственнаяОперация = ксп_ИмпортСлужебный.НайтиЗначениеПеречисления("ХозяйственныеОперации", деф.ХозяйственнаяОперация.Значение);
	//Если ОбъектДанных.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПеречислениеДенежныхСредствНаДругойСчет Тогда
		ОбъектДанных.ОчередностьПлатежа = 1;
	//КонецЕсли; 

КонецФункции

Функция ЗаполнитьРеквизитыТЧ_РасшифровкаПлатежа(СтруктураОбъекта, ОбъектДанных)

	id = СтруктураОбъекта.identification;
	деф = СтруктураОбъекта.definition;

	//------------------------------------------------------     ТЧ РасшифровкаПлатежа

	ОбъектДанных.РасшифровкаПлатежа.Очистить();

	Для счТовары = 0 По деф.ТЧРасшифровкаПлатежа.Количество()-1 Цикл

		стрк = деф.ТЧРасшифровкаПлатежа[счТовары];
		СтрокаТЧ = ОбъектДанных.РасшифровкаПлатежа.Добавить();

		//гуид="";
		//ЕстьАтрибут = стрк.АналитикаАктивовПассивов.свойство("Ref",гуид);
		//Если ЕстьАтрибут Тогда
		//	СтрокаТЧ.АналитикаАктивовПассивов = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( стрк.АналитикаАктивовПассивов.Ref ) );
		//Иначе
		//	СтрокаТЧ.АналитикаАктивовПассивов = Неопределено;
		//КонецЕсли;
		//// на случай, если есть метод поиска ссылки:
		//СтрокаТЧ.АналитикаАктивовПассивов = ксп_ИмпортСлужебный.НайтиАналитикаАктивовПассивов(стрк.АналитикаАктивовПассивов);

		//гуид="";
		//ЕстьАтрибут = стрк.АналитикаДоходов.свойство("Ref",гуид);
		//Если ЕстьАтрибут Тогда
		//	СтрокаТЧ.АналитикаДоходов = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( стрк.АналитикаДоходов.Ref ) );
		//Иначе
		//	СтрокаТЧ.АналитикаДоходов = Неопределено;
		//КонецЕсли;
		//// на случай, если есть метод поиска ссылки:
		//СтрокаТЧ.АналитикаДоходов = ксп_ИмпортСлужебный.НайтиАналитикаДоходов(стрк.АналитикаДоходов);

		СтрокаТЧ.ВалютаВзаиморасчетов = ксп_ИмпортСлужебный.НайтиВалютуИзУзла(стрк.ВалютаВзаиморасчетов);

		//гуид="";
		//ЕстьАтрибут = стрк.ДоговорАренды.свойство("Ref",гуид);
		//Если ЕстьАтрибут Тогда
		//	СтрокаТЧ.ДоговорАренды = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( стрк.ДоговорАренды.Ref ) );
		//Иначе
		//	СтрокаТЧ.ДоговорАренды = Неопределено;
		//КонецЕсли;
		//// на случай, если есть метод поиска ссылки:
		//СтрокаТЧ.ДоговорАренды = ксп_ИмпортСлужебный.НайтиДоговорАренды(стрк.ДоговорАренды);

		//гуид="";
		//ЕстьАтрибут = стрк.ДоговорЗаймаСотруднику.свойство("Ref",гуид);
		//Если ЕстьАтрибут Тогда
		//	СтрокаТЧ.ДоговорЗаймаСотруднику = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( стрк.ДоговорЗаймаСотруднику.Ref ) );
		//Иначе
		//	СтрокаТЧ.ДоговорЗаймаСотруднику = Неопределено;
		//КонецЕсли;
		//// на случай, если есть метод поиска ссылки:
		//СтрокаТЧ.ДоговорЗаймаСотруднику = ксп_ИмпортСлужебный.НайтиДоговорЗаймаСотруднику(стрк.ДоговорЗаймаСотруднику);

		//гуид="";
		//ЕстьАтрибут = стрк.ДоговорКредитаДепозита.свойство("Ref",гуид);
		//Если ЕстьАтрибут Тогда
		//	СтрокаТЧ.ДоговорКредитаДепозита = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( стрк.ДоговорКредитаДепозита.Ref ) );
		//Иначе
		//	СтрокаТЧ.ДоговорКредитаДепозита = Неопределено;
		//КонецЕсли;
		//// на случай, если есть метод поиска ссылки:
		//СтрокаТЧ.ДоговорКредитаДепозита = ксп_ИмпортСлужебный.НайтиДоговорКредитаДепозита(стрк.ДоговорКредитаДепозита);

		СтрокаТЧ.ИдентификаторСтроки = стрк.ИдентификаторСтроки;

		СтрокаТЧ.КурсЗнаменательВзаиморасчетов = стрк.КурсЗнаменательВзаиморасчетов;

		СтрокаТЧ.КурсЧислительВзаиморасчетов = стрк.КурсЧислительВзаиморасчетов;

		//гуид="";
		//ЕстьАтрибут = стрк.НаправлениеДеятельности.свойство("Ref",гуид);
		//Если ЕстьАтрибут Тогда
		//	СтрокаТЧ.НаправлениеДеятельности = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( стрк.НаправлениеДеятельности.Ref ) );
		//Иначе
		//	СтрокаТЧ.НаправлениеДеятельности = Неопределено;
		//КонецЕсли;
		//// на случай, если есть метод поиска ссылки:
		//СтрокаТЧ.НаправлениеДеятельности = ксп_ИмпортСлужебный.НайтиНаправлениеДеятельности(стрк.НаправлениеДеятельности);

		//гуид="";
		//ЕстьАтрибут = стрк.НастройкаСчетовУчета.свойство("Ref",гуид);
		//Если ЕстьАтрибут Тогда
		//	СтрокаТЧ.НастройкаСчетовУчета = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( стрк.НастройкаСчетовУчета.Ref ) );
		//Иначе
		//	СтрокаТЧ.НастройкаСчетовУчета = Неопределено;
		//КонецЕсли;
		//// на случай, если есть метод поиска ссылки:
		//СтрокаТЧ.НастройкаСчетовУчета = ксп_ИмпортСлужебный.НайтиНастройкаСчетовУчета(стрк.НастройкаСчетовУчета);

		//Если Документы.ТипВсеСсылки().СодержитТип(ТипЗначения)
		//	ИЛИ Справочники.ТипВсеСсылки().СодержитТип(ТипЗначения)
		
		СтрокаТЧ.Организация = ксп_ИмпортСлужебный.НайтиОрганизацию(деф.Организация, мВнешняяСистема);

		СтрокаТЧ.Партнер = ОбъектДанных.Контрагент.Партнер;
		
		ТипМетаданных = "";
		Если стрк.Объект.Свойство("type", ТипМетаданных) Тогда
			
			мМногострочныйТекст = СтрЗаменить(ТипМетаданных, ".", Символы.ПС);
			СправочникИлиДокумент = СтрПолучитьСтроку(мМногострочныйТекст, 1);
			ВидОбъекта = СтрПолучитьСтроку(мМногострочныйТекст, 2);
			
			Если СправочникИлиДокумент = "Справочник" Тогда
				СсылкаНаОбъект = ПолучитьСсылкуСправочникаПоДаннымID(стрк.ОбъектРасчетов, ВидОбъекта);
			ИначеЕсли СправочникИлиДокумент = "Документ" Тогда
				СсылкаНаОбъект = ПолучитьСсылкуДокументаПоДаннымID(стрк.ОбъектРасчетов, ВидОбъекта);
			КонецЕсли;
			
		КонецЕсли;
		
		//СсылкаПартнер = ПолучитьСсылкуСправочникаПоДаннымID(стрк.ОбъектПартнер, "Партнеры");
		//СсылкаОрганизация = ПолучитьСсылкуСправочникаПоДаннымID(стрк.ОбъектОрганизация, "Организации");
		//СсылкаКонтрагент = ПолучитьСсылкуСправочникаПоДаннымID(стрк.ОбъектКонтрагент, "Контрагенты");
		СсылкаДоговор = ПолучитьСсылкуСправочникаПоДаннымID(стрк.ОбъектРасчетов, "ДоговорыКонтрагентов");
		
		СтрокаТЧ.ОбъектРасчетов = НайтиОбъектРасчетов(СсылкаНаОбъект, СтрокаТЧ.Партнер, СтрокаТЧ.Организация, ОбъектДанных.Контрагент, СсылкаДоговор);

		//гуид="";
		//ЕстьАтрибут = стрк.ОснованиеПлатежа.свойство("Ref",гуид);
		//Если ЕстьАтрибут Тогда
		//	СтрокаТЧ.ОснованиеПлатежа = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( стрк.ОснованиеПлатежа.Ref ) );
		//Иначе
		//	СтрокаТЧ.ОснованиеПлатежа = Неопределено;
		//КонецЕсли;
		//// на случай, если есть метод поиска ссылки:
		//СтрокаТЧ.ОснованиеПлатежа = ксп_ИмпортСлужебный.НайтиОснованиеПлатежа(стрк.ОснованиеПлатежа);
		
		СтрокаТЧ.Подразделение = ксп_ИмпортСлужебный.НайтиПодразделение(деф.Подразделение, мВнешняяСистема);

		//гуид="";
		//ЕстьАтрибут = стрк.РасчетныйДокументПоАренде.свойство("Ref",гуид);
		//Если ЕстьАтрибут Тогда
		//	СтрокаТЧ.РасчетныйДокументПоАренде = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( стрк.РасчетныйДокументПоАренде.Ref ) );
		//Иначе
		//	СтрокаТЧ.РасчетныйДокументПоАренде = Неопределено;
		//КонецЕсли;
		//// на случай, если есть метод поиска ссылки:
		//СтрокаТЧ.РасчетныйДокументПоАренде = ксп_ИмпортСлужебный.НайтиРасчетныйДокументПоАренде(стрк.РасчетныйДокументПоАренде);

		СтрокаТЧ.СтавкаНДС = ксп_ИмпортСлужебный.ОпределитьСтавкуНДСПоСправочникуЕРП(стрк.СтавкаНДС);
		
		СтрокаТЧ.СтатьяДвиженияДенежныхСредств = ксп_ИмпортСлужебный.НайтиСтатьиДДС(стрк.СтатьяДвиженияДенежныхСредств, мВнешняяСистема);

		//гуид="";
		//ЕстьАтрибут = стрк.СтатьяДоходов.свойство("Ref",гуид);
		//Если ЕстьАтрибут Тогда
		//	СтрокаТЧ.СтатьяДоходов = Справочники_Документы.КакойТоВидМД.ПолучитьСсылку( Новый УникальныйИдентификатор( стрк.СтатьяДоходов.Ref ) );
		//Иначе
		//	СтрокаТЧ.СтатьяДоходов = Неопределено;
		//КонецЕсли;
		//// на случай, если есть метод поиска ссылки:
		//СтрокаТЧ.СтатьяДоходов = ксп_ИмпортСлужебный.НайтиСтатьяДоходов(стрк.СтатьяДоходов);


		СтрокаТЧ.Сумма = стрк.Сумма;

		СтрокаТЧ.СуммаВзаиморасчетов = стрк.СуммаВзаиморасчетов;

		СтрокаТЧ.СуммаНДС = стрк.СуммаНДС;

		//_знч = "";
		//ЕстьЗначение = стрк.ТипПлатежаПоАренде.свойство("Значение",_знч);
		//Если ЕстьЗначение Тогда
		//	СтрокаТЧ.ТипПлатежаПоАренде = стрк.ТипПлатежаПоАренде.Значение;
		//Иначе
		//	СтрокаТЧ.ТипПлатежаПоАренде = Неопределено;
		//КонецЕсли;
		//// на случай, если есть метод поиска ссылки:
		//СтрокаТЧ.ТипПлатежаПоАренде = ксп_ИмпортСлужебный.НайтиПеречисление_ТипПлатежаПоАренде(стрк.ТипПлатежаПоАренде);

		//_знч = "";
		//ЕстьЗначение = стрк.ТипСуммыКредитаДепозита.свойство("Значение",_знч);
		//Если ЕстьЗначение Тогда
		//	СтрокаТЧ.ТипСуммыКредитаДепозита = стрк.ТипСуммыКредитаДепозита.Значение;
		//Иначе
		//	СтрокаТЧ.ТипСуммыКредитаДепозита = Неопределено;
		//КонецЕсли;
		//// на случай, если есть метод поиска ссылки:
		//СтрокаТЧ.ТипСуммыКредитаДепозита = ксп_ИмпортСлужебный.НайтиПеречисление_ТипСуммыКредитаДепозита(стрк.ТипСуммыКредитаДепозита);

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
	мРеквизиты.Добавить("Контрагент");
	мРеквизиты.Добавить("Партнер");
	
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

Функция ПолучитьСсылкуСправочникаПоДаннымID(СтруктураID, ВидОбъекта) Экспорт
	
	Если Не ТипЗнч(СтруктураID) = Тип("Структура") Тогда
		Возврат Справочники[ВидОбъекта].ПустаяСсылка();
	КонецЕсли;
	
	ГУИД = "";
	Если СтруктураID.Свойство("Ref", ГУИД) Тогда
		Если НЕ ЗначениеЗаполнено(ГУИД) ИЛИ ГУИД="00000000-0000-0000-0000-000000000000" Тогда
			Возврат Справочники[ВидОбъекта].ПустаяСсылка();
		КонецЕсли;
		Возврат Справочники[ВидОбъекта].ПолучитьСсылку(Новый УникальныйИдентификатор(ГУИД));
	Иначе
		Возврат Справочники[ВидОбъекта].ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

Функция ПолучитьСсылкуДокументаПоДаннымID(СтруктураID, ВидОбъекта) Экспорт
	
	Если Не ТипЗнч(СтруктураID) = Тип("Структура") Тогда
		Возврат Документы[ВидОбъекта].ПустаяСсылка();
	КонецЕсли;
	
	ГУИД = "";
	Если СтруктураID.Свойство("Ref", ГУИД) Тогда
		Если НЕ ЗначениеЗаполнено(ГУИД) ИЛИ ГУИД="00000000-0000-0000-0000-000000000000" Тогда
			Возврат Документы[ВидОбъекта].ПустаяСсылка();
		КонецЕсли;
		Возврат Документы[ВидОбъекта].ПолучитьСсылку(Новый УникальныйИдентификатор(ГУИД));
	Иначе
		Возврат Документы[ВидОбъекта].ПустаяСсылка();
	КонецЕсли;
	
КонецФункции


Функция НайтиОбъектРасчетов(СсылкаНаОбъект, СсылкаПартнер, СсылкаОрганизация, СсылкаКонтрагент, СсылкаДоговор)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ОбъектыРасчетов.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ОбъектыРасчетов КАК ОбъектыРасчетов
		|ГДЕ
		|	ОбъектыРасчетов.Объект = &Объект
		|	И ОбъектыРасчетов.Партнер = &Партнер
		|	И ОбъектыРасчетов.Организация = &Организация
		|	И ОбъектыРасчетов.Контрагент = &Контрагент
		|	И ОбъектыРасчетов.Договор = &Договор";
	
	Запрос.УстановитьПараметр("Объект", СсылкаНаОбъект);
	Запрос.УстановитьПараметр("Партнер", СсылкаПартнер);
	Запрос.УстановитьПараметр("Организация", СсылкаОрганизация);
	Запрос.УстановитьПараметр("Контрагент", СсылкаКонтрагент);
	Запрос.УстановитьПараметр("Договор", СсылкаДоговор);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Справочники.ОбъектыРасчетов.ПустаяСсылка();
	Иначе
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		ВыборкаДетальныеЗаписи.Следующий();
		Возврат ВыборкаДетальныеЗаписи.Ссылка;
		
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

СобиратьНенайденнуюНоменклатуру = Истина;
НеНайденнаяНоменклатураМассив = Новый Массив;

СобиратьНенайденныхКонтрагентов = Истина;
НеНайденныеКонтрагентыМассив = Новый Массив;


НЕ_ЗАГРУЖАТЬ = 1;
СОЗДАТЬ = 2;
ОБНОВИТЬ = 3;
ОТМЕНИТЬ_ПРОВЕДЕНИЕ = 4;


