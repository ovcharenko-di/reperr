#Использовать asserts
#Использовать tempfiles
#Использовать "../src/model"

// BSLLS:UnusedParameters-off
Функция ПолучитьСписокТестов(ЮнитТестирование) Экспорт
// BSLLS:UnusedParameters-on
	
	ВсеТесты = Новый Массив;
	
	ВсеТесты.Добавить("ТестДолжен_ОбработатьЗапросGetInfo");
	ВсеТесты.Добавить("ТестДолжен_ОбработатьУжеЗарегистрированнуюОшибку");

	Возврат ВсеТесты;
	
КонецФункции

Процедура ПередЗапускомТеста() Экспорт
	
	УстановитьТекущийКаталог(ТекущийСценарий().Каталог);
	КаталогДанных = ОбъединитьПути("..", "features", "fixtures");
	
	ВременныйКаталог = ВременныеФайлы.СоздатьКаталог();
	ФС.КопироватьСодержимоеКаталога(КаталогДанных, ВременныйКаталог);
	УстановитьТекущийКаталог(ВременныйКаталог);
	
КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт
	
КонецПроцедуры

Процедура ТестДолжен_ОбработатьЗапросGetInfo() Экспорт

	ФайловоеХранилище = Новый ФайловоеХранилище("./data");
	МенеджерНастроек.УстановитьХранилищеДанных(ФайловоеХранилище);

	ЧтениеТекста = Новый ЧтениеТекста("getInfoRequest.json", "utf-8");
	ТелоЗапросаТекст = ЧтениеТекста.Прочитать();
	ЧтениеТекста.Закрыть();
	ТелоОтвета = ЗапросыИнфоОбОшибке.ОбработатьЗапрос(ТелоЗапросаТекст);

	ЧтениеТекста = Новый ЧтениеТекста("getInfoResponse.json", "utf-8");
	ТелоОтветаЭталон = ЧтениеТекста.Прочитать();
	ЧтениеТекста.Закрыть();
	
	Ожидаем.Что(ТелоОтвета).Равно(ТелоОтветаЭталон);
	
КонецПроцедуры

Процедура ТестДолжен_ОбработатьУжеЗарегистрированнуюОшибку() Экспорт

	ЧтениеТекста = Новый ЧтениеТекста("getInfoDuplicateRequest.json", "utf-8");
	ТелоЗапросаТекст = ЧтениеТекста.Прочитать();
	ЧтениеТекста.Закрыть();

	ЧтениеТекста = Новый ЧтениеТекста("getInfoDuplicateResponse.json", "utf-8");
	Эталон = ЧтениеТекста.Прочитать();
	ЧтениеТекста.Закрыть();

	ФайловоеХранилище = Новый ФайловоеХранилище("./data");
	МенеджерНастроек.УстановитьХранилищеДанных(ФайловоеХранилище);

	ПровайдерИнтеграции = Новый ПровайдерИнтеграцииRedmine();
	МенеджерНастроек.УстановитьПровайдерИнтеграции(ПровайдерИнтеграции);

	Результат = ЗапросыИнфоОбОшибке.ОбработатьЗапрос(ТелоЗапросаТекст);

	Ожидаем.Что(Результат).Равно(Эталон);
	
КонецПроцедуры
