
#include <string.h>
#include <stdio.h>
void printDecodedString(char stringToDecode[]){
    char wifi_ssid[20], wifi_password[20];

    char *copy = strdup(stringToDecode);  // Create a copy of the string
    if (copy == NULL) {
        fprintf(stderr, "Memory allocation failed");
        return;
    }

    // Handle the first token separately
    char *token = strtok(copy, "\n");
    if (token != NULL) {
      //  printf("One copy: %s\n", token);
        strcpy(wifi_ssid, strchr(token, '>') + 1);
    }

    // Continue with the rest of the tokens
    while (token != NULL) {
        token = strtok(NULL, "\n");
        if (token != NULL) {
            strcpy(wifi_password, strchr(token, '>') + 1);
        }
    }

    Serial.println( wifi_ssid);
    Serial.println( wifi_password);
}

void setup(){
 Serial.begin(115200);
printDecodedString("ssid->viwrnvir\npassword->eerber");
}


void loop(){
    
}
