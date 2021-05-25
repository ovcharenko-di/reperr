#Использовать "../src/model"

// BSLLS:UnusedParameters-off
Функция ПолучитьСписокТестов(ЮнитТестирование) Экспорт
// BSLLS:UnusedParameters-on
	
	ВсеТесты = Новый Массив;
	
	ВсеТесты.Добавить("ТестДолжен_СформироватьТелоЗапросаSentry");
	ВсеТесты.Добавить("ТестДолжен_СформироватьТелоЗапросаSentry_НетТиповОшибок");

	Возврат ВсеТесты;
	
КонецФункции

Процедура ПередЗапускомТеста() Экспорт
	
	УстановитьТекущийКаталог(ТекущийСценарий().Каталог);
	
КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт
	
КонецПроцедуры

Процедура ТестДолжен_СформироватьТелоЗапросаSentry() Экспорт
	
	ПровайдерИнтеграцииSentry = Новый ПровайдерИнтеграцииSentry()
												.DSN("dsn")
												.Логгер("logger.reperr.errors")
												;

	ФайловоеХранилище = Новый ФайловоеХранилище("../features/fixtures/data");
	ДанныеОтчетаОбОшибке = ФайловоеХранилище.ПолучитьДанныеОтчетаОбОшибке("61001a5e-09d5-47b8-bf19-e7672eda10e5");
	
	Результат = ПровайдерИнтеграцииSentry.СформироватьТелоЗапроса(ДанныеОтчетаОбОшибке);
	
	КаталогСценария = ТекущийСценарий().Каталог;
	ЧтениеТекста = Новый ЧтениеТекста("../features/fixtures/requestBodySentry.json", "utf-8");
	Эталон = ЧтениеТекста.Прочитать();
	ЧтениеТекста.Закрыть();
	
	Ожидаем.Что(Результат).Равно(Эталон);
	
КонецПроцедуры

Процедура ТестДолжен_СформироватьТелоЗапросаSentry_НетТиповОшибок() Экспорт
	
	ПровайдерИнтеграцииSentry = Новый ПровайдерИнтеграцииSentry()
												.DSN("dsn")
												.Логгер("logger.reperr.errors")
												;

	ФайловоеХранилище = Новый ФайловоеХранилище("../features/fixtures/data");
	ДанныеОтчетаОбОшибке = ФайловоеХранилище.ПолучитьДанныеОтчетаОбОшибке("55555555-09d5-47b8-bf19-e7672eda1111");
	
	Результат = ПровайдерИнтеграцииSentry.СформироватьТелоЗапроса(ДанныеОтчетаОбОшибке);
	
	КаталогСценария = ТекущийСценарий().Каталог;
	ЧтениеТекста = Новый ЧтениеТекста("../features/fixtures/requestBodySentry_ErrorType_Extentions.json", "utf-8");
	Эталон = ЧтениеТекста.Прочитать();
	ЧтениеТекста.Закрыть();
	
	Ожидаем.Что(Результат).Равно(Эталон);
	
КонецПроцедуры
