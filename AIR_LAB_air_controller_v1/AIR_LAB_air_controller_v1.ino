// OUTPUTS
int valve_pin = A0;
int pressure_pin = 5;

// INPUTS
int switch_pin = 10;
boolean switch_val = 0;
int pot_pin = A5;
int pot_val = 0;

void setup() {
  pinMode(valve_pin, OUTPUT);
  pinMode(pressure_pin, OUTPUT);
  pinMode(switch_pin, INPUT_PULLUP);
  pinMode(pot_pin, INPUT);
  Serial.begin(115200);
}

void loop() {
  // read sensors
  pot_val = 1023 - analogRead(pot_pin); // read the potentiometer and reverse the scale
  switch_val = !digitalRead(switch_pin); // read button and reverse the logic
  
  // set outputs
  analogWrite(pressure_pin, map(pot_val, 0, 1023, 0, 255));
  digitalWrite(valve_pin, switch_val);

  // Print for the serial plotter/monitor
  Serial.print(1023+500);
  Serial.print(",");
  Serial.print(-500);
  Serial.print(",");
  Serial.print(pot_val);
  Serial.print(",");
  Serial.println(switch_val*1023);
  

  // pause for a very short while
  delay(10);
}
