#include <HX711_ADC.h>
#if defined(ESP8266) || defined(ESP32) || defined(AVR)
#include <EEPROM.h>
#endif

// Pins:
const int HX711_dout = 25; // MCU > HX711 dout pin
const int HX711_sck = 26;  // MCU > HX711 sck pin
const int ledred = 12;
const int ledgreen = 27;
const int ledblue = 14;

// HX711 constructor:
HX711_ADC LoadCell(HX711_dout, HX711_sck);

const int calVal_eepromAdress = 0;
unsigned long t = 0;
unsigned long stableStartTime = 0;
unsigned long alarmStartTime = 0;
bool isStable = false;
bool alarmTriggered = false;
const int hourlyAmount = 60; // Adjust this according to your needs
int previousWeight = 0;
int stableWeight = 0;
int stableWeight2 = 0;
int waterDrank = 0;

void setup() {
  Serial.begin(115200);
  float calibrationValue; // Calibration value
  calibrationValue = 721.69; // Uncomment this if you want to set this value in the sketch
#if defined(ESP8266) || defined(ESP32)
  // EEPROM.begin(512); // Uncomment this if you use ESP8266 and want to fetch this value from EEPROM
#endif
  // EEPROM.get(calVal_eepromAdress, calibrationValue); // Uncomment this if you want to fetch this value from EEPROM

  LoadCell.begin();
  unsigned long stabilizingtime = 2000;
  bool _tare = true;
  LoadCell.start(stabilizingtime, _tare);
  if (LoadCell.getTareTimeoutFlag()) {
    Serial.println("Timeout, check MCU > HX711 wiring and pin designations");
  } else {
    LoadCell.setCalFactor(calibrationValue);
    Serial.println("Startup is complete");
  }
  while (!LoadCell.update());
  Serial.print("Calibration value: ");
  Serial.println(LoadCell.getCalFactor());
  Serial.println("Note that the settling time may increase significantly if you use delay() in your sketch!");

  //setup led
  pinMode(ledred, OUTPUT);
  pinMode(ledgreen, OUTPUT);
  pinMode(ledblue, OUTPUT);
}


void loop() {
  static bool newDataReady = false;
  const int serialPrintInterval = 0;
  

  if (LoadCell.update()) newDataReady = true;

  if (newDataReady) {
    int weight = LoadCell.getData();
    Serial.print("Load_cell output val: ");
    Serial.println(weight);

    leddefault(weight);
    checkStability(weight);
    checkAlarm(weight);

    newDataReady = false;
    t = millis();
  }


  if (Serial.available() > 0) {
    char inByte = Serial.read();
    if (inByte == 't') LoadCell.tareNoDelay();
  }

  if (LoadCell.getTareStatus() == true) {
    Serial.println("Tare complete");
  }

  vTaskDelay(100/portTICK_PERIOD_MS);
}


void checkStability(int currentWeight) {
  const unsigned long stabilityTime = 15000; // 5 seconds for stability
  Serial.println("Difference: ");
  Serial.print(currentWeight - previousWeight);

  if (abs(currentWeight - previousWeight) == 0 && currentWeight != 0) {
    if (!isStable) {
      Serial.println("Water level stable");
      if(currentWeight < stableWeight){
        waterDrank = waterDrank + (stableWeight-currentWeight);
        Serial.println("Water drank:________________________________----------------------------------------------------------------");
        Serial.println(waterDrank);
      }
      stableWeight = currentWeight;
      isStable = true; // Set stableStartTime only when isStable transitions from false to true
      alarmStartTime = millis();   // Reset alarmStartTime when isStable becomes true
    }
    
    Serial.println("timp");
    Serial.println(millis() - alarmStartTime);
    if (millis() - alarmStartTime > stabilityTime && !alarmTriggered && stableWeight == currentWeight) { // 1 hour = 3600000 milliseconds; 10s for testing
      Serial.println("Triggering alarm");
      alarmTriggered = true;
    }
  } else {
    isStable = false;
    alarmTriggered = false;
    // Commented out the following line to prevent resetting stableStartTime
    // stableStartTime = millis();
  }

  previousWeight = currentWeight;
}

void checkAlarm(int& currentWeight) {
  while (alarmTriggered == true) {
    blinkred();
    LoadCell.update();
    currentWeight = LoadCell.getData();
    Serial.println("greutate noua:");
    Serial.println(currentWeight);
    
    Serial.println("Difference: ");
    Serial.println(currentWeight - previousWeight);
    Serial.println(currentWeight);
    Serial.println("Stable weight");
    Serial.println(stableWeight);
    if (abs(previousWeight - currentWeight) == 0 && currentWeight != 0 && currentWeight != stableWeight) {
      stableWeight2 = currentWeight;
      Serial.println("greutate echi 2:");
      Serial.println(stableWeight2);
      }
    delay(200);
    previousWeight = currentWeight;
    int targetWeight = stableWeight - hourlyAmount;
    
    if ((stableWeight2 <= targetWeight) && stableWeight2 != 0 && stableWeight2 != stableWeight) {
      waterDrank = waterDrank + (stableWeight - stableWeight2);
      Serial.println("waterdrank");
      Serial.print(waterDrank);
      alarmTriggered = false;
      alarmStartTime = millis();   // Reset alarmStartTime when isStable becomes true
      Serial.println("alarma oprita _____________________________");
      }
     
    
  }
}




void redOn(){
  digitalWrite(ledred, HIGH);
  digitalWrite(ledgreen, LOW);
  digitalWrite(ledblue, LOW);
  Serial.print("rosu");
}

void greenOn(){
  digitalWrite(ledred, LOW);
  digitalWrite(ledgreen, HIGH);
  digitalWrite(ledblue, LOW);
  Serial.print("verde");
}

void blueOn(){
  digitalWrite(ledred, LOW);
  digitalWrite(ledgreen, LOW);
  digitalWrite(ledblue, HIGH);
  Serial.print("albastru");
}


void blinkred(){
  digitalWrite(ledred, !digitalRead(ledred));
  digitalWrite(ledgreen, LOW);
  digitalWrite(ledblue, LOW);
  Serial.print("palpaie");
}

void leddefault(int weight){
  if(weight<=hourlyAmount)
    blueOn();
  else if(alarmTriggered == false)
    greenOn();
}
