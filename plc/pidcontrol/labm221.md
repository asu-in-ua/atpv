[<- До підрозділу](README.md)

# Конфігурування PID регулятора в EcoStruxure Machine Expert Basic: практична частина 

**Мета:** навчитися створювати програми користувача з ПІД-регуляторами.

**Необхідне програмне забезпечення.** EcoStruxure Machine Expert Basic

### Порядок виконання роботи

#### 1. Створення нового проекту

***УВАГА! Дану частину роботи неможливо перевірити в симуляторі ПЛК, оскільки він не підтримує роботу PID-регулятора. Тому в даній частині виконується лише конфігурація без перевірки працездатності.***

- Створіть новий проект в Machine Expert Basic.  У якості процесорного модуля оберіть **TM221CE24R**.

![](media6/1_1.PNG)

Рис. 9.1. Конфігурація ПЛК

#### 2. Постановка завдання для прикладу

- Познайомтеся з постановкою задачі, яка наведена нижче

В змінній **%MW10** зберігається значення з датчика рівня з вихідним уніфікованим сигналом 0-10V, діапазон в ПЛК 0-10000. В змінній **%MW20** зберігається значення керування електричним приводом клапана з уніфікованим сигналом керування 0-10V, діапазон в ПЛК 0-10000, за допомогою якого необхідно підтримувати заданий рівень в ємності (рис.9.2)

![](media6/1_2.png)



Рис. 9.2 Функціональна схема об'єкта керування

Для розв'язання поставленої задачі скористаємось одним з ПІД регуляторів ПЛК М221.

#### 3. Налаштування типу PID регулятора

- Для виконання конфігурації PID регуляторів необхідно перейти в розділ **Programming > Tools > Software Objects > PID** (рис. 9.3)

![](media6/1_3.png)

 Рис. 9.3 Конфігурування PID регуляторів

- У вікні PID propertis можна побачити перелік PID регуляторів, доступних для обраної моделі ПЛК.

- Виконайте конфігурацію регулятора **PID 0**. Для цього необхідно натиснути на кнопку з трьома крапками навпроти регулятора `PID 0` в колонці `Configuration` (рис 9.3).

Відкриється вікно налаштування PID регулятора **PID 0 Assistent** (рис. 9.4).

![](media6/1_4.png)

Рис. 9.4 Вікно конфігурації PID Assistent

Вкладка General дозволяє обрати тип регулятора з переліку (рис.9.5):

![](media6/1_5.png)

Рис. 9.5. Вибір типу регулятора

- Ознайомтеся з типами регуляторів:
  - Not Configured  - регулятор не сконфігуровано, в програмі не використовується
  - PID - Звичайний режим роботи PID-регулятора, активний за замовчуванням, коли PID-регулятор запускається.
  - AT + PID - У цьому режимі активується функція  автоматичної настройки при запуску PID-регулятора. Після виконання автонастройки регулятор починає працювати як звичайний PID.
  - AT - Режим автонастройки - У цьому режимі активується функція  автоматичної настройки при запуску PID-регулятора. Після виконання автонастройки регулятор зупиняється.
  - Word Adress - Динамічний режим роботи, при якому необхідний режим роботи можна змінити програмним шляхом, змінюючи значення змінної Word Adress

- Оберіть режим `PID` 

#### 4. Налаштування входів регулятора

Вкладка Input дозволяє провести налаштування входів PID-регулятора

- Перейдіть у вкладку **Input**. Ознайомтеся з її змістом.

- У зоні **Measure**, вказується змінна, що відповідає за поточне значення вимірюваної величини. Вкажіть змінну **%MW10**.

- Зона **Conversion** дозволяє провести масштабування значення вимірюваної величини у більш зручний вигляд. Вкажіть 0-100%, що буде значити масштабування рівня з діапазону 0-10000 у вказаний діапазон у %. 


- Зона **Filter** дозволяє провести цифрове фільтрування вимірювальної величини. Залиште без змін.

- Зона Alarms дозволяє провести налаштування тривог, про вихід регульованого параметру за допустимі межі. Залиште без змін.


Таким чином налаштування матиме вигляд як на рис. 9.6.

![](media6/1_6.png)

Рис. 9.6. Налаштування входів PID-регулятора

#### 5. Налаштування параметрів регулятора

 У вкладці **PID** проводиться конфігурація основних параметрів регулятора.

- Перейдіть у вкладку **PID**. Подивіться та змініть налаштування, як вказано нижче.

- Зона **Setpoint** - відповідає за задане значення регульованої змінної. Тут можна записати як константу (наприклад 50), так і адресу змінної (наприклад %MW50) - для можливості зміни заданого значення програмно під час роботи на виробництві. У якості завдання вкажіть адресу змінної `%MW50`


- Зона **Corrector** type - дозволяє обрати режим роботи регулятора ПІ чи ПІД. Вкажіть режим ПІ.


- **Parametrs** - параметри налаштування ПІД-регулятора. Дозволяється записувати як константи, так і адреси змінних для програмної зміни під час роботи. Наступні параметри:
  - Кр - коефіцієнт пропорційності, вкажіть 10, що буде значити 0,1
  - Ті - час інтегрування, вкажіть 200, що буде значити 20 с
  - Тd - час диференціювання

- **Sampling period** - частота викликів PID-регулятора. Вона повинна бути від 1 (0,01 с) до 10000 (100 с). Вкажіть 1.

Таким чином налаштування матиме вигляд як на рис. 9.7.

![](media6/1_7.png)

Рис. 9.7. Налаштування параметрів PID-регулятора

#### 6. Налаштування виходу регулятора

У вкладці **Output** проводиться конфігурація виходу регулятора:

- Перейдіть у вкладку **Output**. Подивіться та змініть налаштування, як вказано нижче.

- **Action** - напрям дії PID-регулятора, прямий - **Direct** (наприклад, якщо об'єкт керування нагрівач), зворотній - **Revers** (наприклад, якщо об'єкт керування охолоджувач). Або з можливістю перемикання - **Bit Address**. У цьому випадку напрям дії можна програмно змінювати за допомогою дискретної змінної, що вказується у відповідному полі. Вкажіть `Direct`

- **Limits** - дозволяє виконати обмеження виходу PID регулятора. Вкажіть `Disable` (без обмежень).

- **Manual mode** - ручний режим, дозволяє керування виходом регулятора в ручному режимі:
  - Disable - ручний режим відключено.
  - Enable - ручний режим постійно включений
  - Bit Address - з можливістю перемикання руч/авто. У цьому випадку режим роботи  можна змінювати за допомогою дискретної змінної, що вказується у відповідному полі. "0" - автоматичний режим, "1" - ручний. Виберіть цей режим та вкажіть `%M0`.
  - Output - вихід регулятора в ручному режимі. Вкажіть `%MW20`. 

- **Analog Output** - аналоговий вихід PID регулятора. Вкажіть `%MW20`. 

- Output PWM - у випадку, коли необхідно керувати об'єктом за принципом широтно-імпульсної модуляції, обирається дана опція. У такому випадку задається дискретний вихід регулятора, а період імпульсів. Більш детально про даний режим роботи у наступному розділі.


Таким чином налаштування матиме вигляд як на рис. 6.8. 

![](media6/1_8.png)

Рис. 9.8. Налаштування виходу PID-регулятора

- Натисніть **Apply** для підтвердження конфігурації.

#### 7. Використання PID регулятора в програмі.

Для того, щоб створений PID-регулятор почав працювати необхідно його викликати в програмі.

- Створіть `Rung`, за допомогою блоку **Operation Block** зробіть виклик `PID 0` рис. 9.9.


![](media6/1_9.png)

Рис. 9.9. Програмування виклику PID-регулятора

За такого виклику PID-регулятора він буде безумовно працювати постійно з моменту запуску ПЛК. За необхідності можна додати умови запуску регулятора так само, як і в інших варіантах використання **Operation Block**.

#### 8. Виконання індивідуального завдання згідно варіанту

- Виконайте конфігурацію регулятора згідно з  Вашим варіантом, та надішліть файл проекту на перевірку.

#### 9. Перевірка роботи PID-регулятора

- Перевірити роботу PID-регулятора можливо лише за наявності фізичного ПЛК М221. Якщо такий є - перевірте роботу.


- У разі відсутності перевірки на реальному ПЛК пропонується [ознайомче відео](https://youtu.be/Azl9VlQBQ-8) по роботі PID-регулятора М221


<iframe width="560" height="315" src="https://www.youtube.com/embed/Azl9VlQBQ-8" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

### Питання до захисту

1. Розкажіть про принципи роботи ПІД-регулятору.
2. Розкажіть загальні кроки щодо налаштування та використання ПІД-регулятору в ПЛК М221.
3. Розкажіть про налаштування параметрів у вкладці INPUT.
4. Розкажіть про налаштування параметрів у вкладці PID.
5. Розкажіть про налаштування параметрів у вкладці OUTPUT.
6. Розкажіть про методику перевірки роботи регулятору.

Розробив лабораторну - Полупан Володимир. [АКТСУ НУХТ](http://www.iasu-nuft.pp.ua)