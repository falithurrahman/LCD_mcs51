$crystal = 11059200
$baud = 9600

Dim N As Byte

Config Lcd = 16 * 2
Config Lcdbus = 8
'Config Lcdpin = Pin , Db0 = P2.0 , Db1 = P2.1 , Db2 = P2.3 , Db3 = P2.4
Config Lcdpin = Pin , Db4 = P2.4 , Db5 = P2.5 , Db6 = P2.6,
Config Lcdpin = Pin , Db7 = P2.7 , E = P2.2 , Rs = P2.0
P2.1 = 0                                                      'R/W=0
Initlcd
Cursor Off
Cls


For N = 1 To 255
Home
Lcd "Hitung"
Locate 1 , 14
Lcd N
Print N
Waitms 500
Next
End