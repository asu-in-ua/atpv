[<- До підрозділу](README.md)	[PLC MachineStruxure](../ecostruxuremachineexpert.md) 	[CODESYS (загальна)](../codesys.md)	[Коментувати](#feedback)

# Обробка сигналів в контурі регулювання з ControlLoopLibrary в CODESYS: теоретичні відомості

чернетка

## Передатні функції

### DT1

Цей функціональний блок описує передатну функцію типу DT1 (диференціатор) з
$$
G(s) = \frac{K_Ms}{1+T_Ms}
$$
Диференціатор має бути переданий через |itfDifferentiator|.
Реакцію на стрибковий вплив наведено на зображенні нижче.

![image-20260228183244817](C:\san\народн посібн атпв\gitver\plc\signcontrol\mediacodesys\image-20260228183244817.png)



### PT1

Цей функціональний блок описує передатну функцію першого порядку
$$
G(s) = \frac{K_M}{1+T_Ms}
$$
Представлений `PT1` та `PT1_Rtrapezoid`. Перший передбачає підключення вибраного інтегратору через означений інтерфейс, тоді як `PT1_Rtrapezoid` вже включає трапециїдальний спосіб інтеграції.   

![image-20260228195627393](C:\san\народн посібн атпв\gitver\plc\signcontrol\mediacodesys\image-20260228195627393.png)

| Scope  | Name          | Type             | Коментар                                                     |
| ------ | ------------- | ---------------- | ------------------------------------------------------------ |
| Input  | xEnable       | BOOL             | TRUE: активує визначену операцію; FALSE: перериває/скидає операцію |
| Output | xBusy         | BOOL             | TRUE: операція виконується                                   |
| Output | xError        | BOOL             | TRUE: досягнуто стану помилки                                |
| Input  | lrValue       | LREAL            | Поточний вхід                                                |
| Input  | lrKm          | LREAL            | Коефіцієнт підсилення передатної функції                     |
| Input  | lrTm          | LREAL            | Стала часу системи                                           |
| Output | lrOutputValue | LREAL            | Вихід системи                                                |
| Output | eErrorID      | Controller_Error | Поточна помилка. Дійсне лише якщо `xError = TRUE`            |
| Input  | itfIntegrator | Integrator       | Інтегратор, що використовується функціональним блоком,  для `PT1_Rtrapezoid`  вже включено |



![image-20260301175133128](C:\Users\OleksandrPupena\AppData\Roaming\Typora\typora-user-images\image-20260301175133128.png)



## Джерела

1. https://product-help.se.com/ESME/2.3/VLP_Software/VLP_Lib_Temp_Ex/VLP_Libraries/VLP_Codesys_Libraries/en-US/ControlLoopLibrary

## Автори


Теоретичне заняття розробив [Олександр Пупена](https://github.com/pupenasan). 

## Feedback

Якщо Ви хочете залишити коментар у Вас є наступні варіанти:

- [Обговорення у WhatsApp](https://chat.whatsapp.com/BRbPAQrE1s7BwCLtNtMoqN)
- [Обговорення в Телеграм](https://t.me/+GA2smCKs5QU1MWMy)
- [Група у Фейсбуці](https://www.facebook.com/groups/asu.in.ua)

Про проект і можливість допомогти проекту написано [тут](https://asu-in-ua.github.io/atpv/)
