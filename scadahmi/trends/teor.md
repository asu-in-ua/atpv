[<- До підрозділу](README.md)

# Розроблення підсистеми трендів

## 1. Модель трендового контуру 

Підсистема трендів призначена для ведення історії зміни значень числових величин у часі з можливістю їх подальшого вилучення для перегляду або додаткового оброблення. Якщо розглядати цю підсистему через призму функціонального призначення, то слід виділити такі функції (рис. 1):

- вимірювання значення даних з об’єкта керування;

- оброблення даних на пристрої збору (наприклад ПЛК);

- зчитування даних з пристрою збору та їх обробка в базі даних реального часу (БДРЧ);

- зчитування даних з бази даних реального часу та їх обробка в підсистемі трендів; 

- записування даних в архівну базу даних (БД);

- зчитування архівних даних з БД із зазначенням певних критеріїв, їх обробка та відображення. 

<a href="media/7_1.png" target="_blank"><img src="media/7_1.png"/></a> 

*Рис. 1* Модель трендового контуру для однієї змінної процесу 

Ці функції формують ланцюжок, який у цьому посібнику будемо називати ***трендовим контуром\***. Схема моделі трендового контуру для однієї змінної процесу показана на рис. 1. Вона може відрізнятися залежно від реалізації, тим не менше представляє більшість процесів, які відбуваються в SCADA та в деяких операторських панелях для формування архівних записів та доступу до них. Така модель дає можливість звернути увагу на певні нюанси налаштувань, тому може бути корисною читачеві для розуміння. 

З моделі видно, що підсистема трендів (позначена як TREND) не функціонує сама по собі. Дані надходять з інших підсистем, як правило (але не обов’язково), з бази даних реального часу (БДРЧ). У деяких SCADA підсистема виділяється як окремий трендовий сервер, тому в ній є свої трендові теги (на рис. 1 позначений як "тег TRND").  Тег у базі даних реального часу для змінної процесу зчитується через підсистему введення/виведення з контролера або аналогічного пристрою (позначений як ПЛК). Той отримує значення з каналу вимірювання. Отримані значення підсистема трендів зберігає в певній базі даних. Збережені дані використовуються надалі для різних підсистем. Найпростіший випадок, коли дані відображаються у вигляді трендів у підсистемі HMI. Тим не менше архівні дані можуть використовуватися для аналітичних функцій чи інших цілей. Зрештою контур замикається через оператора, який, отримавши необхідну інформацію приймає певні рішення і виконує дії, які для спрощення не показані на рис. 1.       

Таким чином, проектування та розроблення підсистеми трендів можна розглядати в 2-х площинах – серверній, де відбуваються операції записування та вилучення даних в/з базу даних історії, та клієнтській, де відбувається їх представлення зацікавленій особі. Серверна частина по суті представляє собою спеціалізовану СКБД (систему керування базами даних), а клієнтська, як правило, реалізована у вигляді спеціальних засобів для перегляду даних трендів (у графічному або табличному вигляді), підсистеми звітів або інших підсистем. Підсистема звітів розглядається в підрозділі 8.5; у цьому розділі зупинимося тільки на графічних переглядачах.  

За необхідності збирання великої кількості даних, наприклад з кількох відділень виробництва, для їх попереднього оброблення і передачі на верхні рівні керування використовуються спеціалізовані програмні засоби, які прийнято називати Historian (Істориками). Враховуючи, що Historian мають набагато більшу функціональність, ніж збирання і архівування трендових даних, а їх призначення – інтеграція з верхніми рівнями керування, вони розглядаються в підрозділі 9.3 посібника.   

## 2. Збереження трендових даних

Функція збереження зводиться до формування запису в базі даних, що відповідає за тренд. Під ***трендовим*** ***записом*** (***trend*** ***record***) будемо розуміти структурований об’єкт у базі даних трендів (див. рис. 1), що відповідає за відмітку значення та інших властивостей тегу або інших об’єктів SCADA із зазначенням часу, коли створився цей запис (або відбулося вимірювання), а також додатковими статусними відмітками, зокрема якістю значення. 

Для означення серверної частини у більшості SCADA/HMI необхідно виконати такі дії:

1) сконфігурувати серверний компонент, якщо він виділений як окрема підсистема;

2) вказати базу даних, куди буде записуватися тренд;

3) вказати періодичність або подію, при якій буде відбуватися записування;

4) вказати змінну або вираз, значення якого буде використовуватися для записування; 

5) означити структуру (перелік полів) запису;

6) вказати глибину збереження. 

У SCADA-програмах, з явно виділеним серверними компонентами (***трендовий сервер***) для трендів потрібно вказати їхні параметри. Оскільки в такому випадку трендовий сервер є окремим застосунком, до якого можуть підключатися клієнти, що знаходяться на інших пристроях, то при налаштуванні вказують:

- назву сервера;

- мережну адресу (як правило, IP);

- TCP/UDP-порт.

SCADA-програми можуть працювати як з пропрієтарними (власними) форматами баз даних, так і з відкритими з використанням сторонніх СКБД. У першому випадку постачальник SCADA-програми сам означує формат бази даних, забезпечує записування у файли, вибірку, індексацію і т. п. і вирішує проблеми швидкості операцій та оптимізацію. Враховуючи, що трендовий сервер є частиною SCADA, це дає можливість постачальникові максимально оптимізувати роботу сервера. Для добре оптимізованих трендових серверів пропрієтарний формат має, мабуть, лиш одну незручність – неможливість безпосереднього підключення до БД сторонніх клієнтів. Однак, якщо SCADA має засоби експорту даних або відкритий інтерфейс доступу, ця особливість не є проблемою. Обговорення переваг і недоліків форматів збереження наведено також у підрозділі 9.3.   

У випадку використання відкритих форматів БД трендовий сервер по суті є клієнтом для сторонніх СКБД, які забезпечують роботу з базою даних. У цьому разі на моделі, що представлена на рис. 1 треба було б БД показати в складі окремої СКБД. У такій ситуації розробник проекту для SCADA повинен означити базу даних, таблиці в ній, а також налаштувати доступ. При доступі до сторонніх СКБД часто використовуються відкриті стандарти, типу ODBC, OLEDB, ADO.NET. Це дає можливість використовувати практично будь-які СКБД сторонніх постачальників. Цей спосіб потребує інсталяції додаткового ПЗ, його налаштування, а для платних СКБД – також його закупівлі. Серед можливих проблем, які можуть виникнути при цьому, – погана оптимізація доступу через особливості СКБД або інтерфейсу. Додатково про відкриті стандарти доступу до БД можна почитати в підрозділі 8.3 посібника.        

Тренди потрібні для відслідковування зміни значення змінної (тегу) від часу. В ідеалі зацікавленій особі необхідні дані з якнайменшою періодичністю, однак фактично є кілька чинників, які потребують означення періодичності записування:

- дані не має сенсу записувати частіше ніж вони зчитуються із джерела;

- одні змінні змінюються в проекті відносно дуже часто, інші дуже рідко;

- значення, як правило, не змінюється, і при періодичному записуванні вони будуть повторюватися;

- періодичність записування впливає на об’єм даних, які необхідно зберігати і оброблювати;

- для порційних виробництв (Batch) величина змінної має значення тільки тоді, коли в обладнанні проходить приготування продукту або інша операція. 

У багатьох SCADA-програмах є можливість вказати подію, при якій буде відбуватися формування запису. Як правило, доступні такі варіанти:

- періодично (циклічно): запис створюється з указаною періодичністю незалежно від того, чи відбулися якісь зміни в джерелі даних;

- спорадично, за зміни значення: записування відбувається тільки при зміні стану змінної: 

  - зміна якості змінної; 

  - для дискретних і цілочисельних змінних – це зміна значення; 

  - для змінних з плаваючою комою – це зміна значення з урахуванням зони нечутливості;  

- за подією: записування відбувається при виникненні події, наприклад, за виконання певної умови;

- комбіновано: комбінацією наведених вище умов.   

У всіх програмах SCADA/HMI є можливість вести записування значення змінної (тегу), у деяких можна також проводити записування результату певного виразу або результату виконання функції чи скрипту. 

У багатьох системах існують вимоги до формування в трендових записах відмітки часу. Більшість SCADA формують її рівною часу, коли відбувалося збереження. Хоч відмітку часу можна записувати з точністю до мілісекунд, що б мало точно відображати, коли відбулися зміни, фактично це не відповідає дійсності. Це добре видно на моделі контуру, що показана на рис. 1. Спочатку відбувається зміна на об’єкті, потім є певне запізнення в каналі вимірювання і зміна відбувається в ПЛК (або засобі введення/виведення), після чого з певним запізненням значення буде прочитано підсистемою введення/виведення SCADA. Після оброблення в БДРЧ дані будуть доступні підсистемі трендів. Якщо архівування відбувається через СКБД і використовується відмітка часу формування запису, то значення буде ще старішим. При проектуванні, виборі рішення та засобів автоматизації цю особливість треба чітко розуміти. Деякі SCADA дають змогу формувати в записі відмітку часу, рівною отриманою з підсистеми введення/виведення. Є рішення, де відмітка часу зчитується з ПЛК, а там формується безпосередньо в модулі вимірювання. Якщо необхідні відмітки часу з точністю до мілісекунд, то очевидно потрібні рішення, що ґрунтуються на веденні архівних записів безпосередньо в засобі вимірювання.    

Деякі SCADA/HMI програми дають можливість також означувати поля, які можна записувати, тобто формувати структуру трендового запису. Це дає можливість оптимізувати базу даних, налаштувавши її під конкретне завдання.

Глибина збереження може задаватися як через налаштування часу максимально старих даних, так і через значення максимального об’єму (наприклад, через кількість записів або максимальний розмір пам’яті). У цьому випадку вказують, що необхідно робити зі старими записами.   

## 3. Відображення трендових даних 

У більшості випадків тренди відображаються у вигляді графіків залежностей значення від часу. Тим не менше, деякі SCADA/HMI дають можливість відображати дані у вигляді таблиць, навіть з можливістю зміни їх значення. У будь-якому випадку конфігурування засобів відображення потребують означення даних, які необхідно відобразити на переглядачах. Це робиться через вказівку джерела даних, наприклад, через ім’я змінної та додаткові фільтри. 

При використанні відкритих СКБД може знадобитися повне означення джерела даних у базі даних. Тобто переглядач трендів може бути незалежним від конфігурації сервера. З одного боку, це рішення дуже гнучке, оскільки дає можливість переглядати записи сторонніх SCADA/HMI, а з іншого – як правило, не оптимізоване для даних завдань.

Окрім джерела даних, у переглядачі необхідно означити:

- вісь часу: глибина, відображення шкали, означення відміток;  

- вісь значення: діапазон значень, відображення шкали, означення відміток;

- спосіб відображення лінії тренду, наприклад, пунктирну лінію, колір;

- мітки тренду, наприклад, прямокутник чи коло;

- спосіб згладжування між точками (інтерполяція);

- панель інструментів з командами.

Переглядачі трендів можна використовувати для різних цілей. Це треба враховувати при проектуванні ЛМІ. Тренди можуть бути частиною дисплейних мнемосхем, тоді, як правило, вони є трендами реального часу, які автоматично прокручуються і не мають елементів керування. Для аналізу ретроспективних даних, переглядачі займають окремі дисплеї, які мають елементи керування, що дають можливість:

- налаштувати діапазон часу відображення;

- вибирати криві та налаштовувати їх відображення;

- прокручувати вісь часу;

- масштабувати відображення;

- показувати значення кривих у конкретній точці часу з використанням курсору;

- експортувати дані активного відображення трендів;

- змінювати зовнішній вигляд переглядача та ін.;

- збереження/читання налаштувань переглядача. 

Для зручності відображення та аналізу криві групують разом, налаштовують їх відображення і зберігають як єдиний набір, який ми зватимемо ***групою кривих***. У більшості SCADA така функціональність підтримується в режимі виконання, що дає можливість операторові налаштовувати відображення у зручному для себе вигляді і зберігати для швидкого доступу. В іншому випадку розробникові необхідно заздалегідь передбачити усі групи як окремі дисплеї. 

# Контрольні запитання 

1.    Що таке тренд? Чим відрізняються тренди реального часу від історичних?

2.    Які функції виконує підсистема трендів?

3.    Розкажіть про функціонування трендового контуру.

4.    Які функції серверної частини і клієнтської частини підсистеми трендів?

5.    Що необхідно сконфігурувати в серверній частині підсистеми трендів? Покажіть це на прикладі однієї із SCADA/HMI.

6.    Навіщо визначати для трендів періодичність записування та глибину збереження? Як пов’язані ці властивості та яким чином їх вибирати/розраховувати? Покажіть це на прикладі однієї із SCADA/HMI.

7.    За якими подіями може відбуватися записування значень змінних в історію? 

8.    Які формати даних може підтримувати SCADA-програма для записування трендових архівів? На що це впливає? Покажіть це на прикладі однієї із SCADA/HMI.

9.    Розкажіть про особливості формування відмітки часу в трендових архівах.  

10.    Розкажіть про можливості переглядачів трендів (самописців). Покажіть це на прикладі однієї із SCADA/HMI.

11.    Як показуються змінні на самописцях і як їх відрізняти між собою? Покажіть це на прикладі однієї із SCADA/HMI.

12.    Які інструменти, як правило, доступні для визначення значення змінної в конкретній точці? Покажіть це на прикладі однієї із SCADA/HMI.

13.    Що, як правило, треба означити для переглядачі трендів? Покажіть це на прикладі однієї зі SCADA/HMI.

14.    Яка функціональність доступна через групу кривих? Покажіть це на прикладі однієї із SCADA/HMI.

Теоретичне заняття розробив [Олександр Пупена](https://github.com/pupenasan). 
