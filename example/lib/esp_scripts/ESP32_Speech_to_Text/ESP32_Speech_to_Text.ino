
#define buttonPin 23
#define RXp2 16
#define TXp2 17
//#define RXp0 3
//#define TXp0 1
bool sensorstate = false; 

#include "Audio.h"
#include "CloudSpeechClient.h"
bool i=false;

void setup() {
  pinMode(buttonPin, INPUT_PULLUP);
  Serial.begin(115200);
  //Serial.begin(115200, SERIAL_8N1, RXp0,TXp0);
  Serial2.begin(115200, SERIAL_8N1, RXp2,TXp2);
 /* #if defined(ESP32)
  HardwareSerial SerialThree(2);
  SerialThree.begin(115200, SERIAL_8N1, RXp0, TXp0);
  pinMode(buttonPin, INPUT_PULLUP);
  SerialThree.println("test");
#else
  Serial.println("This code is intended for ESP32. Please select an ESP32 board in the Arduino IDE.");
#endif*/


  
}

void loop() {
  
   if(i==false){
   Serial.println("Press button");
   i=true;
   }
   
   while(1)
   {
    if (digitalRead(buttonPin) == LOW) {
    // Button is pressed
    sensorstate = true;
    break;
     }
   }
   if(sensorstate==true){
  Serial.println("\r\nRecord start!");
  Audio* audioR = new Audio(ADMP441);
  audioR->Record();
  Serial.println("Recording Completed, Processing");
 
  CloudSpeechClient* cloudSpeechClient = new CloudSpeechClient(USE_APIKEY);
  cloudSpeechClient->Transcribe(audioR);
  delete cloudSpeechClient;
  delete audioR;
  i=false;
  }
  sensorstate=false;
 
}
