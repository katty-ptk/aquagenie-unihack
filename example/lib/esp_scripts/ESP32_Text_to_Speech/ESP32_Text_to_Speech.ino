#include "Arduino.h"
#include "WiFi.h"
#include "Audio.h"
#define uart_en 15
#define RXp2 16
#define TXp2 17
#define I2S_DOUT      22
#define I2S_BCLK      27
#define I2S_LRC       26

Audio audio;


void setup()
{

  Serial.begin(115200);
  Serial2.begin(115200, SERIAL_8N1, RXp2,TXp2);
  Serial3.begin(115200, SERIAL_8N1, RXp0,TXp0);
   
 if (Serial3.available()){
  String Answer3 = Serial3.readString();
    Serial.println(Answer);
 }

  WiFi.disconnect();
  WiFi.mode(WIFI_STA);
  WiFi.begin( "geo", "12345678");
 // WiFi.begin( "Olah's Galaxy A72", "xevr4131");

  while (WiFi.status() != WL_CONNECTED)
    delay(500);
  audio.setPinout(I2S_BCLK, I2S_LRC, I2S_DOUT);
  audio.setVolume(100);
  audio.connecttospeech("Starting ", "en"); // Google TTS


 /* xTaskCreate(
    taskSpeak,
    "Task 1",
    1000,
    NULL,
    1,
    NULL
    );

    xTaskCreate(
    task2,
    "Task2",
    1000,
    NULL,
    1,
    NULL
    );*/
}


void loop()
{
  
 if (Serial2.available()){
  String Answer = Serial2.readString();
  Serial.println(Answer);
 audio.connecttospeech(Answer.c_str(), "en");
  }
  audio.loop();

}



/*void taskSpeak(void *parameters)
{
  for(;;)
   
}*/


void audio_info(const char *info) {
  Serial.print("audio_info: "); Serial.println(info);}
