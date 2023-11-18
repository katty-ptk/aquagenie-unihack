String inputString = "ssid->roland\n->password->denis";

void setup() {
  Serial.begin(115200);
  extractValues("ssid->roland\n->password->denis");
}

void loop() {
  // Your main code here
}

void extractValues(String input) {
  // Find the position of "->" to locate the username
  int usernameStart = input.indexOf("->") + 2;
  int usernameEnd = input.indexOf("\n", usernameStart);
  String username = input.substring(usernameStart, usernameEnd);

  // Find the position of "->" after "password" to locate the password
  int passwordStart = input.indexOf("password->") + 10;
  String password = input.substring(passwordStart);

  // Print the extracted values
  Serial.print("Username: ");
  Serial.println(username);
  Serial.print("Password: ");
  Serial.println(password);
}
