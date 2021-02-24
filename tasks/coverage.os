#Использовать coverage
#Использовать 1commands
#Использовать fs

ФС.ОбеспечитьПустойКаталог("coverage");
ПутьКСтат = "coverage/stat.json";

Команда = Новый Команда;
Команда.УстановитьКоманду("oscript");
Команда.ДобавитьПараметр(СтрШаблон("-codestat=%1", ПутьКСтат));    
Команда.ДобавитьПараметр("tasks/test.os");
Команда.ПоказыватьВыводНемедленно(Истина);

КодВозврата = Команда.Исполнить();

Файл_Стат = Новый Файл(ПутьКСтат);

Каталог = Новый Файл("coverage");
ПроцессорГенерации = Новый ГенераторОтчетаПокрытия();
ПроцессорГенерации.РабочийКаталог(Каталог.ПолноеИмя);

ПроцессорГенерации.ОтносительныеПути()
				.ИмяФайлаСтатистики("stat*.json")
				.ФайлСтатистики(Файл_Стат.ПолноеИмя)
				.GenericCoverage()
				.Cobertura()
				.Сформировать();

ЗавершитьРаботу(КодВозврата);
