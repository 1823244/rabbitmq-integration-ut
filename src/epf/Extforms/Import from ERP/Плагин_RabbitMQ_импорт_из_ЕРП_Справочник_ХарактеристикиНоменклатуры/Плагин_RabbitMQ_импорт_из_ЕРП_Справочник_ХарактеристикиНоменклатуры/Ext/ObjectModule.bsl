﻿
Перем мЛоггер;
Перем мИдВызова;
Перем мОбновлять;

#Область ПодключениеОбработкиКБСП

Функция СведенияОВнешнейОбработке() Экспорт
	
	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке();
	
	ПараметрыРегистрации.Вставить("Вид",ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительнаяОбработка());
	ПараметрыРегистрации.Вставить("Версия","1.01");
	//ПараметрыРегистрации.Вставить("Назначение", Новый Массив);
	ПараметрыРегистрации.Вставить("Наименование","Плагин_RabbitMQ_импорт_из_ЕРП_Справочник_ХарактеристикиНоменклатуры");
	ПараметрыРегистрации.Вставить("БезопасныйРежим", Ложь);
	ПараметрыРегистрации.Вставить("Информация","Плагин_RabbitMQ_импорт_из_ЕРП_Справочник_ХарактеристикиНоменклатуры");
	ПараметрыРегистрации.Вставить("ВерсияБСП", "3.1.5.180");
	//ПараметрыРегистрации.Вставить("ОпределитьНастройкиФормы", Ложь);
	
	
	ТипКоманды = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы();
	ДобавитьКоманду(ПараметрыРегистрации.Команды, 
	"Открыть форму : Плагин_RabbitMQ_импорт_из_ЕРП_Справочник_ХарактеристикиНоменклатуры",
	"Форма_Плагин_RabbitMQ_импорт_из_ЕРП_Справочник_ХарактеристикиНоменклатуры",
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

// Описание_метода
//
// Параметры:
//	СтруктураОбъекта	- структура - после метода тДанные = ПрочитатьJSON(мЧтениеJSON,,,,"ФункцияВосстановленияJSON",ЭтотОбъект);//структура
//
// Возвращаемое значение:
//	Тип: Тип_значения
//
Функция ЗагрузитьОбъект(СтруктураОбъекта = Неопределено) Экспорт 
	
	//мЛоггер = Вычислить("мис_ЛоггерСервер.getLogger(мИдВызова, ""Импорт справочника из ЕРП: ХарактеристикиНоменклатуры"")");
	
	Попытка
		
		Если НЕ СтруктураОбъекта.Свойство("type") Тогда // на случай, если передадут пустой объект
			//млоггер.варн("Пропущено! Нет свойства type в сообщении");
			Возврат Неопределено;
		КонецЕсли;
		
		Если НЕ НРег(СтруктураОбъекта.type) = НРег("Справочник.ХарактеристикиНоменклатуры") Тогда
			//млоггер.варн("Пропущено! В type не Справочник.ХарактеристикиНоменклатуры");
			Возврат Неопределено;
		КонецЕсли;
		
		id = СтруктураОбъекта.identification;
		def = СтруктураОбъекта.definition; 
		
		СуществующийОбъект = Справочники.ХарактеристикиНоменклатуры.ПолучитьСсылку(Новый УникальныйИдентификатор(id.Ref));
		
		Если НЕ ЗначениеЗаполнено(СуществующийОбъект.ВерсияДанных) Тогда
			Если def.isFolder = true Тогда
				ОбъектДанных = Справочники.ХарактеристикиНоменклатуры.СоздатьГруппу();
			Иначе	
				ОбъектДанных = Справочники.ХарактеристикиНоменклатуры.СоздатьЭлемент();
			КонецЕсли; 
			ОбъектДанных.УстановитьНовыйКод();
			СсылкаНового = Справочники.ХарактеристикиНоменклатуры.ПолучитьСсылку(Новый УникальныйИдентификатор(id.Ref));
			ОбъектДанных.УстановитьСсылкуНового(СсылкаНового);
		Иначе
			
			Если НЕ мОбновлять = Истина Тогда  
				//млоггер.варн("Пропущено! Флаг Обновлять не включен! "+строка(СуществующийОбъект));
				Возврат СуществующийОбъект;
			КонецЕсли;
			
			ОбъектДанных = СуществующийОбъект.ПолучитьОбъект();
		КонецЕсли;
		
		ЗаполнитьРеквизиты(ОбъектДанных, СтруктураОбъекта);
		
		ОбъектДанных.ОбменДанными.Загрузка = Истина;
		
		ОбъектДанных.Записать();
		
		//млоггер.варн("Записан объект: "+строка(ОбъектДанных)+", ЭтоГруппа = "+Строка(ОбъектДанных.ЭтоГруппа));
		
		Возврат ОбъектДанных.Ссылка;
		
	Исключение
		
		т = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		//мЛоггер.ерр("Плагин импорта номенклатуры УПП. Подробности: " + т);
		
		//    ОБЯЗАТЕЛЬНО!!! Потому что в оркестраторе вызов плагина в попытке. и если была ошибка, надо сделать BasicReject()
		ВызватьИсключение т;
		
	КонецПопытки;
	
КонецФункции


Функция ЗаполнитьРеквизиты(объектДанных, СтруктураОбъекта = Неопределено) Экспорт 
	
	id = СтруктураОбъекта.identification;
	def = СтруктураОбъекта.definition; 
	
	Если def.isFolder = true Тогда
		Возврат Истина;
	КонецЕсли;
	
	ОбъектДанных.ПометкаУдаления = def.DeletionMark;
	
	ОбъектДанных.Владелец = ПолучитьСсылкуСправочникаПоДаннымID(def.Owner, "Номенклатура");
	ОбъектДанных.Наименование 		= def.Наименование;
	ОбъектДанных.НаименованиеПолное = def.НаименованиеПолное;
	
	//ОбъектДанных.Принципал
	//ОбъектДанных.Контрагент
	//ОбъектДанных.КиЗГИСМGTIN
	//ОбъектДанных.ВидНоменклатуры
	//ОбъектДанных.ХарактеристикиНоменклатурыДляЦенообразования
	
	//"ТЧДополнительныеРеквизиты"
	//"ТЧПредставления"

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


#Область Тестирование

Функция ЗагрузитьИзJsonНаСервере(Json = Неопределено) export
	
	Если не ЗначениеЗаполнено(json) Тогда
		ВызватьИсключение "Пустой json";
	КонецЕсли;
	
	мЧтениеJSON = Новый ЧтениеJSON;
	
	
	мЧтениеJSON.УстановитьСтроку(Json);
	
	СтруктураОбъекта = ПрочитатьJSON(мЧтениеJSON,,,,"ФункцияВосстановленияJSON",ЭтотОбъект);//структура
	
	Если ТипЗнч(СтруктураОбъекта) = Тип("Массив") Тогда
		Для Каждого эл из СтруктураОбъекта Цикл
			ЗагрузитьОбъект(эл);
		КонецЦикла;
	Иначе
		Возврат ЗагрузитьОбъект(СтруктураОбъекта);
	КонецЕсли;
	
КонецФункции

Функция ФункцияВосстановленияJSON(Свойство, Значение, ДопПараметры) Экспорт
	
	Если Свойство = "Date"Тогда
		Возврат ПрочитатьДатуJSON(Значение, ФорматДатыJSON.ISO);
	КонецЕсли;
	Если Свойство = "Период"Тогда
		Попытка
			Возврат ПрочитатьДатуJSON(Значение, ФорматДатыJSON.ISO);
		Исключение
			Возврат '00010101';
		КонецПопытки;
		
	КонецЕсли;
	Если Свойство = "Сумма" Тогда
		Возврат XMLЗначение(Тип("Число"),Значение);
	КонецЕсли;
	Если Свойство = "Валюта" Тогда
		Возврат Справочники.Валюты.НайтиПоКоду(Значение);
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
Функция ЗагрузитьИзJsonНаСервереИзФайла(Адрес, Обновлять = Истина) ЭКспорт
	
	мОбновлять = Обновлять;
	
	ДвоичныеДанные  = ПолучитьИзВременногоХранилища(Адрес);
	Если 1=0 Тогда
		ДвоичныеДанные = новый ДвоичныеДанные("");
	КонецЕсли;                                
	
	ИмяФайла = ПолучитьИмяВременногоФайла("json");
	ДвоичныеДанные.Записать(ИмяФайла);
	
	мЧтениеJSON = Новый ЧтениеJSON;
	мЧтениеJSON.ОткрытьФайл(ИмяФайла);
	
	СтруктураОбъекта = ПрочитатьJSON(мЧтениеJSON,,,,"ФункцияВосстановленияJSON",ЭтотОбъект);//структура
	
	Если ТипЗнч(СтруктураОбъекта) = Тип("Массив") Тогда
		Для Каждого эл из СтруктураОбъекта Цикл
			ЗагрузитьОбъект(эл);
		КонецЦикла;
	Иначе
		Возврат ЗагрузитьОбъект(СтруктураОбъекта);
	КонецЕсли;
	
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
Функция ЗагрузитьИзJsonНаСервереИзМассиваАдресов(МассивАдресов, Обновлять = Истина) Экспорт
	
	мОбновлять = Обновлять;
	//млоггер = мис_логгерСервер.getLogger(мИдВызова);
	
	//млоггер.инфо("НАЧАЛИ пакет из "+строка(МассивАдресов.Количество())+" файлов");
	
	сч_обраотано = 0;       
	сч_ошибок = 0;
	
	Для каждого Адрес Из МассивАдресов Цикл
		
		
		ДвоичныеДанные  = ПолучитьИзВременногоХранилища(Адрес);
		Если 1=0 Тогда
			ДвоичныеДанные = новый ДвоичныеДанные("");
		КонецЕсли;
		
		ИмяФайла = ПолучитьИмяВременногоФайла("json");
		ДвоичныеДанные.Записать(ИмяФайла);
		
		мЧтениеJSON = Новый ЧтениеJSON;
		мЧтениеJSON.ОткрытьФайл(ИмяФайла);
		
		СтруктураОбъекта = ПрочитатьJSON(мЧтениеJSON,,,,"ФункцияВосстановленияJSON",ЭтотОбъект);//структура
		
		Если ТипЗнч(СтруктураОбъекта) = Тип("Массив") Тогда
			Для Каждого эл из СтруктураОбъекта Цикл
				
				Попытка
					ЗагрузитьОбъект(эл);
					сч_обраотано = сч_обраотано +1;
				Исключение
					//Сообщить(НСтр("ru = '"+ОписаниеОшибки()+"'"), СтатусСообщения.Внимание);
					сч_ошибок = сч_ошибок + 1;
				КонецПопытки;
				
			КонецЦикла;
		Иначе 
			
			Попытка
				ЗагрузитьОбъект(СтруктураОбъекта);
				сч_обраотано = сч_обраотано +1;
			Исключение
				//Сообщить(НСтр("ru = '"+ОписаниеОшибки()+"'"), СтатусСообщения.Внимание);
				сч_ошибок = сч_ошибок + 1;
			КонецПопытки;
			
			
		КонецЕсли;
		
	КонецЦикла;
	
	//млоггер.инфо("ЗАВЕРШИЛИ пакет из "+строка(МассивАдресов.Количество())+" файлов. УСпешно обработано = "+строка(сч_обраотано)
	//+", ошибок = "+Строка(сч_ошибок));
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти


Функция сетИдВызова(пИдВызова) Экспорт
	
	мИдВызова = пИдВызова;
	Возврат ЭтотОбъект;
	
КонецФункции


мОбновлять = Истина;

