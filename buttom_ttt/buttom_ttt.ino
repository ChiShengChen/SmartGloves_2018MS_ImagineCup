int button0 = 4;
int button1 = 2;
//放開=1,按住=0
void setup() {
pinMode(button0, INPUT_PULLUP);
pinMode(button1, INPUT_PULLUP);
Serial.begin(9600);
}

void loop() {
Serial.println(digitalRead(button0));
Serial.println(digitalRead(button1));
Serial.println("-----------------");
}
