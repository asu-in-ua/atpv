[<- До підрозділу](README.md)

# Підсистема трендів в SCADA Citect

У SCADA Citect збереженням (реєстрацією) даних на диску з можливістю їх перегляду у вигляді тренду займається ***трендовий сервер*** (Trend Server). Окрім збереження, трендовий сервер також обслуговує запити від клієнтів (наприклад, від Process Analyst) на читання архівних даних. Оскільки у Citect підтримується розподілена кластерна структура (див. параграф 9.1.6), трендовий сервер може запускатися окремим процесом на окремому ПК. Тому в проекті для Trend Server явно конфігурується ім’я, адреса ПК, на якому планується запускати сервер, TCP-порт та кластер. Для standalone рішень ці настройки залишаються за замовчуванням, оскільки усі компоненти запускаються на тому самому ПК.

Слід зазначити, що, окрім трендового сервера, збиранням та збереженням даних для їх аналізу та формування звітів займається окремий програмний пакет – Historian. Враховуючи, що Schneider Electric забезпечує інтеграцію продуктів Citect та Historian, деякі налаштування стосуються означення доступу до Historian.    

Значення, які необхідно зберігати в тренді, означуються через ***теги трендів***, в яких вказується вся необхідна для записування в трендові файли інформація. Ці об’єкти в якості джерела даних беруть значення з інших тегів, у тому числі зі змінних тегів (рис. 7.2), хоч в якості значення можна записувати результат виразу з комбінацією будь-яких об’єктів. Таким чином, трендовий сервер слідкує за тим, коли необхідно зробити розрахунок виразу і коли треба зробити запис у файлі. Також до його завдань входить формування відповіді на запитування архівних даних. Безпосередніми клієнтами для трендового серверу можуть бути:

- графічні об’єкти для перегляду трендів: Trend та Process Analyst;

- спеціальна Cicode-функція "TrnGetTable" для отримання даних у вигляді масиву;

- функції Cicode для експорту даних: у буфер – "TrnExportClip", в файл CSV – "TrnExportCSV", або у файл DBF – "TrnExportDBF".   

Для перегляду даних у вигляді трендів у графічній підсистемі використовуються два типи об’єктів "Тренд" (Trend) та "Аналізатор процесів" (Process Analyst). Графічний об’єкт "Тренд" може відображати тільки архівні дані з тегів тренду. Аналізатор процесів, окрім архівних даних, що означені в тегах трендів, може відображати дані реального часу. 

![](media/7_2.png)

*Рис. 7.2*.Принципи роботи трендової підсистеми в Citect

Форму налаштування тегу тренду показано на рис. 7.3. Для тегу тренду означується назва, яка може збігатися з назвою змінних тегів або тегів тривог. У полі "Выражение" вказується Cicode вираз, що повертає якесь числове значення. Це може бути як змінна, як це показано на рис. 7.3, так і вираз або функція, наприклад "(LOOP_1_PV + LOOP_2_PV)/2". 

Трендовий сервер розраховує значення вказаного виразу з періодичністю, зазначеною в полі "Интервал опроса". Якщо в цьому полі з'являється десяткове число, то воно буде інтерпретуватися як секунди. Періодичність можна також задати у форматі "hh:mm:ss". Поле "Интервал опроса" є опціональним, за замовченням приймається 10 с. Слід звернути увагу, що при зміні цього значення треба видалити раніше створені архівні файли для даного трендового тегу, щоб зміни вступили в силу. 

<a href="media/7_3.png" target="_blank"><img src="media/7_3.png"/></a> 

*Рис. 7.3.* Налаштування тегу тренда

У Citect доступні три способи ініціювання записування, які вказуються в полі "Тип". ***Періодичний тренд*** (тип TRN_PERIODIC) записує дані постійно із зазначеним періодом. Можна також вказати ***тригер*** (поле "Триггер"), який буде активувати або деактивувати ведення записування. Запис в архів проводиться тоді, коли тригер = TRUE або не вказаний (рис. 7.4). 

![](media/7_4.png)

 *Рис. 7.4.* Періодичний тренд (тип TRN_PERIODIC) 

***Подієвий тренд*** (тип TRN_EVENT) записує дані тільки в момент зміни значення тригера з FALSE в TRUE. Між точками запису проводиться інтерполяція (рис. 7.5).  

![](media/7_5.png)

*Рис.7.5.* Подієвий тренд (тип TRN_EVENT)

***Періодично-подієвий тренд*** (тип TRN_PERIODIC_EVENT), як і попередній, записує дані тільки в момент зміни значення тригера з FALSE в TRUE. Але цей тип тренду не робить інтерполяцію між точками запису (рис. 7.6.)

![](media/7_6.png)

*Рис. 7.6.* Періодично-подієвий тренд (тип TRN_PERIODIC_EVENT)

У полі "Имя файла" можна вказати шлях та ім’я файлу (без розширення) для тегу тренду. Наприклад, "[data]:loop1pv" вказує, що архівні файли будуть розміщуватися в папці, означеній параметром "DATA" з назвою "loop1pv". Якщо ім’я файлу не вказане, воно береться з імені тегу тренду, а шлях папки – зі значення параметру "DATA".

Глибина збереження архіву та кількість архівних файлів для кожного тегу тренду означується значеннями полів "Число файлов", "Время" та "Периодичность". Властивість "Число файлов" вказує на кількість архівних файлів (за замовченням береться 2). Файли синхронізовані відносно часу, вказаного в полі "Время", а кожен файл буде зберігати дані відповідно до вказаної періодичності. При першому запуску системи виконання будуть створені усі необхідні файли для ведення історії. Під час роботи системи дані будуть зберігатися в кожному з цих файлів, поступово переходячи від одного файлу до іншого з вказаною періодичністю (значення "Периодичность"). Коли закінчується час записування в останній файл, система знову переходить до 1-го файлу, затираючи старі архівні значення. Розглянемо це на прикладі, де означено кількість файлів рівною 10, періодичність 24:00:00, а час синхронізації ("Время") – 00:00:00.

1. При першому запуску системи будуть створені усі 10 файлів із зазначеним ім'ям та з розширеннями ".000"… ".009" та один файл із розширенням ".HST". Спочатку Citect пише архівні дані у файл з розширенням ".000".

2. Опівночі, наступного дня, дані будуть записуватися у файл з розширенням ".001".

3. Опівночі, третього дня, дані будуть записуватися у файл з розширенням ".002" і т. д.

4. Після 10-ти днів система почне переписувати перший файл, тобто ".000". 

Слід звернути увагу, що при зміні будь-яких значень кількості або періодичності історичних файлів треба видалити раніше створені архівні файли для даного тегу тренда, щоб зміни вступили в силу.

Властивість "Метод сохранения" вказує на спосіб і величину збереження числових даних. Якщо не потрібна велика точність, варто використовувати "Scaled (2-byte samples)". Одиниці вимірювання і формат вказуються для відображення їх на осі, курсорі Аналітика процесів та на інших числових полях. Така необхідність спричинена можливістю використання кількох змінних у формуванні значення трендового тегу. Зона і привілеї налаштовуються для обмеження доступу (див. параграф 8.7.6). 

У нових версіях Citect з’явилися додаткові можливості і відповідно налаштування. Зокрема масштаб задається для формування масштабу відображення за замовчуванням. Властивість "Собрать статистику" (Historize) вказує на автоматичне формування історичного тегу в спеціалізованому продукті Schneider Electric's Historian.

Клієнтська частина підсистеми трендів представлена графічними об’єктами переглядачів трендів, які можна розміщувати в будь-якій кількості на будь якій дисплейній сторінці, а також функціями Cicode.  

Об’єкт "***Тренд***" – переглядач трендів Citect, який був доступний ще з ранніх версій. Він дає можливість відобразити до 8-ми архівних значень тегів тренду. Для кожного пера (кривої) вказується назва тегу тренду та колір (рис. 7.7). Властивість "Число выборок данных" вказує на кількість записів у файлі історії, які будуть відображатися для кожного тегу тренду. За допомогою властивості "Пикселов на выборку" вказуються проміжки між двома точками одного пера на графіку. Ширина об’єкта "Тренд" пов’язана з цими властивостями:  

```
Ширина = "Пикселов на выборку" x Число выборок данных" (7.1)
```

Указати діапазон значень у часових розмірах можна за допомогою Cicode функції, наприклад TrendSetSpan.

Об’єкт "Тренд" має дуже мало можливостей налаштування в середовищі розроблення. Усі можливості навігації по історії, відображенню значень, налаштуванню області відображення та багато іншого реалізовуються через функції Cicode. Для спрощення використання трендів на базі об’єкта "Тренд" у включених проектах Citect є спеціальні сторінки, джини та суперджини. Тим не менше, більш функціональнішим у використанні трендів є об’єкт "Аналізатор процесів".

![](media/7_7.png)

*Рис. 7.7.* Об’єкт "Тренд"

***Аналізатор процесів*** (Process Analyst) дає можливість відображати в часі значення тегів трендів, змінних тегів а також тегів тривог. Аналізатор процесів має такі можливості:

- налаштування всіх параметрів відображення як у середовищі розроблення, так і в середовищі виконання;

- добавлення і відображення на одному елементі тренду кількох панелей (умовно незалежних трендових елементів) це дає можливість:

  - групувати криві разом за певною ознакою;

  - порівнювати тренди;

  - здійснювати відносний зсув панелей за часом; 

- відображення на панелі об’єктів:

  - трендів у реальному часі зі змінних тегів;

  - архівних трендів з трендового серверу;

  - зміни стану тривог у часі з тривогового сервера;

  - архівних трендів та трендів реального часу з Historian; 

- добавлення на тренд (конкретну панель) кривих реального часу та за архіву:

  - числових змінних;

  - дискретних змінних;

  - стану тривог; 

- відображення кривих (пер, pen) тренду у вигляді (рис. 7.8):

  - ліній різного кольору, товщини та формату: неперервної, штрихової, пунктирної і т.п.;

  - різного типу ліній залежно від якості (достовірності) та наявності даних;

  - точок даних у форматі різних фігур;  

- відображення та налаштування по осях X та Y для кожної кривої (рис. 7.9):

  - сітки і поділок; 

  - діапазону, можливості автомасштабування;

  - можливості прокручування (див.рис. 7.10);

  - відображення шкали для вибраної кривої;

- у режимі виконання використання кнопок перемотування (див. рис. 7.10)

  - "<" – на половину інтервалу назад; 

  - " <<" – на один інтервал назад;

  - " >" – на половину інтервалу вперед; 

  - " >>" – на один інтервал уперед;

- у режимі виконання для кривих

  - зціплювати криві разом;

  - синхронізувати з плинним часом;

- виведення легенди з можливістю:

  - швидкої зміни основних властивостей кривих;

  - відображенням числового значення трендів у потрібній точці часу через курсор;

- збереження відображених даних у форматі XLS або TXT; 

- збереження заданих налаштувань (представлення) у файл "*.PAV" з указаним ім’ям для можливості відкриття налаштувань звичайним вибором;

- керування та налаштування з Cicode функцій та VBA. 

<a href="media/7_8.png" target="_blank"><img src="media/7_8.png"/></a> 

*Рис.7.*8. Налаштування кривої тренду

<a href="media/7_9.png" target="_blank"><img src="media/7_9.png"/></a> 

*Рис. 7.9.* Налаштування координатних ліній та осей

<a href="media/7_10.png" target="_blank"><img src="media/7_10.png"/></a> 

*Рис. 7.10.* Загальний вигляд Аналітика процесів у середовищі виконання

Окремо варто зупинитися на функції відображення на панелі трендів стану тривог (рис. 7.11). 

<a href="media/7_11.png" target="_blank"><img src="media/7_11.png"/></a> 

*Рис. 7.11.* Загальний вигляд Аналітика процесів в середовищі виконання

Кожен стан тривог (неактивна 4, активна непідтверджена 1, активна підтверджена (3), неактивна непідтверджена 2) відображається на панелі трендів у вигляді прямокутника певної висоти і контуру. Для аналогових тривог можна також змінювати колір для різної мітки. 

Окрім трендів, Citect має можливість з використанням спеціальних функцій відображати залежності у форматі графіку X від Y.

Теоретичне заняття розробив [Олександр Пупена](https://github.com/pupenasan). 