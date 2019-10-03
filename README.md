### Description
In this project, i still used board that previously used in mcs51_assembly project. The only difference is i used bascom language for this mcs51_bascom project.

#### 1. Serial Communication
In mcs51, you can do this basic communication through Tx and Rx port available at P3.1 and P3.0. I assume you already know the basic of serial communication. You have to cross the Tx Rx to another device to do this type of communication. You can see the code i used in bascom_code folder of serial_communication project in this repository.


![serial](https://github.com/falithurrahman/mcs51_bascom/blob/master/serial_communication/Picture/Simulation.png)


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
I observed the number of stolen motorbike around me is very high. People need extra security for their motorbike. Thus i made this project. The idea is simple, i would place a MPU6050 module at the steer of the motorbike. If someone by any chance move the steer by force, the angle measurement from MPU6050 will swing more than the threshold predefined. This would trig the microcontroller to send a SMS from SIM800 GSM module to the motorbike owner. This would alert the owner that his motorbike is in danger. The code for this project is available at the gsm_with_gyro folder. You can see the simple block diagram connection between MPU6050, MCS51 and SIM800 at the picture below. The communication between MCS51 and SIM800 was established using serial communication. The AT command was sent through serial communication. I also used LCD for this project.

![block diagram](https://github.com/falithurrahman/mcs51_bascom/blob/master/gsm_with_gyro/block_diagram.jpg)

Line 1 to line 12 of the code is the initialization of the component used in this project. Baud rate used was 9600. P3.3 and P3.4 was initialized as SCL and SDA for I2C communication.
```bascomavr
$crystal = 11059200
$baud = 9600
$large
Config Scl = P3.3
Config Sda = P3.4
Dim I2ctemp As Integer
Config Lcdpin = Pin , Db4 = P2.4 , Db5 = P2.5 , Db6 = P2.6 , Db7 = P2.7 , E = P2.2 , Rs = P2.0
P2.1 = 0
Const Mpu6050_wr = &HD0
Const Mpu6050_rd = &HD1
Dim X As Integer
X = 0
```

Line 24 to 64 consists of 3 function, write_i2c, read_i2c and telp. write_i2c will write to specific address at the MPU6050, they are 6B, 1B, 19 and 3B. You can read what these addresses do at the MPU6050 register map.

```bascomavr
Sub Write_i2c
   I2cstart
   I2cwbyte Mpu6050_wr
   I2cwbyte &H6B
   I2cwbyte 09
   I2cstart
   I2cwbyte Mpu6050_wr
   I2cwbyte &H1B
   I2cwbyte 3
   I2cstart
   I2cwbyte Mpu6050_wr
   I2cwbyte &H19
   I2cwbyte 0
   I2cstart
   I2cwbyte Mpu6050_wr
   I2cwbyte &H3B
   I2cstop
   Call Read_i2c
   Waitms 10
End Sub

Sub Read_i2c
   I2cstart
   I2cwbyte Mpu6050_rd
   I2crbyte I2ctemp , Nack
   I2cstop
   Waitms 10
   Cls
   Lowerline
   Lcd "MPU Nilai = " ; I2ctemp
End Sub

Sub Telp
   X = 1
   Cls
   Lcd "MENELPON "
   Print "ATD+6281227381328;"
   Wait 8
   Print "ATH"

End Sub
```

Line 13 to line 22 is the main loop of the program. If the measurement of angle is in range, from 30 to 100, then it means that the motorbike safe. If the measurment reached range from 180 to 240, there would be something happened with the motorbike. The owner would be alerted with text message sent from GSM SIM800.

```bascom
Do
Lcdinit

   Waitms 200
   Call Write_i2c
   If I2ctemp < 240 And I2ctemp > 180 And X = 0 Then Call Telp
   If I2ctemp > 30 And I2ctemp < 100 Then X = 0
   Waitms 200
Loop
```