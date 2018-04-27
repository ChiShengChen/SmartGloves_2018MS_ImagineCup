#include <Servo.h>

Servo myservo; // 建立Servo物件，控制伺服馬達

//放開=1,按住=0
int button0 = 4;
int button1 = 5;

void setup() 
{ 
  pinMode(button0, INPUT_PULLUP);
  pinMode(button1, INPUT_PULLUP);
  Serial.begin(9600);
} 

void loop() 
{
if(digitalRead(button0) == 0)
 {  
    
  /*for(int i = 0; i <= 180; i+=1){
    myservo.write(i); 
    delay(20);
  }*/
  for(int i = 180; i >= 0; i-=1)
   {
    myservo.attach(3);
    myservo.write(i);
    delay(20);     
    if(digitalRead(button1) == 0)
     { 
       myservo.detach(); 
       Serial.println(i);
       break;
     }
   }
  }
 
}
