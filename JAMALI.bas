  'MADE BY :MOHAMAD REZA JAMALI

 '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
$regfile = "m8def.dat"
$crystal = 1000000
Config Portc.3 = Input
Config Portc.4 = Input
Config Portb.1 = Input
Config Portb.2 = Input
Config Portb.3 = Input
Config Portd.7 = Output
Config Portd.6 = Output
Config Portd.5 = Output
Config Portb.0 = Output
Deflcdchar 0 , 7 , 5 , 7 , 32 , 32 , 32 , 32 , 32           ' replace ? with number (0-7)
Deflcdchar 1 , 32 , 2 , 6 , 14 , 30 , 14 , 6 , 2            ' replace ? with number (0-7)
Config Adc = Single , Prescaler = Auto
Enable Interrupts
Start Adc
Dim B As Word
Dim S As Byte
Dim N As Word
Dim I As Byte
Dim C As Integer
Dim Z As Byte
Dim W As Byte
Dim Sum As Integer
Dim H As Byte
Dim L As Byte
S = 0
B = 0
N = 0
L = 0
H = 0
Readeeprom N , 0
Readeeprom B , 2
Readeeprom H , 4
Readeeprom L , 6
Config Lcdpin = Pin , Db4 = Portd.2 , Db5 = Portd.3 , Db6 = Portd.4 , Db7 = Portb.6 , E = Portd.1 , Rs = Portd.0
Config Lcd = 16 * 2
Cursor Off
Cls
Lcd " Passing Counter  "
Wait 2
Cls
Lcd "Made By:"
Waitms 1500
Cls
Home
Lcd "M"
Waitms 120
Locate 1 , 2
Lcd "O"
Waitms 120
Locate 1 , 3
Lcd "H"
Waitms 120
Locate 1 , 4
Lcd "A"
Waitms 120
Locate 1 , 5
Lcd "M"
Waitms 120
Locate 1 , 6
Lcd "M"
Waitms 120
Locate 1 , 7
Lcd "A"
Waitms 120
Locate 1 , 8
Lcd "D"
Waitms 200
Locate 1 , 10
Lcd "R"
Waitms 120
Locate 1 , 11
Lcd "E"
Waitms 120
Locate 1 , 12
Lcd "Z"
Waitms 120
Locate 1 , 13
Lcd "A"
Locate 2 , 6
Lcd "J"
Waitms 120
Locate 2 , 7
Lcd "A"
Waitms 120
Locate 2 , 8
Lcd "M"
Waitms 120
Locate 2 , 9
Lcd "A"
Waitms 120
Locate 2 , 10
Lcd "L"
Waitms 120
Locate 2 , 11
Lcd "I"
Wait 3
Cls
Goto Num
Do
Main:
Z = H - 1
W = L + 1
S = 0
If B > 65534 Then B = 0

If N > 65534 Then N = 0

If B => N Then
Set Portd.6
Else
Reset Portd.6
End If

If C => H And B => N Then Set Portd.7
If C < Z Then Reset Portd.7


If C =< L And B => N Then Set Portb.0
If C > W Then Reset Portb.0


If B = 0 Then
Reset Portd.5
Else
Set Portd.5
End If

Debounce , Pinc.3 , 1 , Incs
Debounce , Pinc.4 , 1 , Decs
Debounce , Pinb.3 , 1 , Num
Home
Lcd "number=" ; B ; "                 "
For I = 1 To 20
C = Getadc(5)                                               'formol temper'
Sum = C + Sum
Next I
C = Sum / 40
Sum = 0
Locate 2 , 1
Lcd "Temp: " ; C ; Chr(0) ; "c" ; "     "
Loop
'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Incb:
Home
Lcd "number=" ; B ; "                 "
Debounce , Pinc.4 , 1 , Incb1
Debounce , Pinc.3 , 1 , Main
Locate 2 , 1
Lcd "Temp: " ; C ; Chr(0) ; "c" ; "     "
Goto Incb
'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Decb:
Home
Lcd "number=" ; B ; "                 "
Debounce , Pinc.4 , 1 , Main
Debounce , Pinc.3 , 1 , Decb1
Locate 2 , 1
Lcd "Temp: " ; C ; Chr(0) ; "c" ; "     "
Goto Decb

Incs:
S = 1
Goto Incb

Decs:
S = 0
Goto Decb

Incb1:
Incr B
Writeeeprom B , 2
Goto Main

Decb1:
Decr B
Writeeeprom B , 2
Goto Main


Num:
Home
Lcd "Setting Number:"
Locate 2 , 1
Lcd "number:" ; N ; "        "
Debounce , Pinb.1 , 1 , Incsn
Debounce , Pinb.2 , 1 , Decsn
Debounce , Pinb.3 , 1 , Htemp
If N > 65534 Then N = 0
Goto Num

Incsn:
Incr N
Lcd "Setting Number:"
Locate 2 , 1
Lcd "number:" ; N ; "         "
Writeeeprom N , 0
If N > 65534 Then N = 0
Goto Num

Decsn:
Decr N
Lcd "Setting Number"
Locate 2 , 1
Lcd "number:" ; N ; "         "
Writeeeprom N , 0
If N > 65534 Then N = 0
Goto Num

Htemp:
Home
Lcd "High Temp:" ; H ; " " ; Chr(1) ; "    "
Locate 2 , 1
Lcd "Low Temp:" ; L ; "      "
Debounce , Pinb.1 , 1 , Inch
Debounce , Pinb.2 , 1 , Dech
Debounce , Pinb.3 , 1 , Ltemp
Goto Htemp

Inch:
Incr H
Writeeeprom H , 4
Home
Lcd "High Temp:" ; H ; " " ; Chr(1) ; "   "
Locate 2 , 1
Lcd "Low Temp:" ; L ; "    "
Goto Htemp

Dech:
Decr H
Writeeeprom H , 4
Home
Lcd "High Temp:" ; H ; " " ; Chr(1) ; "     "
Locate 2 , 1
Lcd "Low Temp:" ; L ; "      "
Goto Htemp

Ltemp:
Home
Lcd "High Temp:" ; H ; "     "
Locate 2 , 1
Lcd "Low Temp:" ; L ; " " ; Chr(1) ; "      "
Debounce , Pinb.1 , 1 , Incl
Debounce , Pinb.2 , 1 , Decl
Debounce , Pinb.3 , 1 , Main
Goto Ltemp

Incl:
Incr L
Writeeeprom L , 6
Home
Lcd "High Temp:" ; H ; "     "
Locate 2 , 1
Lcd "Low Temp:" ; L ; " " ; Chr(1) ; "      "
Goto Ltemp

Decl:
Decr L
Writeeeprom L , 6
Home
Lcd "High Temp:" ; H ; "     "
Locate 2 , 1
Lcd "Low Temp:" ; L ; " " ; Chr(1) ; "      "
Goto Ltemp