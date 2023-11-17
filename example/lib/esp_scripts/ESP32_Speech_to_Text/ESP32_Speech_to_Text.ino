#include "network_param.h"
#define buttonPin 23
#define RXp2 16
#define TXp2 17
bool sensorstate = false; // Initial state is not disrupted (0)

#include "Audio.h"
#include "CloudSpeechClient.h"
int i=0;
#include "BluetoothSerial.h"

#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run `make menuconfig` to and enable it
#endif
//Audio audiotest;
BluetoothSerial SerialBT;
void setup() {
  Serial.begin(115200);
  Serial2.begin(115200, SERIAL_8N1, RXp2,TXp2);
  pinMode(buttonPin, INPUT_PULLUP);
  SerialBT.begin("ESP32test"); //Bluetooth device name
  Serial.println("The device started, now you can pair it with bluetooth!");
}

void loop() {
  if (Serial.available()) {
  while(!SerialBT.available())
  {
  }
  }
  
   // Serial.println("The device started, now you can pair it with bluetooth!");
  //led albatru, waiting for connection
  if (SerialBT.available()) {
    Serial.write(SerialBT.read());
    //ssid = citit
    //password = citit
  }
   
   if(i==0){
   Serial.println("Press button");
   i=1;
   }
   // Check the state of the button
   while(1)
   {
    if (digitalRead(buttonPin) == LOW) {
    // Button is pressed
    sensorstate = true;
    break;
     }
   }
   if(sensorstate==true){
  //Serial2.println("\r\nPlease Ask!\r\n");
  Serial.println("\r\nRecord start!");
  Audio* audioR = new Audio(ADMP441);
  audioR->Record();
  Serial.println("Recording Completed, Processing");
 
  CloudSpeechClient* cloudSpeechClient = new CloudSpeechClient(USE_APIKEY);
  cloudSpeechClient->Transcribe(audioR);
  delete cloudSpeechClient;
  delete audioR;
  i=0;
  }
  sensorstate=false;
 
}
