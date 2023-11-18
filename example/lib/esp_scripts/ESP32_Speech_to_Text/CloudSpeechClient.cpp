#include "CloudSpeechClient.h"
#include "network_param.h"
#include <base64.h>
#include <ArduinoJson.h>
#define USE_SERIAL Serial
#include <Arduino.h>
#include <HTTPClient.h>

const char* chatgpt_token = "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";
  // Declare password as a pointer to a constant character
CloudSpeechClient::CloudSpeechClient(Authentication authentication) {
  this->authentication = authentication;
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) delay(500);
  client.setCACert(root_ca);

  if (!client.connect(server, 443)) {
    Serial.println("Connection failed!");
  }
}

String ans;
CloudSpeechClient::~CloudSpeechClient() {
  client.stop();
  WiFi.disconnect();
}

void CloudSpeechClient::PrintHttpBody2(Audio* audio) {
  String enc = base64::encode(audio->paddedHeader, sizeof(audio->paddedHeader));
  enc.replace("\n", "");  // delete last "\n"
  client.print(enc);      // HttpBody2
  char** wavData = audio->wavData;
  for (int j = 0; j < audio->wavDataSize / audio->dividedWavDataSize; ++j) {
    enc = base64::encode((byte*)wavData[j], audio->dividedWavDataSize);
    enc.replace("\n", "");// delete last "\n"
    client.print(enc);    // HttpBody2
  }
}

void CloudSpeechClient::Transcribe(Audio* audio) {
  String HttpBody1 = "{\"config\":{\"encoding\":\"LINEAR16\",\"sampleRateHertz\":16000,\"languageCode\":\"en-IN\"},\"audio\":{\"content\":\"";
  String HttpBody3 = "\"}}\r\n\r\n";
  int httpBody2Length = (audio->wavDataSize + sizeof(audio->paddedHeader)) * 4 / 3; // 4/3 is from base64 encoding
  String ContentLength = String(HttpBody1.length() + httpBody2Length + HttpBody3.length());
  String HttpHeader = String("POST /v1/speech:recognize?key=") + ApiKey
    + String(" HTTP/1.1\r\nHost: speech.googleapis.com\r\nContent-Type: application/json\r\nContent-Length: ") + ContentLength + String("\r\n\r\n");
  client.print(HttpHeader);
  client.print(HttpBody1);
  PrintHttpBody2(audio);
  client.print(HttpBody3);
  String My_Answer = "";
  while (!client.available());

  while (client.available()) {
    char temp = client.read();
    My_Answer = My_Answer + temp;
  }

  int postion = My_Answer.indexOf('{');
  ans = My_Answer.substring(postion);
  DynamicJsonDocument doc(384);
  DeserializationError error = deserializeJson(doc, ans);

  if (error) {
    Serial.print("deserializeJson() failed: ");
    Serial.println(error.c_str());
    return;
  }

  JsonObject results_0 = doc["results"][0];
  const char* chatgpt_Q = results_0["alternatives"][0]["transcript"];
  if(chatgpt_Q)
  {
  Serial.println(chatgpt_Q);
  Serial.print("Asking Chat GPT");
  HTTPClient https;
  if (https.begin("https://api.openai.com/v1/completions")) {  // HTTPS
    https.addHeader("Content-Type", "application/json");
    String token_key = String("Bearer ") + chatgpt_token;
    https.addHeader("Authorization", token_key);
    String payload = String("{\"model\": \"text-davinci-003\", \"prompt\": ") + "\"" + chatgpt_Q + "\"" + String(", \"temperature\": 0.2, \"max_tokens\": 40}");
    //Instead of TEXT as Payload, can be JSON as Payload
    // start connection and send HTTP header
    int httpCode = https.POST(payload);
    // httpCode will be negative on error
    // file found at server
    if (httpCode == HTTP_CODE_OK || httpCode == HTTP_CODE_MOVED_PERMANENTLY) {
      String payload = https.getString();
   
      StaticJsonDocument<2000> doc2;
      DeserializationError error = deserializeJson(doc2, payload);

      if (error) {
        Serial.print("deserializeJson() failed: ");
        Serial.println(error.c_str());
        return;
      }

      JsonObject choices_0 = doc2["choices"][0];
      const char* only_ans = choices_0["text"];
      Serial.println(only_ans);
      Serial2.println(only_ans);
    }
    else {
      Serial.printf("[HTTPS] GET... failed, error: %s\n", https.errorToString(httpCode).c_str());
    }
    https.end();
  } else {
    Serial.printf("[HTTPS] Unable to connect\n");
  }
  }
  else{
    Serial.println("NIMIC");
  }
}
