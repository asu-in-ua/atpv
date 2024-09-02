[<- До підрозділу](README.md)

# Приклад реалізації MODBUS TCPIP Клієнтської програми для зв’язку прикладних програм з інтегрованим VBA та ПЛК

Написати прикладну програму в середовищі VBA (Excel) для реалізації зчитування значення 5-ти внутрішніх регістри з ПЛК по протоколу MODBUS TCP/IP. Зчитування проводити при натисканні кнопки. 

Рішення. У VBA прописуємо наступний код, показаний на рис. 6.35.

Для реалізації даної задачі використаний ActiveX-елемент Winsock\ (має назву Winsock1), який як правило вже присутній на комп’ютерах з операційною системою Windows. Цей компонент являється інтерфейсом до однойменного сервісу в операційній системі Windows і функціонує приблизно так як модель сокетів (див.розділ 10). Він може працювати як в режимі TCP так і UDP. Для останнього - з’єднання проводити не потрібно. Достатньо розмістити Winsock елемент на контейнері (наприклад формі) і можна користуватися його методами, властивостями та подіями. 

```vb
Dim Reg(1 To 10) As Integer ' тут зберігаємо значення змінних
Private Sub CloseSocket()
    Winsock1.Close 		'закінчити з'єднання
End Sub

Private Sub ConnectSocket()  			'з'єднуємося з MODBUS сервером
    Winsock1.Protocol = sckTCPProtocol   'вибираємо протокол ТСР
    Winsock1.Connect "192.168.9.17", 502 'вказуємо ІР та 502 порт
End Sub

Private Sub CommandButton3_Click()
    ReadRegisters 0, 5                    ' читаємо 5 регістрів починаючи з 0
End Sub

Sub ReadRegisters(StartAddr As Integer, CountAddr As Integer)
    Dim a(1 To 12) As Byte 'посилка в байтах
    If Winsock1.State = sckConnected Then 'якщо під'єднанні
        a(6) = 6 					 'кількість байт
        a(8) = 3					 'функція
        a(9) = StartAddr \ 256             'початковий № - старший байт
        a(10) = StartAddr Mod 256          'початковий № - молодший байт
        a(11) = CountAddr \ 256           'кількість - старший молодший байт
        Winsock1.SendData a               'відправити масив байт
    End If
End Sub

Private Sub Winsock1_DataArrival(ByVal bytesTotal As Long) 'отримали дані
 Dim a As Variant, LoInd As Integer, i As Integer, j As Integer
 Winsock1.GetData a, , bytesTotal          'вийняти дані з буферу
 LoInd = LBound(a)                         'визначити початковий індекс масиву
 If a(7 + LoInd) = 3 Then 'якщо це функція читання і вона оброблена без помилок
    For i = 1 To a(8 + LoInd) \ 2         'перебираємо кожний регістр
        j = 9 + (i - 1) * 2               'номер байту в масиві для регістру і
        If (a(j) And &H80) > 0 Then      'якщо число від'ємне (старший біт в 1)
            a(j) = a(j) And &H7F          'обнулити старший біт
            Reg(i) = a(j) * 256 + a(j + 1) - 32768 
'рахувати з урахуванням знаку
        Else
            Reg(i) = a(j) * 256 + a(j + 1) ' рахуємо без знаку
        End If
    Next
 End If
End Sub

```
