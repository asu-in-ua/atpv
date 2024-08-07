[<- До підрозділу](README.md)

# Підсистема звітів

## Загальні підходи

Для аналізу подій і тривог, тенденції зміни технологічних параметрів протягом певного часу можна скористатися відповідними переглядачами. Крім виведення на екран, вони дають змогу виводити тренди та журнали на принтер. Не дивлячись на те, що в цей спосіб можна вивести багато корисної детальної інформації, вона не є достатньо обробленою для отримання показників ефективності роботи процесу чи установки. Для виведення загальних показників застосовують звіти. 

***Звіт*** (Report) – це документ або сторінка, сформовані на основі означеного для нього формату та статистично оброблених плинних чи історичних даних. У ***форматі звіту*** позначується розміщення та призначення полів, а при генеруванні звіту ці поля заповнюються конкретними значеннями. Крім полів, вміст яких залежить від даних, формат звіту може вміщувати статичну графічну та текстову інформацію.

Звіти можуть генеруватися автоматично, наприклад, у разі виникнення події чи тривоги, або періодично в зазначений астрономічний час. Також вони можуть генеруватися за запитом оператора. Звіт може мати вигляд надрукованого документа, файлу формату PDF, RTF, TXT, CSV, HTML сторінки або таблиці Excel чи якоїсь бази даних. Звіти у вигляді текстових документів насамперед цікавлять керівний персонал, якому вони потрібні для аналізу технологічного процесу. Електронні таблиці потрібні для ведення автоматизованого загальновиробничого обліку (наприклад, передача на рівень керування виробництвом та підприємством). Наприклад, кількість спожитої теплоенергії можна використати для розрахунку собівартості продукції. Звіти можуть бути оформлені у вигляді онлайн сторінки з основними показниками (наприклад, для відображення KPI) – це так звані ***Dashboard***. 

Підсистема звітів може бути частиною SCADA/HMI або реалізована зовнішніми програмними засобами, як правило, набагато функціональнішими. Зовнішня підсистема звітів може бути оформлена у вигляді окремого програмного сервера з Веб-доступом, який приймає запити на формування звіту через HTPP API і генерує їх у форматі HTML. 

У будь-якому випадку вхідними для підсистеми звітів є:

- джерело даних, яке використовується для вибірки та представлення необхідної інформації у звіті; 

- формат звіту, який указує, як саме виглядатиме звіт (наприклад файл RTF, XML);

- параметри, які використовуються у форматі звіту для уточнення того, як слід генерувати звіт (наприклад, діапазон дат, за який необхідно вивести звіт, або назва даних). 

Джерелом даних можуть бути як дані реального часу, так і база даних або файли (наприклад XML, CSV). Доступ до цих даних із підсистеми звітів може проводитися з використанням технологій, розглянутих у 8.3. Часто для формування вибірки використовується мова SQL.

Формат звіту, як правило, створює окремий редактор. Це може бути файл або для онлайн звітів – онлайн форма. У ряді підсистем формат звіту можна не задавати, користувач на льоту налаштовує вигляд звіту (Dashboard) через онлайн сторінку. Формат звіту включає означення даних (поля), які будуть використовуватись у звіті. При використанні даних з БД вказується джерело даних та фільтри для запиту (наприклад, запит мовою SQL). У форматі налаштовується зовнішній вигляд, який може включати кілька розділів, які задають позицію і зміст звіту. Оскільки офлайн звіт – це окремий документ, він може містити усі частини такого документа. Тому можна виділити кілька типів розділів: 

- титул (title), або титульний аркуш (title page), з якого починається звіт;

- заключна сторінка (back page, last page);

- сторінки, кожна з яких може включати:

  - заголовок, колонтитул (header), який повторюється зверху кожної сторінки; 

  - деталі, безпосередньо зміст сторінки (detail);

  - нижній колонтитул (footer), який повторюється внизу кожної сторінки;

- фон.

Деталі сторінки можуть включати таблиці, які можуть потребувати заголовки (header), що повторюватимуться на кожній сторінці, і рядок зведення (summary), який буде заключним.

Параметри звіту можна сприймати як формальні параметри функції, яка генерує звіт. 

У наступних параграфах розглянемо приклад налаштування звітів у різних редакторах SCADA/HMI та сторонньому – Jaspersoft.

## Контрольні запитання

1.      Яке призначення звітів? Якої функціональності звітів немає в трендах, журналах подій та тривог?
2.      Які можуть бути форми звітів? В яких випадках використовується кожна з них? 
3.      Навіщо потрібен формат звіту? Що в ньому задається? 
4.      Які відкриті формати звітів Ви знаєте? 
5.      Що передається на вхід підсистеми звітності?
6.      З яких частин, як правило, складається офлайн звіт? Покажіть на прикладі однієї з SCADA/HMI або JasperSoft як задається формат звіту. 

 

Теоретичне заняття розробив [Олександр Пупена](https://github.com/pupenasan). 
