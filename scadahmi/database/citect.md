[<- До підрозділу](README.md)

# Доступ до БД з Citect

Citect SCADA підтримує обмін з двома типами баз даних dBASE та SQL (через ODBC). Однак слід розуміти, що Cicode та Citect VBA надають можливість взаємодіяти з бібліотеками, які можуть надавати доступ до інших джерел даних. Крім того, на сторінках Citect можна використовувати компонент палітри "Data Exchange" (взаємодіє через ADO), приклад використання якого наведений у параграфі 8.4.3. 

Доступ до баз даних може проводитися з використанням пристроїв системного введення/виведення (Devices, див. параграф 6.11.6) або використовуючи Cicode функції з розділу SQL. Перший спосіб простіший у використанні і у багатьох випадках може не потребувати написання коду, наприклад, при записуванні в базу даних SQL журналів тривог або подій. Нижче наведемо приклад записування в базу даних саме через цей механізм. 

Одним із типів DEVICE є ODBC джерело даних типу таблиця. Citect підтримує роботу тільки із символьним (текстовим) типом даних. Перед використанням у Device бази даних, її треба створити разом з таблицею в ній, а також налаштувати ODBC. 

Візьмемо для прикладу налаштування запису рецепта в таблицю бази даних, означену в прикладі з параграфа 8.3.3. Для роботи в Citect з DEVICE типу SQL необхідно сконфігурувати такі поля (рис. 16): 

*Name* – довільна назва пристрою, наприклад *DevDB;* 

*Format* – формат таблиці, тобто назва та ширина в символах колонок таблиці. 

<a href="media8/8_16.png" target="_blank"><img src="C:\san\народн посібн атпв\gitver\scadahmi\database\media\8_16.png"/></a> 

*Рис. 16.* Вікно конфігурації Device в Citect

Наприклад, формат для цього прикладу (див. рис. 13) буде *{Name,16}{Water,8}{Sugar,8}{Flour,8}{Salt,8}{Yeast,8}{Milk,8}*. Зрештою, формат означуватиме таблицю, яка виглядатиме, як на рис. 17.

![](C:\san\народн посібн атпв\gitver\scadahmi\database\media\8_17.png) 

*Рис. 17.* Вигляд полів у таблиці БД

*Header* – для SQL типу пристрою вказується рядок підключення, наприклад:

```
DSN=ExmplDataBase; UID=G1; PWD=1
```

вказує на ім’я DSN "ExmplDataBase", ім’я користувача (UID) рівним "G1", пароль (PWD) рівним "1"; 

*FileName* – ім’я таблиці в базі даних, до якої необхідно підключитись, наприклад "Recipe"; 

*Type* – для SQL типу пристрою вибирається SQL_DEV; 

*NoFiles* – кількість файлів, для SQL типу пристрою дорівнює -1.

Після означення в проекті пристрою, його можна використати в Cicode. Добавлення нових записів у CiCode проводиться через функції DevAppend, зміна значень полів запису – через функцію DevSetField. Робота цих функцій з конкретним Device проводиться через дескриптор (handle), який повертається функцією DevOpen, що відкриває зв'язок із джерелом даних. 

Роботу функцій розглянемо через функцію користувача FnWriteToSQL, яка заносить новий запис в DEVICE з ім’ям DevDB та полями Name, Water, Sugar, Flour, Salt, Yeast, Milk. На рис. 18 показано лістинг цієї функції. 

<a href="media8/8_18.png" target="_blank"><img src="C:\san\народн посібн атпв\gitver\scadahmi\database\media\8_18.png"/></a> 

*Рис. 18.* Лістинг функції Cicode записування нових записів в БД 

Теоретичне заняття розробив [Олександр Пупена](https://github.com/pupenasan). 