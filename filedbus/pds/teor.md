[<- До підрозділу](README.md)

# Стандарт на універсальний інтерфейс PDS

## 1. Способи інтеграції PDS в автоматизовані системи управління

### Класичний підхід

З розвитком систем управління електроприводами PDS (Power Drive Systems) виникла необхідність в їх інтеграції у єдину автоматизовану систему для дистанційного управління та контролю за двигунами. Класичним підходом до підключення таких систем вважається використання уніфікованих аналогових, дискретних та імпульсних(частотних) сигналів. Наприклад, для управління частотним перетворювачем виділяється один аналоговий вихід контролера, який підключається до аналогового входу частотного перетворювача, що відповідає за задане значення частоти (швидкості) обертів двигуна. Дискретні входи перетворювача використовуються для зупинки та запуску двигуна, переключення частоти, а виходи – для контролю за станом двигуна, аваріями. Аналогові виходи частотного перетворювача використовуються для контролю за плинною швидкістю, напругою, струмом і т.д. 

### Переваги використання промислових мереж

Зі збільшенням інформаційного обміну між контролерами та частотними перетворювачами, значно збільшується кількість необхідних каналів, що приводить до додаткових витрат як на засоби автоматизації, так і на інсталяцію та експлуатацію систем. Використання промислових мереж дає змогу ефективно використовувати всі ресурси частотних перетворювачів незалежно від кількості задіяних функцій, покращити завадостійкість та збільшити дальність зв’язку. Крім того, підключення по цифровим інтерфейсам дає додаткові можливості та зручність при конфігуруванні частотних перетворювачів, зокрема віддалене налагодження, збереження плинної конфігурації, її перенесення ні інші приводи і т.д. 

### Проблеми використання промислових мереж

З появою промислових мереж в системах PDS, конфігурація та дія систем управління стали сильно залежати від архітектурних рішень, вибраних для інтеграції їх в загальний процес управління. Ці рішення суттєво відрізнялися одне від одного, однак вирішували однакові за типом задачі. І для виробників автоматизованих систем управління і для виробників обладнання виникла необхідність в стандартизації підходів. 

## 2. Стандарт на універсальний інтерфейс PDS 

### 2.1. Загальні підходи до стандартизації інтерфейсу PDS

#### Ідея створення та призначення стандарту

Ідеєю створення стандартів для цифрових комунікацій електроприводів було об’єднання декількох промислових рішень, шляхом виділення загальних елементів, структури для створення універсального інтерфейсу та профілів для PDS. Враховуючи, що для PDS систем вже функціонувало декілька стандартів в загальній серії IEC 61800 "Adjustable speed electrical power drive systems", а також відсутність на той момент функціонуючих стандартів МЕК на промислові мережі, нові стандарти на інтерфейс електроприводів увійшли до групи 61800, як частина 7. Таким чином стандарти 61800-7 описують універсальний інтерфейс між системою автоматизації та PDS. 

#### Місце Універсального Інтерфейсу в логічній структурі системи управління PDS 

Згідно концепції 61800-7, модель системи PDS представляє собою поєднання приводу, тобто безпосередньо модуля PDS, двигуна та комунікаційного інтерфейсу приводу. Таку модель будемо називати Логічним PDS (Logical Power Drive System) або просто Логічним Приводом. Функції управління Логічним Приводом реалізовуються в одному або більше Логічних Контролерах, та виконуються у відповідності з прикладною програмою управління. Таким чином структура автоматизованої системи являє собою поєднання Логічного приводу разом з Логічним контролером. Перший стандарт 61800-7-1 є базовим і визначає Універсальний Інтерфейс (Generic Interface) доступу до Логічного Приводу з боку Логічного Контролера.  

#### Функціональні можливості Логічного Приводу 

Функціональні можливості Логічного Приводу можуть бути розділені на: управління позиціонуванням (position-control), управління швидкістю (velocity-control) та управління моментом (torque-control). В залежності від реалізованих функцій Логічного Приводу, їх фізична структура згідно стандарту 61800-7-1 буде відрізнятися. На рис.11.1(а) показана структура автоматизованої системи управління, в якій Логічний Привод повинен управляти моментом двигуна. В цьому випадку прикладна програма через промислові мережі видає значення заданого моменту. Універсальний PDS інтерфейс забезпечує однаковий, з точки зори прикладної програми, спосіб зміни заданого моменту, незалежно від виробника приводу. Аналогічно на рис.11.1(б) та рис.11.1(в) показані структури систем відповідно управлінням швидкістю та управління позиціюванням, де прикладна програма керуючого пристрою задає необхідні швидкість та позицію. Функції, які відсутні в структурі пристрою PDS, можуть бути реалізовані в керуючому пристрої (контролері).

<a href="media11/11_1.png" target="_blank"><img src="media/1.png"/></a> 

Рис.11.1. Фізична структура різних типів систем PDS

Слід звернути увагу на місце розміщення універсального інтерфейсу PDS. Це логічний а не фізичний інтерфейс. Якщо стандарти промислових мереж визначають правила спряження між пристроями, то стандарти IEC 61800-7 визначають правила роботи з об’єктами Логічного Приводу, доступ до яких буде проводитись через конкретні промислові мережі. Це значить, що одні і ті ж профілі IEC 61800-7 можуть функціонувати на різних типах промислових мереж. 

#### Місце PDS в типовій структурі автоматизованої системи. 

З точки зору типової структури управління, PDS є польовим пристроєм. На рис.11.2 показане місце пристрою PDS в типовій структурі автоматизованої системи та його зв’язки з іншими засобами. 

<a href="media11/11_2.png" target="_blank"><img src="media/11_2.png"/></a> 

Рис.11.2. Місце PDS в типовій структурі автоматизованої системи 

Фізично модуль PDS може з’єднуватись для передачі різних типів даних: 

1. Дані вводу/виводу (IO Data). Цей інтерфейс є частиною інтерфейсу PDS, який забезпечує управління та контроль приводу. 

2. Параметри пристрою (Device Parameters). Цей інтерфейс забезпечує доступ до параметрів пристрою для віддаленого конфігурування, моніторингу, діагностики. Параметри пристрою доступні через універсальний PDS інтерфейс.

3. З’єднання між польовими пристроями (peer to peer device). Цей інтерфейс забезпечує безпосереднє з’єднання між польовими пристроями. Він залежить від особливостей промислової мережі і не входить до універсального інтерфейсу PDS;

4. Параметри пристрою (інший або місцевий інтерфейс). Забезпечує доступ інженерних утиліт до параметрів пристрою через унікальний інтерфейс, який не входить до універсального інтерфейсу PDS.

5. Інтерфейс до процесу. Зв’язок з техноЛогічним процесом (датчики, виконавчі механізми) не охоплюється універсальним інтерфейсом PDS.

### 2.2. Функціональні елементи Логічного Приводу

#### Призначення Функціональних Елементів в Логічному PDS 

Логічний Привод складається з Функціональних Елементів (FE), які включають параметри та алгоритми для опису його поведінки. Для Логічного PDS доступні наступні FE (рис.11.3):

1. Функціональні Елементи ідентифікації пристрою (Device identification FE), які вміщують параметри для ідентифікації фізичних пристроїв: 

-     Profile ID (профіль);

-     Manufacturer ID (виробник);

-     Product ID (тип та модель пристрою);

-     Serial number (серійний номер);

-     Hardware revision (версія апаратного забезпечення);

-     Software revision (версія ПЗ);

-     Tag (поле користувача);

-     Location (мітка користувача);

-     Profile defined (додаткові параметри профілю).

2. Функціональні Елементи управління пристроєм (Device control FE), які включають автомат станів для управління станом приводу в залежності від тривог та попереджень. 

3. Комунікаційний Функціональний Елемент Логічного приводу (Communication FE), який складається з визначених комунікаційних параметрів мережі між керуючим пристроєм та приводу; а також включає автомат станів підключення пристроїв.

4. Базові Функціональні Елементи приводу (Basic drive FE), які вклю-чають базові функції управління позиціонуванням, швидкістю та моментом. 

5. Опціональні прикладні Функціональні Елементи (Optional application FE), які включають додаткові опціональні функції управління операцій з використанням вбудованих входів/виходів (енкодери, кінцеві вимикачі); не описуються стандартом; 

6. Функціональні Елементи іншого або місцевого інтерфейсу (Other interface FE). Комунікаційні можливості для Логічних Приводів, які не входять до стандарту IEC 61800-7.  

![img](media/11_3.png)

Рис.11.3. Функціональні Елементи в Логічному PDS

#### Основи використання FE для управління PDS  

Нагадаємо, що універсальний PDS інтерфейс використовується для двох різних призначень: для налаштування роботи та обслуговування приводу за допомогою інженерних утиліт і для управління приводом з прикладної програми (див. рис.11.2). У першому випадку використовуються такі типи операцій як ідентифікація, конфігурування, запис та зчитування параметричних даних, а управління Логічним Приводом з боку Логічного Контролеру (обмін даними процесу) в основному зводиться до управління та контролю трьох функціональних елементів: Device Control, Communication та Basic drive, а саме (див. рис.11.4):

-     відправка команди від прикладної програми до PDS (COMMAND);

-     відправка заданих значень від прикладної програми до PDS (Set Point);

-     відправка статусу від PDS до прикладної програми (STATUS);

-     відправка дійсних значень від PDS до прикладної програми (Actual Values).

#### Контроль та управління автоматом станів FE (COMMAND та STATUS)

Кожен з наведених вище Функціональний Елементів управляється автоматом станів. Тобто, в кожний момент часу Функціональний Елемент знаходиться у певному стані, який визначає його поведінку в даній ситуації. Визначити плинний стан Функціональних Елементів можна за допомогою змінної статусу (STATUS), а управляти станом – за допомогою команди (COMMAND). Перехід від стану до стану Функціональних Елементів проходить у момент отримання конкретної команди, або виникнення певної події у приводі. 

![img](media/11_4.png)

Рис.11.4. Використання універсального інтерфейсу для управління PDS

#### Device Control FE 

В універсальному інтерфейсі PDS закладений єдиний автомат станів для управління обробками помилок та стану PDS. Вона закладена в функціональному елементі Device Control. Якщо PDS не може забезпечити правильну роботу, то він переходить у стан помилки (Faulted State). Для переходу його у нормальний стан (No Faulted) необхідна команда скидання помилки (Reset Fault) з керуючого пристрою або локально, по місцю. 

Перед виникненням помилки, PDS може подати сигнал попередження (Warning). Враховуючи відсутність необхідності підтвердження попереджувального сигналу, він не входить до автомату станів. 

Таким чином автомат станів даного Функціонального Елементу включає всього два рівня: помилка і нормальний стан. Однак в залежності від профілю пристрою, кількість станів може бути розширена. Стани Device Control відображаються одним бітом змінної статусу, а для управління машиною станів використовується біт-команда на скидання помилки (Reset Fault). В залежності від профілю PDS додатково можуть бути використані і інші команди.

Через параметри Функціонального Елементу можна доступитись до буферу останніх помилок та попереджень, дізнатись про їх кількість, час виникнення тощо. 

#### Communication FE

Комунікаційний Функціональний Елемент вміщує всі автомати станів та параметри для доступних промислових мереж PDS. Якщо профіль підтримує декілька мереж, для PDS доступно декілька екземплярів комунікаційного FE. 

Функціональний Елемент може бути в двох станах: обмеженому комунікаційному (Limited communication) та нормальному комунікаційному (Normal communication) стані. В обмеженому комунікаційному стані PDS може тільки контролюватися але не управлятися з боку Універсального Інтерфейсу. Тобто управління доступне тільки через Other interface FE. В нормальному режимі для Універсального Інтерфейсу доступні функції управління. Доступ до певних параметрів приводу у нормальному режимі може бути обмежений через додаткові настройки та під-стани, визначені профілем. 

Комунікаційний стан відображається в змінній статусу у вигляді біту Normal Communication. При включенні живлення PDS, він переводиться у обмежений комунікаційний режим Для переводу в нормальний режим використовується біт-команда Run communication. Для профілів PDS, які підтримують синхронний режим додатково визначений біт статусу Synchronized та біт-команда Synchronize/Do not Synchronize.

Параметри Комунікаційного Функціонального Елементу визначають тип та настройки промислової мережі, та визначаються профілем.

#### Basic Drive FE 

Ці Функціональні Елементи включають автомати станів та параметри для управління базовими функціями PDS. В Універсальному Інтерфейсі PDS для автомату станів визначені такі стани:

-    operating –  PDS через локальний чи віддалений інтерфейс реагує на команди та задані значення, а також видає значення статусу та необхідні дійсні значення;

-    not operating – PDS через локальний чи віддалений інтерфейс не реагує на зміну заданого значення, однак приймає та реагує на команди;

Опціонально можуть бути визначені наступні стани:

-    local control – PDS приймає команди та задані значення через локальний інтерфейс;

-    remote control – PDS приймає команди та задані значення через віддалений інтерфейс.

В залежності від режиму роботи, профілем можуть бути визначені додаткові стани. 

Значення режимів контролюються через змінну відповідних бітів статусу Operating та Remote Control. 

При подачі живлення на PDS, він стартує у режимі not operating та  local control. Команда Operate переключає автомат станів між режимами operating та not operating. Біт-команди Local/Remote переводять привод у відповідний режим. 

В параметрах Basic Drive FE визначаються:

-     режим роботи PDS (application mode);

-     уставки даних вводу/виводу;

-     поведінка функціонального елементу PDS в залежності від режиму його роботи.

### 2.3. Прикладні режими PDS

####  Загальні положення

У залежності від доступних функцій апаратного та програмного забезпечення PDS, Логічний Привод може бути у декількох прикладних режимах:

- управління позиціонуванням (position-control),

- управління швидкістю (velocity-control);

- управління моментом (torque-control). 

В таб.11.1 наведене призначення обов’язкової уставки в залежності від вибраного режиму роботи. Можуть бути доступні також опціональні уставки. 

Таблиця 11.1. Призначення уставок в залежності від режиму роботи

| Прикладний Режим   (Application Mode)   | Уставка  Set-Point | Функції в PDS                                                | Рис.    |
| --------------------------------------- | ------------------ | ------------------------------------------------------------ | ------- |
| Torque Preset                           | індекс моменту     | розв’язане управління моментом                               | 11.5(а) |
| Torque Control                          | значення моменту   | розв’язане управління моментом                               | 11.5(а) |
| Torque Control with velocity feedback   | значення моменту   | управління моментом зі зворотнім зв’язком по швидкості       | 11.5(б) |
| Velocity Preset                         | індекс швидкості   | переключення на фіксовані швидкості з контролем моменту та швидкості | 11.6(а) |
| Velocity Control                        | значення швидкості | розв’язане управління моментом та швидкістю                  | 11.6(б) |
| Velocity Control with position feedback | значення швидкості | управління моментом та швидкістю зі зворотнім зв’язком по позиції | 11.6(в) |
| Position Preset                         | індекс позиції     | перехід приводу на фіксовані позиції по зворотному зв’язку   | 11.7(а) |
| Position Control                        | значення позиції   | управління позицією, швидкістю або  моментом                 | 11.7(б) |

#### Режим управління моментом 

В режимі управління моментом (див. рис. 11.5(а)) прикладна програма керуючого пристрою задає необхідний момент, який регулюється пристроєм PDS з використанням зворотного зв’язку (канал вимірювання) або з використанням розрахованого значення. Може бути використаний зворотній зв’язок по швидкості (див. рис. 11.5(б)).

![img](media/11_5.png)

 Рис.11.5. Режим управління моментом без (а) та з (б) зворотнім зв’язком по швидкості

#### Режим управління швидкістю 

Можливі три випадки режимів управління швидкістю:

1. Режим з наперед встановленими швидкостями (рис.11.6(а)), коли задані значення швидкостей виставляються в момент конфігурування PDS, а в момент операційного функціонування проводиться їх вибір по індексу.

2. Режим регулювання швидкості(рис.11.6(б)), де задане значення швидкості  задається в уставці; опціонально можна також задавати момент; опціонально підтримується передача дійсного значення моменту та швидкості.

3. Режим регулювання швидкості зі зворотнім зв’язком по позиції, який анаЛогічний попередньому, однак зі зворотнім зв’язком по датчику положення.  

#### Режим управління позиціонуванням

В режимі з наперед встановленими позиціями (рис.11.7(а)), в момент операційної роботи уставкою вибирається необхідна точка контролю позиції. Опціонально можливо вказати траєкторію між двома сусідніми точками. 

![img](media/11_6.png)

 Рис.11.6. Режими управління швидкістю: а – з наперед встановленими швидкостями; б – з регулюванням швидкості; в – зі зворотним зв’язком по позиції

В режимі управління позиціонуванням  (рис.11.7(б)) в уставці задається задана позиція. Опціонально можна задати необхідну швидкість та момент. Досягнення необхідної позиції сигналізується змінною стану. PDS може передавати прикладній програмі дійсні значення позиції, швидкості та моменту.  

![img](media/11_7.png)

Рис.11.7. Режими управління позиціонуванням: а – з наперед встановленими позиціями; б – з регулюванням позиції

### 2.4. Структура стандартів IEC 61800-7

####  Типи профілів PDS  

Крім базового стандарту на універсальний інтерфейс IEC 61800-7-1, в якому даються основні і загальні для всіх профілів концепції зв’язку та управління PDS, група стандартів також включає специфікації на профілі IEC 61800-7-200 (201-204) та їх відображення на промислові мережі IEC 61800-7-300 (301-304). На рис.11.8 показана структура всіє серії стандартів IEC 61800-7. Як видно з рисунку у стандартах визначені 4-ри типи профілів PDS:

1. CiA 402 (CAN in Automation);

2. CIP Motion (ODVA);

3. PROFIDrive (PROFIBUS International);

4. SERCOS (SERCOS International).    

#### Відображення профілів PDS на мережні технології 

Ці профілі конкретизують і доповнюють універсальний інтерфейс PDS і  потрібні для правильного написання прикладної програми, яка управляє Логічним приводом. Однак профіль приводу не визначає механізм взаємодії через мережні технології. Припустимо, відомо яка команда повинна бути надіслана для зупинки двигуна, однак невідомо в якій мережній змінні вона знаходиться. Для визначення конкретної реалізації профілю PDS, він відображається на конкретну промислову мережу. В групі стандартів IEC 61800-7-300 профілі приводів описуються в контексті конкретної мережної технології.  

 Рис.11.8. Структура стандартів IEC 61800-7

<a href="media11/11_8.png" target="_blank"><img src="media/11_8.png"/></a> 

В перших робочих редакціях стандартів IEC 61800-7 було визначено 5 профілів для PDS. У діючу офіційну редакцію не увійшов один із популярних нині профілів DRIVECOM (INTERBUS), який на сьогоднішній день використовуються у багатьох частотних перетворювачах. В наступних главах будуть розглянуті 2 профілі приводів та їх відображення на мережі: PROFIDRIVE та CiA402. 

## Контрольні запитання

1. Навіщо пристрої PDS необхідно підключати до контролерів? Які типи сигналів використовуються при підключенні? 

2. В чому переваги використання мережного зв’язку перед аналоговими, дискретними та імпульсними підключеннями контролера з PDS?

3. Які проблеми виникають при використанні мережного зв’язку з PDS різних виробників? Як ці проблеми вирішуються на рівні стандартизації зв’язку з PDS? 

4. З яких основних складових складається логічна модель системи з PDS? Які функції виконують ці складові? Що визначає Універсальний Інтерфейс в контексті стандарту МЕК 61800-7?

5. Які функціональні можливості може підтримувати Логічний Привод? Як відрізняється фізична структура реалізації Логічного Приводу, в залежності від наявних функцій в PDS? В якій складовій системи можуть бути реалізовані функції, відсутні в PDS? 

6. Поясніть відмінність між Універсальним Інтерфейсом МЕК 61800-7 та промисловою мережею?

7. Які інтерфейси можуть бути доступні для з’єднання з PDS? Поясніть їх призначення. Які з них підтримуються функціями Універсального Інтерфейсу МЕК 61800-7?

8. В яких логічних складових закладені параметри та алгоритми поведінки Логічного Приводу?

9. Перерахуйте Функціональні Елементи Логічного Приводу. Які функції в них закладені? 

10. Які Функціональні Елементи використовуються при конфігуруванні PDS з боку програматорів, а які для управління Логічним Контролером?

11. Розкажіть про принципи функціонування процесу управління Логічним Приводом. За допомогою яких змінних відбувається процес управління та контролю за Логічним Приводом?

12. Які стани визначені для Функціонального Елементу Device Control та як відбувається перехід між ними? Як контролюється та управляється автомат станів Device Control FE?

13. Які стани визначені для Communication FE та як відбувається перехід між ними? Як контролюється та управляється автомат станів Communication FE?

14. Які стани визначені для Basic Drive FE та як відбувається перехід між ними? Як контролюється та управляється автомат станів?

15. В яких прикладних режимах може функціонувати Логічний Привод? 

16. Прокоментуйте схему функціонування режимів управління моментом приводу?

17. Прокоментуйте схему функціонування режимів управління швидкістю приводу?

18. Прокоментуйте схему функціонування режимів управління позиціонуванням приводу?

19. Розкажіть про наявні профілі пристроїв PDS та їх відображення на промислові мережі в стандартах МЕК 61800-7? Який популярний профіль PDS не увійшов до переліку стандартних? 

20. Поясніть відмінність поняття профілю PDS від промислової мережі, що підтримуються даним пристроєм. Чи визначає факт використання конкретної промислової мережі наявність конкретного профілю PDS та навпаки? 




Теоретичне заняття розробив [Олександр Пупена](https://github.com/pupenasan). 