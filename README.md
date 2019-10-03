### Description
In this project, i still used board that previously used in mcs51_assembly project. The only difference is i used bascom language for this mcs51_bascom project.

#### 1. Serial Communication
In mcs51, you can do this basic communication through Tx and Rx port available at P3.1 and P3.0. I assume you already know the basic of serial communication. You have to cross the Tx Rx to another device to do this type of communication. You can see the code i used in bascom_code folder of serial_communication project in this repository. 

Line 1 and 2 is the initialization of the baud rate used for this serial communication. I used 9600 baud rate.
```bascom
$crystal = 11059200
$baud = 9600
```
Line 6 to 14 is the initialization for the LCD. I used the HD44780 LCD for this project.
```bascom
Config Lcd = 16 * 2
Config Lcdbus = 8
'Config Lcdpin = Pin , Db0 = P2.0 , Db1 = P2.1 , Db2 = P2.3 , Db3 = P2.4
Config Lcdpin = Pin , Db4 = P2.4 , Db5 = P2.5 , Db6 = P2.6,
Config Lcdpin = Pin , Db7 = P2.7 , E = P2.2 , Rs = P2.0
P2.1 = 0                                                      'R/W=0
Initlcd
Cursor Off
Cls
```
Line 17 to 25 is the main loop of this program. I initiated a variable N that counted from 1 to 255. This variable will be displayed to the LCD connected with mcs51 board. I connect the Tx Rx of this board to Tx Rx of FTDI232 module. Next, i connect FTDI232 module to the usb port of my laptop. Finally, i can read the serial sent by mcs51 board through serial reader application like teraterm, coolterm, or even serial monitor of arduino.
```bascom
For N = 1 To 255
Home
Lcd "Hitung"
Locate 1 , 14
Lcd N
Print N
Waitms 500
Next
End
```

#### 2. GSM with gyro
