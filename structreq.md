[Про репозиторій](README.md)

# Вимоги до структури та вигляду тематичного підрозділу

Не дивлячись на наведені нижче вимоги, ви можете пропонувати свої матеріали, які будуть переглянуті і оформлені як частина теми або як незалежна стаття в розділі. 

## Вимоги до вигляду

Кожен тематичний підрозділ (тема) має бути оформлений як окрема папка в якій можуть бути файли наступного формату:

- файл README.md - основний файл для текстового змісту, який містить посилання на інші файли; файл обов'язково називається з усіма літерами в верхньому регістрі 
- інші файли markdown - для текстового представлення змісту
- графічні файли - для рисунків, розміщуються в окремій папці або папках до 100 кб кожний
- інші файли невеликого об'єму (до 100 кб)  

Відео файли та інші файли великого об'єму повинні бути завантажені на зовнішні ресурси.

Прототип для підрозділу наданий [за посиланням](proto/topic)

## Вимоги до структури

Один підрозділ повинен закривати одну невелику тему.  Орієнтовно для охвату теми треба до 4 годин, які включають:

- ознайомлення з теорією
- практичне завдання
- проходження тестів

Файл README.md повинен включати наступні частини:

- Посилання на рівень вище `[< -- До розділу](../README.md)         [Зміст](../../contents.md)`
- Назва, форматована як заголовок 1-го рівня
  - Короткий опис, в якому вказано про що розділ в кількох реченнях
  - Чому можна навчитися і де можна буде використати
  - Які вхідні вимоги для розуміння матеріалу, з посиланнями, якщо такі є
  - Які інструменти (ПЗ, апаратні) використовуються в розділі
  - Посилання на джерело інформації, звідки взяті матеріали (увага, звертайте увагу на правила копірайту)
- "Теоретична частина" - заголовок 2-го рівня
  - опис теоретичної частини; якщо вона велика, то дається посилання на окремий файл де наводиться опис; кожен файл повинен починатися з посилання `[<- До підрозділу](README.md)`
- "Практична частина" - заголовок 2-го рівня    
  - опис практичної частини; якщо вона велика, то дається посилання на окремий файл де наводиться опис
- "Перевірка знань" - заголовок 2-го рівня
  - Перелік питань для самоперевірки, або
  - Посилання на форму з тестовими питаннями і відповідями
  -  

