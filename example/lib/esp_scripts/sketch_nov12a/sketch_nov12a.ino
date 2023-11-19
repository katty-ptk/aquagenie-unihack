int count1=0;
int count2=0;
int count3=0;
#define buttonPin 23
bool sensorstate = false;

#include <HX711_ADC.h>
#if defined(ESP8266)|| defined(ESP32) || defined(AVR)
#include <EEPROM.h>
#endif

//pins:
const int HX711_dout = 12; //mcu > HX711 dout pin
const int HX711_sck = 13; //mcu > HX711 sck pin

//HX711 constructor:
HX711_ADC LoadCell(HX711_dout, HX711_sck);

const int calVal_eepromAdress = 0;
unsigned long t = 0;


void task3(void * parameters)
{
  for(;;){
    if (digitalRead(buttonPin) == HIGH)
    {
      sensorstate = true;
      Serial.print("Task3 counter:");
      Serial.println(count3++);
    }
    vTaskDelay(10/portTICK_PERIOD_MS);
  }
}
void task1(void * parameters)
{
  for(;;){
    Serial.print("Task1 counter:");
    Serial.println(count1++);
    vTaskDelay(10/portTICK_PERIOD_MS);
  }
}
void task2(void * parameters)
{
  for(;;){
   static boolean newDataReady = 0;
  //const int serialPrintInterval = 500;
  const int serialPrintInterval = 0;
  //increase value to slow down serial print activity

  // check for new data/start next conversion:
  if (LoadCell.update()) newDataReady = true;

  // get smoothed value from the dataset:
  if (newDataReady) {
    if (millis() > t + serialPrintInterval) {
      float i = LoadCell.getData();
      Serial.print("Load_cell output val: ");
      Serial.println(i);
      newDataReady = 0;
      t = millis();
    }
  }

  // receive command from serial terminal, send 't' to initiate tare operation:
  if (Serial.available() > 0) {
    char inByte = Serial.read();
    if (inByte == 't') LoadCell.tareNoDelay();
  }

  // check if last tare operation is complete:
  if (LoadCell.getTareStatus() == true) {
    Serial.println("Tare complete");
  }
    vTaskDelay(10/portTICK_PERIOD_MS);
  }
}


void setup() {

float calibrationValue; // calibration value
  calibrationValue = -721.69; // uncomment this if you want to set this value in the sketch
#if defined(ESP8266) || defined(ESP32)
  //EEPROM.begin(512); // uncomment this if you use ESP8266 and want to fetch this value from eeprom
#endif
  //EEPROM.get(calVal_eepromAdress, calibrationValue); // uncomment this if you want to fetch this value from eeprom

  LoadCell.begin();
  //LoadCell.setReverseOutput();
  unsigned long stabilizingtime = 2000; // tare preciscion can be improved by adding a few seconds of stabilizing time
  boolean _tare = true; //set this to false if you don't want tare to be performed in the next step
  LoadCell.start(stabilizingtime, _tare);
  if (LoadCell.getTareTimeoutFlag()) {
    Serial.println("Timeout, check MCU>HX711 wiring and pin designations");
  }
  else {
    LoadCell.setCalFactor(calibrationValue); // set calibration factor (float)
    Serial.println("Startup is complete");
  }
  while (!LoadCell.update());
  Serial.print("Calibration value: ");
  Serial.println(LoadCell.getCalFactor());
  Serial.print("HX711 measured conversion time ms: ");
  Serial.println(LoadCell.getConversionTime());
  Serial.print("HX711 measured sampling rate HZ: ");
  Serial.println(LoadCell.getSPS());
  Serial.print("HX711 measured settlingtime ms: ");
  Serial.println(LoadCell.getSettlingTime());
  Serial.println("Note that the settling time may increase significantly if you use delay() in your sketch!");
  if (LoadCell.getSPS() < 7) {
    Serial.println("!!Sampling rate is lower than specification, check MCU>HX711 wiring and pin designations");
  }
  else if (LoadCell.getSPS() > 100) {
    Serial.println("!!Sampling rate is higher than specification, check MCU>HX711 wiring and pin designations");
  }

  
  pinMode(buttonPin, INPUT_PULLUP);
  Serial.begin(115200);
  xTaskCreate(
    task1,
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
    );

}

void loop() {
  // put your main code here, to run repeatedly:

}
