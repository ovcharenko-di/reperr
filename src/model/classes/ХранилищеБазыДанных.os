#Использовать entity

// Хранилище сущностей "ДанныеОбОшибке"
Перем ХранилищеДанныхОбОшибках;

// Хранилище сущностей "ЗапросОбОшибке"
Перем ХранилищеЗапросовОбОшибках;

Процедура ПриСозданииОбъекта(ТипХранилища) Экспорт

	ИнициализироватьХранилище(ТипХранилища);

КонецПроцедуры

Процедура ИнициализироватьХранилище(ТипХранилища)

	ПодключитьСценарий(ОбъединитьПути(ТекущийКаталог(), "model", "entities", "ЗапросОбОшибке.os"), "ЗапросОбОшибке");
	ПодключитьСценарий(ОбъединитьПути(ТекущийКаталог(), "model", "entities", "ДанныеОбОшибке.os"), "ДанныеОбОшибке");

	МенеджерСущностей = Новый МенеджерСущностей(Тип (ТипХранилища));
	МенеджерСущностей.ДобавитьКлассВМодель(Тип("ЗапросОбОшибке"));
	МенеджерСущностей.ДобавитьКлассВМодель(Тип("ДанныеОбОшибке"));
	МенеджерСущностей.Инициализировать();

	ХранилищеДанныхОбОшибках = МенеджерСущностей.ПолучитьХранилищеСущностей (Тип("ДанныеОбОшибке"));
	ХранилищеЗапросовОбОшибках = МенеджерСущностей.ПолучитьХранилищеСущностей (Тип("ЗапросОбОшибке"));

КонецПроцедуры

Функция ПрочитатьЗапросыИнфоОбОшибках () Экспорт
	Возврат ХранилищеЗапросовОбОшибках.Получить ();
КонецФункции

Процедура ЗаписатьЗапросИнфоОбОшибке(ЗапросИнфоОбОшибке) Экспорт
	ЗапросОбОшибке = ХранилищеЗапросовОбОшибках.СоздатьЭлемент ();
	ЗаполнитьЗначенияСвойств (ЗапросОбОшибке, ЗапросИнфоОбОшибке, , "x_id");
	ХранилищеЗапросовОбОшибках.Сохранить (ЗапросОбОшибке);
КонецПроцедуры

Функция ПрочитатьОшибки () Экспорт
	Возврат ХранилищеДанныхОбОшибках.Получить ();
КонецФункции

Функция ИдентификаторОшибкиВТрекереПоОтпечатку(Отпечаток) Экспорт
	ДанныеОбОшибке = ХранилищеДанныхОбОшибках.ПолучитьОдно (Отпечаток);
	Возврат ? (ДанныеОбОшибке = Неопределено, Неопределено, ДанныеОбОшибке.external_id);
КонецФункции

Процедура ЗаписатьОшибку(ДанныеОтчетаОбОшибке) Экспорт

	Отчет = ДанныеОтчетаОбОшибке.Отчет;

	ДанныеОбОшибке = ХранилищеДанныхОбОшибках.СоздатьЭлемент ();
	
	ДанныеОбОшибке.fingerprint = ДанныеОтчетаОбОшибке.Идентификатор;
	ДанныеОбОшибке.datetime = ПрочитатьДатуJSON (Отчет ["time"], ФорматДатыJSON.ISO);

	ХранилищеДанныхОбОшибках.Сохранить (ДанныеОбОшибке);

КонецПроцедуры

Процедура УстановитьИдЗадачиВТрекере(ИдентификаторЗадачи, ИдЗадачиВТрекере) Экспорт
	ДанныеОбОшибке = ХранилищеДанныхОбОшибках.ПолучитьОдно (ИдентификаторЗадачи);
	ДанныеОбОшибке.external_id = ИдЗадачиВТрекере;
	ХранилищеДанныхОбОшибках.Сохранить (ДанныеОбОшибке);
КонецПроцедуры