#include <HardwareSerial.h>
#define RXp2 25
#define TXp2 27
//HardwareSerial SerialPort(1); // use UART1


void setup()  
{
  Serial.begin(115200);
  Serial2.begin(115200, SERIAL_8N1, RXp2,TXp2);
} 
void loop()  
{ 
  
    Serial2.println("3evhc3jcv");
  
}
