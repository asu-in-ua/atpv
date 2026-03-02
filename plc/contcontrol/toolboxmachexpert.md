[<- До підрозділу](README.md)	[PLC MachineStruxure](../ecostruxuremachineexpert.md) 	[Коментувати](#feedback)

# Toolbox в Machine Expert: теоретичні відомості

## Загальний опис бібліотеки

## Бібліотека

### Bit Functions

- Bit Organization
- SetBitTo: Setting/Resetting One Bit
- TestBit: Testing One Bit

### Closed Loop Functions 

- FB_2points: Closed Loop 2 Point Transfer Element
- FB_3points: Closed Loop 3 Points Transfer Element
- FB_3points_Ext: Closed Loop Extension For 3 Points Transfer Element
- FB_P: Control Loop With Proportional Only Algorithm ([опис](../pidcontrol/teormachexpert.md))
- FB_PI: Proportional and Integration Process Control ([опис](../pidcontrol/teormachexpert.md))
- FB_PID: Manual Mode Operation Process Control ([опис](../pidcontrol/teormachexpert.md))
- FB_PI_PID: Cascaded PI_PID Control Loop ([опис](../pidcontrol/teormachexpert.md))

### Equipment Control Functions

- FB_Cyclic_Monitoring: Cyclic Monitoring
- FB_DeadBand: Suppressing Amplitude Oscillations
- FB_Limiter: Limiting Input Signals
- FB_PWM: Providing a PWM Output
- FB_Redundant_Sensor_Monitoring: Redundant Sensor Monitoring 
- FB_Sensor_Monitoring: Sensor Monitoring

### Filtering Functions

- Global Parameter List ([опис](../signcontrol/teormachexpert.md))
- Filter_AnalogInput: Checking Analog Input Varaibility ([опис](../signcontrol/teormachexpert.md))
- Filter_Arithmetic: Giving Arithmetic Mean Value ([опис](../signcontrol/teormachexpert.md))
- Filter_MovingAverage: Giving Moving Mean Value ([опис](../signcontrol/teormachexpert.md))
- Filter_PT1: Providing PT1 Transfer Function ([опис](../signcontrol/teormachexpert.md))

### Flip-Flops

- JK_FlipFlop: Resetting/Setting Input to Flip Flop Output
- JK_FlipFlop_MasterSlave Function Block
- RS_FlipFlop: Resetting/Setting of Flip Flop Input/Output
- SR_FlipFlop Function Block
- Toggle_FlipFlop: Toggling of Flip Flop Input/Output

### Mathematical Functions

- Analysis: Calculating Integral and Derivative Values
- Frequency_Multiplier: Implementing 32 Blinkers
- Frequency_Output: Implementing a Frequency
- Normalizer_With_Limiter: Scaling the Minimum and Maximum
- ONE_SEC_PULSE: Providing Pulses Every One Second
- Quantizer: Digitalizing the Input Value for the Interval
- Signal_Saturation: Limiting to Upper and Lower Saturation Limit
- Signal_Statistics: Calculating Maximum, Minimum, Average and
- Check_Divisor: Checking for Zero Division Condition

### Numerical Conversion Functions

- ArrayOfByte_TO_String: Converting Array in Byte Format to String
  Format
- DT_AS_WORD: Converting Date and Time as Word
- DWORD_AS_WORD: Splitting the Double Word into Two Words
- String_TO_ArrayOfByte: Output Array and ASCII Value of the Input
  String
- WORD_AS_DWORD: Shifting Higher Word and Adding Lower
  Word

### Physical Conversion

- Celsius_TO_Fahrenheit: Converting Celsius to Fahrenheit
- Celsius_TO_Kelvin: Converting Celsius to Kelvin
- Fahrenheit_TO_Celsius: Converting Fahrenheit to Celsius
- Frequency_TO_Period: Calculating Period of Time of Given Frequency
- Kelvin_TO_Celsius: Converting Kelvin to Celsius
- Period_TO_Frequency: Calculating Frequency of Given Time

### Utilities 

- Hour_Meter: Accumulating Operating Hours
- Operation_Mode: Selecting Operating Mode

### Valve Control

- Bistable_Valve: Controlling the Bistable Valves
- Monostable_Valve: Controlling Monostable Valves
- Proportional_Valve: Controlling Proportional Valves



## Джерела

1. [EcoStruxure Machine Expert - Toolbox, Library Guide ](https://www.se.com/us/en/download/document/EIO0000000096/)

## Автори


Теоретичне заняття розробив [Олександр Пупена](https://github.com/pupenasan). 

## Feedback

Якщо Ви хочете залишити коментар у Вас є наступні варіанти:

- [Обговорення у WhatsApp](https://chat.whatsapp.com/BRbPAQrE1s7BwCLtNtMoqN)
- [Обговорення в Телеграм](https://t.me/+GA2smCKs5QU1MWMy)
- [Група у Фейсбуці](https://www.facebook.com/groups/asu.in.ua)

Про проект і можливість допомогти проекту написано [тут](https://asu-in-ua.github.io/atpv/)