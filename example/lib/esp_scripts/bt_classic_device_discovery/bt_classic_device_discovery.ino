
#include <BluetoothSerial.h>

#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run `make menuconfig` to and enable it
#endif



BluetoothSerial SerialBT;

char prevCharacter = '\0';
bool isNumber = 0;
int num = 0;
bool numberToBeSent = 0;
int numartest=1234;
bool primit = false;

void setup() {
  Serial.begin(115200);
  SerialBT.begin("ESP32test"); //Bluetooth device name
  Serial.println("The device started, now you can pair it with bluetooth!");



}

void loop() {
  
  if (Serial.available()) {
  }
  //if(primit==false)
  //{
  if (SerialBT.available()) {
    char btChar = SerialBT.read(); // Read the character from Bluetooth
    //Serial.write(btChar); // Write the character to Serial
    if (isNumber) {
      if (btChar >= 48 && btChar <= 57) {
        num = num * 10 + btChar - 48;
      }
      else {
        isNumber = 0;
        numberToBeSent = 1;
        //Serial.println(num);
        //Serial.println("Number ready to be sent.");
        //Serial.println(num);
      }
    }

    if (prevCharacter == '-' && btChar == '>') {
      isNumber = 1;
    }
    prevCharacter = btChar;
    if (numberToBeSent) {
        String numStr = String(num);
        uint8_t buf[numStr.length()];
        memcpy(buf, numStr.c_str(), numStr.length());
        SerialBT.write(buf, numStr.length());
        numberToBeSent = 0;
        Serial.println("Number was sent.");
        primit=true;
    }
  }
  //}
  
  delay(20);
  
 
  
}
