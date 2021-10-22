// controlling airflow into a silicon air pocket with streamed sensor data

// OUTPUTS
int valve_pin = A0;
int pressure_pin = 5;
int led_pin = 11;

// INPUTS
int switch_pin = 10;
boolean switch_val = 0;
int pot_pin = A5;
int pot_val = 0;

int value = 0;
int channel;

void setup() {
  pinMode(valve_pin, OUTPUT);
  pinMode(pressure_pin, OUTPUT);
  pinMode(led_pin, OUTPUT);
  //pinMode(switch_pin, INPUT_PULLUP);
  //pinMode(pot_pin, INPUT);
  Serial.begin(115200);
}

void loop() {
  // read sensors
  //pot_val = 1023 - analogRead(pot_pin); // read the potentiometer and reverse the scale
  //switch_val = !digitalRead(switch_pin); // read button and reverse the logic
  
  // set outputs
  //analogWrite(pressure_pin, map(pot_val, 0, 1023, 0, 255));
  //digitalWrite(valve_pin, switch_val);

  // Print for the serial plotter/monitor
  /*
  Serial.print(1023+500);
  Serial.print(",");
  Serial.print(-500);
  Serial.print(",");
  Serial.print(pot_val);
  Serial.print(",");
  Serial.println(switch_val*1023);
  */

  // pause for a very short while
  //delay(10);

  int c;

  while(!Serial.available());
  c = Serial.read();
  if ((c>='0') && (c<='9')) {
    value = 10*value + c - '0';
  } else {
    if (c=='c') channel = value;
    else if (c=='w') {
      if (channel == 1){
        analogWrite(led_pin, value);
        analogWrite(pressure_pin, value);
      }
      else if (channel == 2){
        if (value == 0) digitalWrite(valve_pin, LOW);
        if (value == 255) digitalWrite(valve_pin, HIGH);
      }
    }
    value = 0;
  }


  
}
