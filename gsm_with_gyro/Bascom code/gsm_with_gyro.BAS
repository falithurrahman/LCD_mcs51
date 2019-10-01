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
Do

Lcdinit

   Waitms 200
   Call Write_i2c
   If I2ctemp < 240 And I2ctemp > 180 And X = 0 Then Call Telp
   If I2ctemp > 30 And I2ctemp < 100 Then X = 0
   Waitms 200
Loop

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
