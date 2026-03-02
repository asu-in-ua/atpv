[<- До підрозділу](README.md)	[PLC MachineStruxure](../ecostruxuremachineexpert.md) 	[CODESYS (загальна)](../codesys.md)	[Коментувати](#feedback)

# ControlLoopLibrary Library CodeSYS

## Загальний опис бібліотеки

Ця бібліотека містить функціональні засоби для реалізації алгоритмів керування та фільтрації сигналів.

Функціональні блоки

- AntiWindUp
  - AntiWindUp_BackCalculation
  - AntiWindUp_Base
  - AntiWindUp_Clamping

- Controller - регулятори, описані за [цим посиланням](../pidcontrol/teorcodesys.md)
  - BangBangController
  - Controller_Base
  - Controller_P
  - Controller_PD
  - Controller_PI
  - Controller_PID  
  - ThreePointController
  - ThreePointControllerWithValueHysteresis
- Differentiation
  - Differentiator_BackwardDifference
  - Differentiator_Base
  - Differentiator_LinearAverageApproximation
  - Differentiator_LinearFourPointApproximation
  - Differentiator_ParabolicApproximation
- Filter - фільтри, описані за [цим посиалнням](../signcontrol/teorcodesys.md)
  - Filter_Base
  - Filter_FIR
  - Filter_IIR
  - Filter_SOS
- Integrator - описані за [цим посиалнням](../signcontrol/teorcodesys.md)
  - Integrator_Base
  - Integrator_ParabolicApproximation
  - Integrator_RectangleApproximation
  - Integrator_TrapezoidApproximation
- PWM_Creator
  - PWM_Creator

- TransferFunctions - передатні функції, описані за [цим посиалнням](../signcontrol/teorcodesys.md)
  - TransferBase
  - DT1 (з варіаціями)
  - IT1 (з варіаціями)
  - PT1 (з варіаціями)
  - PT2 (з варіаціями)

## Джерела

1. https://product-help.schneider-electric.com/Machine%20Expert/V2.2/en/ControlLoopLibrary.pdf

## Автори


Теоретичне заняття розробив [Олександр Пупена](https://github.com/pupenasan). 

## Feedback

Якщо Ви хочете залишити коментар у Вас є наступні варіанти:

- [Обговорення у WhatsApp](https://chat.whatsapp.com/BRbPAQrE1s7BwCLtNtMoqN)
- [Обговорення в Телеграм](https://t.me/+GA2smCKs5QU1MWMy)
- [Група у Фейсбуці](https://www.facebook.com/groups/asu.in.ua)

Про проект і можливість допомогти проекту написано [тут](https://asu-in-ua.github.io/atpv/)