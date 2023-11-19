#include <HardwareSerial.h>

HardwareSerial SerialPort(1); // use UART1


void setup()  
{
  Serial.begin(115200);
  SerialPort.begin(9600, SERIAL_8N1, 4, 2); 
} 
void loop()  
{ 
  if (SerialPort.available()){
  int Answer = SerialPort.read();
  Serial.println(Answer);
  }
}
