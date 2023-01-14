#Использовать RabbitMQ
#Использовать json

// Имя пользователя
Перем Пользователь;

// Пароль
Перем Пароль;

// Сервер
Перем Сервер;

// Виртуальный хост
Перем ВиртуальныйХост;

// Имя точки обмена
Перем ИмяТочкиОбмена;

Процедура ПриСозданииОбъекта()
	
КонецПроцедуры

Функция Пользователь(вхПользователь) Экспорт
	
	Пользователь = вхПользователь;
	
	Возврат ЭтотОбъект;
	
КонецФункции

Функция Пароль(вхПароль) Экспорт
	
	Пароль = вхПароль;
	
	Возврат ЭтотОбъект;
	
КонецФункции

Функция Сервер(вхСервер) Экспорт
	
	Сервер = вхСервер;
	
	Возврат ЭтотОбъект;
	
КонецФункции

Функция ВиртуальныйХост(вхВиртуальныйХост) Экспорт
	
	ВиртуальныйХост = вхВиртуальныйХост;
	
	Возврат ЭтотОбъект;
	
КонецФункции

Функция ИмяТочкиОбмена(вхИмяТочкиОбмена) Экспорт
	
	ИмяТочкиОбмена = вхИмяТочкиОбмена;
	
	Возврат ЭтотОбъект;
	
КонецФункции

Функция ЗарегистрироватьОшибку(ДанныеОтчетаОбОшибке) Экспорт
	
	Соединение = Новый СоединениеRMQ;
	
	Соединение.Пользователь = Пользователь;
	Соединение.Пароль = Пароль;
	Соединение.Сервер = Сервер;
	Соединение.ВиртуальныйХост = ВиртуальныйХост;
	
	Попытка 
		Клиент = Соединение.Установить();
	Исключение
		ВызватьИсключение("Не удалось установить соединение RabbitMQ");
	КонецПопытки;

	Сообщение = СформироватьТелоЗапроса(ДанныеОтчетаОбОшибке);

	Попытка
		Клиент.ОтправитьСтроку(Сообщение, ИмяТочкиОбмена);
	Исключение
		Соединение.Закрыть();
		ВызватьИсключение("Не удалось отправить сообщение в точку обмена");
	КонецПопытки;

	Соединение.Закрыть();

	// Для провайдера RMQ не существует такого понятия как ИдЗадачиВТрекере
	Возврат Неопределено;
	
КонецФункции

Функция СформироватьТелоЗапроса(ДанныеОтчетаОбОшибке) Экспорт
	
	Описание = ОтчетыОбОшибках.СформироватьТелоОписанияОшибкиJSON(ДанныеОтчетаОбОшибке);
	
	ПарсерJSON = Новый ПарсерJSON();
	Возврат ПарсерJSON.ЗаписатьJSON(Описание);
	
КонецФункции
