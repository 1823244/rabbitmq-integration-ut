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
	ПараметрыРегистрации.Вставить("Версия","1.14");
	//ПараметрыРегистрации.Вставить("Назначение", Новый Массив);
	ПараметрыРегистрации.Вставить("Наименование","Плагин_RabbitMQ_импорт_из_ЕРП_Документ_ВозвратТоваровОтКлиента");
	ПараметрыРегистрации.Вставить("БезопасныйРежим", Ложь);
	ПараметрыРегистрации.Вставить("Информация","Плагин_RabbitMQ_импорт_из_ЕРП_Документ_ВозвратТоваровОтКлиента");
	ПараметрыРегистрации.Вставить("ВерсияБСП", "3.1.5.180");
	//ПараметрыРегистрации.Вставить("ОпределитьНастройкиФормы", Ложь);
	
	ТипКоманды = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы();
	ДобавитьКоманду(ПараметрыРегистрации.Команды, 
		"Открыть форму : Плагин_RabbitMQ_импорт_из_ЕРП_Документ_ВозвратТоваровОтКлиента",
		"Форма_Плагин_RabbitMQ_импорт_из_УТ_Документ_ВозвратТоваровОтКлиента",
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
	
	//мЛоггер = мис_ЛоггерСервер.getLogger(мИдВызова, "Импорт документов из УТ: Возврат товаров от клиента");
	
	Попытка
		
		Если НЕ СтруктураОбъекта.Свойство("type") Тогда // на случай, если передадут пустой объект
			//мЛоггер.ерр("Неверный тип входящего объекта. сообщение пропущено.");
			Возврат Неопределено;
		КонецЕсли;
		
		Если НЕ НРег(СтруктураОбъекта.type) = НРег("документ.возвраттоваровотклиента") Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		id = СтруктураОбъекта.identification;
		деф = СтруктураОбъекта.definition;
		
		Рез = СоздатьОбновитьДокумент(СтруктураОбъекта);
		
		Попытка
			ксп_ЭкспортСлужебный.ВыполнитьЭкспорт_ГуидовНоменклатуры(НеНайденнаяНоменклатураМассив);
			Сообщить("Выполнен экспорт ненайденной номенклатуры - " + Строка(НеНайденнаяНоменклатураМассив.Количество()) + " позиций");
		Исключение
			т = "Ошибка экспорта ненайденной номенклатуры в УПП. Подробности: " + ОписаниеОшибки();
			Сообщить(т);
			ЗаписьЖурналаРегистрации(ИмяСобытияЖР, УровеньЖурналаРегистрации.Предупреждение,,,т);
			//мЛоггер.ерр(т);
		КонецПопытки;
		
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
		"Импорт из УТ. Плагин: Импорт Документ.ВозвратТоваровОтКлиента. Подробности: "+ОписаниеОшибки());
		ВызватьИсключение;// для помещения в retry
		
	КонецПопытки;	
	
КонецФункции

Функция СоздатьОбновитьДокумент(СтруктураОбъекта) Экспорт
	
	id = СтруктураОбъекта.identification;
	деф = СтруктураОбъекта.definition;   
	
	ПустойДокумент = Документы.ВозвратТоваровОтКлиента.ПустаяСсылка();
	
	ДокументИзУТ = "ВозвратТоваровОтКлиента (УТ) № " + деф.Number + " от " + строка(деф.Date);
	
	УИД = Новый УникальныйИдентификатор(id.Ref);
	СуществующийДокСсылка = Документы.ВозвратТоваровОтКлиента.ПолучитьСсылку(УИД);
	
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
			ОбъектДанных = Документы.ВозвратТоваровОтКлиента.СоздатьДокумент();
			СсылкаНового = Документы.ВозвратТоваровОтКлиента.ПолучитьСсылку(УИД);
			ОбъектДанных.УстановитьСсылкуНового(СсылкаНового);
		Иначе 
			ОтменитьТранзакцию();
			Возврат ПустойДокумент;
		КонецЕсли;
		
		ПредставлениеОбъекта = Строка(ОбъектДанных);
		
		ЗаполнитьРеквизиты(СтруктураОбъекта, ОбъектДанных);
		
		Если ОбъектДанных.Проведен Тогда
			ОбъектДанных.Записать(РежимЗаписиДокумента.ОтменаПроведения);
		Иначе 
			ОбъектДанных.ОбменДанными.Загрузка = Ложь;
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
Функция ЗаполнитьРеквизиты(СтруктураОбъекта, ОбъектДанных) Экспорт
	
	id = СтруктураОбъекта.identification;
	деф = СтруктураОбъекта.definition;
	
	ОбъектДанных.Номер = деф.Номер;
	ОбъектДанных.Дата = деф.Date;
	ОбъектДанных.ПометкаУдаления = деф.DeletionMark;
	
	ОбъектДанных.Валюта = Справочники.Валюты.НайтиПоКоду(
		деф.Валюта.currencyCode);
	
	ОбъектДанных.ВариантПриемкиТоваров = Перечисления.ВариантыПриемкиТоваров.РазделенаТолькоПоНакладным;
	ОбъектДанных.ВозвратПорчи = деф.ВозвратПорчи;
	ОбъектДанных.Договор = ксп_ИмпортСлужебный.НайтиДоговор(деф.Договор);
	
	гуид="";
	ЕстьАтрибут = деф.ДокументРеализации.свойство("Ref",гуид);
	Если ЕстьАтрибут Тогда
		ОбъектДанных.ДокументРеализации = Документы.РеализацияТоваровУслуг.ПолучитьСсылку( Новый УникальныйИдентификатор( деф.ДокументРеализации.Ref ) );
	Иначе
		ОбъектДанных.ДокументРеализации = Неопределено;
	КонецЕсли;
	
	ОбъектДанных.Комментарий = деф.Комментарий;
	
	ТэгКонтрагента = деф.Контрагент;
	//_Контрагент = ксп_ИмпортСлужебный.НайтиКонтрагента(ТэгКонтрагента, мВнешняяСистема);
	_Контрагент = ПолучитьСсылкуСправочникаПоДаннымID(ТэгКонтрагента, "Контрагенты");
	Если СобиратьНенайденныхКонтрагентов и ТэгКонтрагента.Свойство("ref") Тогда
		Если ТипЗнч(_Контрагент) = Тип("СправочникСсылка.Контрагенты") И НЕ ЗначениеЗаполнено(_Контрагент.ВерсияДанных) Тогда
			Если НеНайденныеКонтрагентыМассив.Найти(ТэгКонтрагента.ref) = Неопределено Тогда
				НеНайденныеКонтрагентыМассив.Добавить(ТэгКонтрагента.Ref);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	ОбъектДанных.Контрагент = _Контрагент;
	
	ОбъектДанных.НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС;
	ОбъектДанных.НаправлениеДеятельности = РегистрыСведений.ксп_ДополнительныеНастройкиИнтеграций.Настройка(
		"НаправлениеДеятельностиДляРеализацяТоваровУслугИзРозница", мВнешняяСистема);
	
	ОбъектДанных.НомерВходящегоДокумента = деф.НомерВходящегоДокумента;
	ОбъектДанных.НомерДокументаПокупателя = деф.НомерДокументаПокупателя;
	ОбъектДанных.Организация = ксп_ИмпортСлужебный.НайтиОрганизацию(деф.Организация, мВнешняяСистема);
	
	ОбъектДанных.ОбъектРасчетов = ксп_ИмпортСлужебный.НайтиСоздатьОбъектРасчетовСКлиентом(
		ОбъектДанных, ОбъектДанных.Организация);
	
	ОбъектДанных.ОплатаВВалюте = деф.ОплатаВВалюте;
	
	Если ЗначениеЗаполнено(ОбъектДанных.Контрагент) Тогда
		ОбъектДанных.Партнер = ОбъектДанных.Контрагент.Партнер;
	Иначе
		ОбъектДанных.Партнер = Неопределено;
	КонецЕсли;
	
	ОбъектДанных.Покупатель = деф.Покупатель;
	
	//ОбъектДанных.ПокупательНеПлательщикНДС = деф.ПокупательНеПлательщикНДС;
	
	ОбъектДанных.ПорядокРасчетов = РегистрыСведений.ксп_ДополнительныеНастройкиИнтеграций.Настройка(
		"ПорядокРасчетовДляРеализацяТоваровУслугИзРозница", мВнешняяСистема);
	
	//ОбъектДанных.ПредусмотренЗалогЗаТару = деф.ПредусмотренЗалогЗаТару;
	
	ОбъектДанных.ПричинаВозврата = деф.ПричинаВозврата;
	
	ОбъектДанных.Склад = ксп_ИмпортСлужебный.НайтиСклад(деф.Склад, мВнешняяСистема);
	ОбъектДанных.Соглашение = РегистрыСведений.ксп_ДополнительныеНастройкиИнтеграций.Настройка(
		"СоглашениеСКлиентамиДляРеализацяТоваровУслугИзРозница", мВнешняяСистема);
	
	ОбъектДанных.СпособКомпенсации = Перечисления.СпособыКомпенсацииВозвратовТоваров.ВернутьДенежныеСредства;
	ОбъектДанных.СуммаДокумента = деф.СуммаДокумента;
	ОбъектДанных.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратТоваровОтКлиента;
	ОбъектДанных.ЦенаВключаетНДС = деф.ЦенаВключаетНДС;
	
	Если деф.свойство("Подразделение") и деф.Подразделение.Свойство("Ref") Тогда
		
		ОбъектДанных.Подразделение = Справочники.СтруктураПредприятия.ПолучитьСсылку(
			Новый УникальныйИдентификатор(деф.Подразделение.Ref));
	
	КонецЕсли;
	
	ОбъектДанных.IT_ТребуетсяПересчетКурса = Истина;
	
	
	////------------------------------------------------------     ТЧ Товары
	
	ОбъектДанных.Товары.Очистить();
	
	Для счТовары = 0 По деф.ТЧТовары.Количество()-1 Цикл
		
		стрк = деф.ТЧТовары[счТовары];
		СтрокаТЧ = ОбъектДанных.Товары.Добавить();
		
		СтрокаТЧ.ИдентификаторСтроки = Строка(Новый УникальныйИдентификатор);
		СтрокаТЧ.Количество = стрк.Количество;
		СтрокаТЧ.КоличествоУпаковок = стрк.КоличествоУпаковок;
		
		ТэгНоменклатуры = стрк.Номенклатура;
		//_Номенклатура = ксп_ИмпортСлужебный.НайтиНоменклатуру(ТэгНоменклатуры);
		_Номенклатура = ПолучитьСсылкуСправочникаПоДаннымID(ТэгНоменклатуры, "Номенклатура");
		Если СобиратьНенайденнуюНоменклатуру И ТэгНоменклатуры.Свойство("ref") Тогда
			Если НЕ ЗначениеЗаполнено(_Номенклатура.ВерсияДанных) Тогда
				Если НеНайденнаяНоменклатураМассив.Найти(ТэгНоменклатуры.ref) = Неопределено Тогда
					НеНайденнаяНоменклатураМассив.Добавить(ТэгНоменклатуры.Ref);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		СтрокаТЧ.Номенклатура = _Номенклатура;
		
		СтрокаТЧ.Характеристика = ксп_ИмпортСлужебный.НайтиХарактеристику(стрк.Характеристика);
		
		СтрокаТЧ.СпособОпределенияСебестоимости = Перечисления.СпособыОпределенияСебестоимости.ИзДокументаПродажи;
				
		СтрокаТЧ.СтавкаНДС = ксп_ИмпортСлужебный.ОпределитьСтавкуНДСПоСправочникуЕРП(стрк.СтавкаНДС);
		СтрокаТЧ.СтатусУказанияСерий = стрк.СтатусУказанияСерий;
		СтрокаТЧ.Сумма = стрк.Сумма;
		СтрокаТЧ.СуммаНДС = стрк.СуммаНДС;
		СтрокаТЧ.СуммаСНДС = стрк.СуммаСНДС;
		
		СтрокаТЧ.Упаковка = ксп_ИмпортСлужебный.НайтиЕдиницуИзмерения(стрк.Упаковка, стрк.Номенклатура);
		СтрокаТЧ.Цена = стрк.Цена;
		СтрокаТЧ.Штрихкод = стрк.Штрихкод;
		
		СтрокаТЧ.ДокументРеализации = ОбъектДанных.ДокументРеализации;

				
		СтрокаТЧ.АналитикаУчетаНоменклатуры = ксп_ИмпортСлужебный.НайтиСоздатьКлючАналитикиНом(
			СтрокаТЧ.Номенклатура, ОбъектДанных.Склад, СтрокаТЧ.Характеристика);
		
	КонецЦикла;
	
	////------------------------------------------------------     ТЧ ВидыЗапасов
	
	ОбъектДанных.ВидыЗапасов.Очистить();
	
	Для счТовары = 0 По ОбъектДанных.Товары.Количество()-1 Цикл
		
		стрк = ОбъектДанных.Товары[счТовары];
		СтрокаТЧ = ОбъектДанных.ВидыЗапасов.Добавить();
		
		// Справочник.ВидыЗапасов - todo нужна настройка импорта
		СтрокаТЧ.ВидЗапасов = ксп_ИмпортСлужебный.НайтиВидЗапасовСобственныйТовар(ОбъектДанных.Организация);
		СтрокаТЧ.ВидЗапасовОтгрузки = ксп_ИмпортСлужебный.НайтиВидЗапасовСобственныйТовар(ОбъектДанных.Организация);
		
		СтрокаТЧ.ДокументРеализации = ОбъектДанных.ДокументРеализации;
		
		СтрокаТЧ.ИдентификаторСтроки = строка(Новый УникальныйИдентификатор);
		
		СтрокаТЧ.Количество = стрк.Количество;
		//	СтрокаТЧ.КоличествоПоРНПТ = стрк.КоличествоПоРНПТ;
		СтрокаТЧ.КоличествоУпаковок = стрк.КоличествоУпаковок;
		
		СтрокаТЧ.СпособОпределенияСебестоимости = Перечисления.СпособыОпределенияСебестоимости.ИзДокументаПродажи;
		СтрокаТЧ.АналитикаУчетаНоменклатуры = ксп_ИмпортСлужебный.НайтиСоздатьКлючАналитикиНом(
			стрк.Номенклатура, ОбъектДанных.Склад, стрк.Характеристика);
		СтрокаТЧ.АналитикаУчетаНоменклатурыОтгрузки = СтрокаТЧ.АналитикаУчетаНоменклатуры;
		
	КонецЦикла;
	
	////------------------------------------------------------     ТЧ РасшифровкаПлатежа
	
	ОбъектДанных.РасшифровкаПлатежа.Очистить();
	
	СтрокаТЧ = ОбъектДанных.РасшифровкаПлатежа.Добавить();
	СтрокаТЧ.ВалютаВзаиморасчетов = Справочники.Валюты.НайтиПоКоду(деф.Валюта.currencyCode);
	СтрокаТЧ.ОбъектРасчетов = ксп_ИмпортСлужебный.НайтиСоздатьОбъектРасчетовСКлиентом(ОбъектДанных, ОбъектДанных.Организация);
	СтрокаТЧ.Сумма = ОбъектДанных.СуммаДокумента;
	СтрокаТЧ.СуммаВзаиморасчетов = ОбъектДанных.СуммаДокумента;
	
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

#КонецОбласти


// Описание_метода
//
// Параметры:
//	ГУИД 	- строка - 36 симв
//
// Возвращаемое значение:
//	Тип: Тип_значения
//
Функция СоздатьПолучитьСсылкуСправочника(ГУИД, ВидОбъекта)
	
	СуществующийОбъект = Справочники[ВидОбъекта].ПолучитьСсылку(Новый УникальныйИдентификатор(ГУИД));
	
	Если ЗначениеЗаполнено(СуществующийОбъект.ВерсияДанных) Тогда
		Возврат СуществующийОбъект;
	Иначе 
		
		ОбъектДанных = Справочники[ВидОбъекта].СоздатьДокумент();
		СсылкаНового = Справочники[ВидОбъекта].ПолучитьСсылку(Новый УникальныйИдентификатор(ГУИД));
		ОбъектДанных.УстановитьСсылкуНового(СсылкаНового);
		
		Возврат ОбъектДанных.Ссылка;
	КонецЕсли;
	
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


// Описание_метода
//
// Параметры:
//	ГУИД 	- строка - 36 симв
//
// Возвращаемое значение:
//	Тип: Тип_значения
//
Функция СоздатьПолучитьСсылкуДокумента(ГУИД, ВидОбъекта)
	
	СуществующийОбъект = Документы[ВидОбъекта].ПолучитьСсылку(Новый УникальныйИдентификатор(ГУИД));
	
	Если ЗначениеЗаполнено(СуществующийОбъект.ВерсияДанных) Тогда
		Возврат СуществующийОбъект;
	Иначе 
		
		ОбъектДанных = Документы[ВидОбъекта].СоздатьДокумент();
		СсылкаНового = Документы[ВидОбъекта].ПолучитьСсылку(Новый УникальныйИдентификатор(ГУИД));
		ОбъектДанных.УстановитьСсылкуНового(СсылкаНового);
		
		Возврат ОбъектДанных.Ссылка;
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
	//мРеквизиты.Добавить("Склад");
	//мРеквизиты.Добавить("Организация");
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

