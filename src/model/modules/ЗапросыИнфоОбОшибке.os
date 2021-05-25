#Использовать logos

Функция ПолучитьСписок() Экспорт

	ХранилищеДанных = МенеджерНастроек.ХранилищеДанных();

	Возврат ХранилищеДанных.ПолучитьЗапросыИнфоОбОшибках();

КонецФункции

Функция ОбработатьЗапрос(Знач ТелоЗапросаТекст) Экспорт

	ФайлЖурнала = Новый ВыводЛогаВФайл;
	ФайлЖурнала.ОткрытьФайл("/var/log/reperr.repotrprocessing.info.log");

	Лог = Логирование.ПолучитьЛог("reperr.repotrprocessing.info");
	Лог.ДобавитьСпособВывода(ФайлЖурнала);

	ПарсерJSON = Новый ПарсерJSON;
	ЗапросИнфоОбОшибке = ПарсерJSON.ПрочитатьJSON(ТелоЗапросаТекст, , , Истина);

	Ид = Строка(Новый УникальныйИдентификатор());
	Отпечаток = ОтпечатокОшибки(ЗапросИнфоОбОшибке);

	ЗапросИнфоОбОшибке.Вставить("x_id", Ид);
	ЗапросИнфоОбОшибке.Вставить("x_datetime", ТекущаяУниверсальнаяДата());
	ЗапросИнфоОбОшибке.Вставить("x_fingerprint", Отпечаток);

	Лог.Информация(ПарсерJSON.ЗаписатьJSON(ЗапросИнфоОбОшибке));

	ХранилищеДанных = МенеджерНастроек.ХранилищеДанных();
	ХранилищеДанных.ЗаписатьЗапросИнфоОбОшибке(ЗапросИнфоОбОшибке);

	ОтветНаЗапросИнфоОбОшибке = ОтветНаЗапросИнфоОбОшибке(ЗапросИнфоОбОшибке);

	СтруктураОтвета = Новый Структура; 
	СтруктураОтвета.Вставить("needSendReport", ОтветНаЗапросИнфоОбОшибке.ОтправлятьОтчет);
	СтруктураОтвета.Вставить("userMessage", ОтветНаЗапросИнфоОбОшибке.Сообщение);
	СтруктураОтвета.Вставить("dumpType", ОтветНаЗапросИнфоОбОшибке.ТипДампа);
	
	Результат = ПарсерJSON.ЗаписатьJSON(СтруктураОтвета);

	Лог.Информация(Результат);

	Возврат Результат;

КонецФункции

Функция ОтветНаЗапросИнфоОбОшибке(Знач ЗапросИнфоОбОшибке)

	Ответ = Новый Структура;
	Ответ.Вставить("ОтправлятьОтчет", Истина);
	Ответ.Вставить("Сообщение", "Отчет об ошибке будет отправлен автоматически.");
	Ответ.Вставить("ТипДампа", "0");

	Если ОтправлятьКаждыйОтчет() Тогда
		Возврат Ответ;
	КонецЕсли;

	ХранилищеДанных = МенеджерНастроек.ХранилищеДанных();
	ИдОшибки = ХранилищеДанных.ИдентификаторОшибкиВТрекереПоОтпечатку(ЗапросИнфоОбОшибке["x_fingerprint"]);

	Если ИдОшибки <> Неопределено Тогда
		Ответ.Вставить("ОтправлятьОтчет", Ложь);
		Сообщение = СтрШаблон("Данная ошибка уже была зарегистрирована. Ид: %1", ИдОшибки);
		Ответ.Вставить("Сообщение", Сообщение);
	КонецЕсли;

	Возврат Ответ;

КонецФункции

Функция ОтправлятьКаждыйОтчет()

	ПровайдерИнтеграции = МенеджерНастроек.ПровайдерИнтеграции();
	Если ПровайдерИнтеграции = Неопределено Тогда
		Возврат Истина;
	КонецЕсли; 

	Возврат ПровайдерИнтеграции.ОтправлятьКаждыйОтчет();

КонецФункции

Функция ОтпечатокОшибки(ЗапросИнфоОбОшибке)

	Провайдер = Новый ХешированиеДанных(ХешФункция.MD5);
	ДобавитьПараметрВПровайдерХеширования(Провайдер, ЗапросИнфоОбОшибке, "clientStackHash");
	ДобавитьПараметрВПровайдерХеширования(Провайдер, ЗапросИнфоОбОшибке, "serverStackHash");

	Возврат Провайдер.ХешСуммаСтрокой;

КонецФункции

Процедура ДобавитьПараметрВПровайдерХеширования(Провайдер, ЗапросИнфоОбОшибке, Свойство)

	ЗначениеСвойства = Неопределено;
	ЗапросИнфоОбОшибке.Свойство(Свойство, ЗначениеСвойства);

	Если ЗначениеЗаполнено(ЗначениеСвойства) Тогда
		Провайдер.Добавить(ЗначениеСвойства);
	КонецЕсли;

КонецПроцедуры
