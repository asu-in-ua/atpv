[<- До підрозділу](README.md)

# Підсистема календарного виконання

Для ряду об’єктів повинно бути передбачене керування установками згідно з календарним графіком та астрономічним часом. Наприклад, у системах керування водо- та теплопостачанням може знадобитися вмикання та вимикання насосів згідно зі встановленим графіком. Це задача для спеціальних підсистем SCADA/HMI, які називаються ***планувальниками*** (Scheduler). 

Особливістю планувальника є можливість означення календарного плану в середовищі виконання. Іншими словами, час та дії, які повинні відбуватися в цей час, налаштовує не розробник системи керування, а оператор. 

Планувальники можуть надавати такі можливості в середовищі виконання:

- означення абсолютного часу для виконання дій, наприклад 23.10.2020 о 18:00;

- означення відносного часу для виконання дій, наприклад кожного понеділка о 18:00;

- означення спеціальних днів у календарі, тобто в яких виконується особливий план;

- означення дій у вигляді зміни тегів (змінних) або запуску функцій. 

## Контрольні запитання

1.      Поясніть необхідність підсистеми планування (планувальників)
2.      Які можливості повинні надавати підсистеми планування? Покажіть на прикладі однієї зі SCADA/HMI. 

 

Теоретичне заняття розробив [Олександр Пупена](https://github.com/pupenasan). 
