
#include "I2Cdev.h"
#include "MPU6050.h"
#include <Servo.h>

#if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
    #include "Wire.h"
#endif

// class default I2C address is 0x68
// specific I2C addresses may be passed as a parameter here
// AD0 low = 0x68 (default for InvenSense evaluation board)
// AD0 high = 0x69
MPU6050 accelgyro1(0x68);
MPU6050 accelgyro2(0x69); // <-- use for AD0 high

int16_t ax1, ay1, az1;
int16_t gx1, gy1, gz1;

int16_t ax2, ay2, az2;
int16_t gx2, gy2, gz2;

int16_t f1, f2, f3, f4;

#define FINGER1 5 // 食指
#define FINGER2 4 // 中指
#define FINGER3 3 // 無名指
#define FINGER4 2 // 小指

#define TRIGGER 10 // Button trigger
#define STOP 11    // Button servo arm stop
#define SERVO 6   // Servo motor pin
Servo servo;

int16_t servoActive = 0;
int16_t angle = 0;

//#define OUTPUT_READABLE_ACCELGYRO
#define OUTPUT_BINARY_ACCELGYRO

void setup() {
    #if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
        Wire.begin();
    #elif I2CDEV_IMPLEMENTATION == I2CDEV_BUILTIN_FASTWIRE
        Fastwire::setup(400, true);
    #endif

    Serial.begin(38400);

    // initialize device
    //Serial.println("Initializing I2C devices...");
    accelgyro1.initialize();
    accelgyro2.initialize();

    // verify connection
    //Serial.println("Testing device connections...");
    accelgyro1.testConnection();
    accelgyro2.testConnection();
    //Serial.println(accelgyro.testConnection() ? "MPU6050 connection successful" : "MPU6050 connection failed");

    // use the code below to change accel/gyro offset values
    /*
    Serial.println("Updating internal sensor offsets...");
    // -76	-2359	1688	0	0	0
    Serial.print(accelgyro.getXAccelOffset()); Serial.print("\t"); // -76
    Serial.print(accelgyro.getYAccelOffset()); Serial.print("\t"); // -2359
    Serial.print(accelgyro.getZAccelOffset()); Serial.print("\t"); // 1688
    Serial.print(accelgyro.getXGyroOffset()); Serial.print("\t"); // 0
    Serial.print(accelgyro.getYGyroOffset()); Serial.print("\t"); // 0
    Serial.print(accelgyro.getZGyroOffset()); Serial.print("\t"); // 0
    Serial.print("\n");
    accelgyro.setXGyroOffset(220);
    accelgyro.setYGyroOffset(76);
    accelgyro.setZGyroOffset(-85);
    Serial.print(accelgyro.getXAccelOffset()); Serial.print("\t"); // -76
    Serial.print(accelgyro.getYAccelOffset()); Serial.print("\t"); // -2359
    Serial.print(accelgyro.getZAccelOffset()); Serial.print("\t"); // 1688
    Serial.print(accelgyro.getXGyroOffset()); Serial.print("\t"); // 0
    Serial.print(accelgyro.getYGyroOffset()); Serial.print("\t"); // 0
    Serial.print(accelgyro.getZGyroOffset()); Serial.print("\t"); // 0
    Serial.print("\n");
    */
     // number 0
//    accelgyro1.setXAccelOffset(-706);
//    accelgyro1.setYAccelOffset(-918);
//    accelgyro1.setZAccelOffset(607);
//    accelgyro1.setXGyroOffset(10479);
//    accelgyro1.setYGyroOffset(1337);
//    accelgyro1.setZGyroOffset(-319);

    // number 1
//    accelgyro2.setXAccelOffset(-221);
//    accelgyro2.setYAccelOffset(377);
//    accelgyro2.setZAccelOffset(1531);
//    accelgyro2.setXGyroOffset(113);
//    accelgyro2.setYGyroOffset(-69);
//    accelgyro2.setZGyroOffset(-69);
    
    pinMode(FINGER1, INPUT);
    pinMode(FINGER2, INPUT);
    pinMode(FINGER3, INPUT);
    pinMode(FINGER4, INPUT);

    pinMode(TRIGGER, INPUT_PULLUP);
    pinMode(STOP, INPUT_PULLUP);

    
}

void loop() {
    // read raw accel/gyro measurements from device
    accelgyro1.getMotion6(&ax1, &ay1, &az1, &gx1, &gy1, &gz1);
    accelgyro2.getMotion6(&ax2, &ay2, &az2, &gx2, &gy2, &gz2);

    f1 = digitalRead(FINGER1);
    f2 = digitalRead(FINGER2);
    f3 = digitalRead(FINGER3);
    f4 = digitalRead(FINGER4);


    
    if(servoActive == 1) {
      servo.write(++angle);
      delay(20);
      if(digitalRead(STOP) == 0 || angle >= 180){
        servoActive = 0;
        servo.write(0);
        delay(700);
        servo.detach();
      }
    } else if(digitalRead(TRIGGER) == 0){
      servo.attach(SERVO, 500, 2400);
      servoActive = 1;
      angle = 0;
    }

//    for(int i = 500; i <= 2400; i+=100){
//      myservo.writeMicroseconds(i); // 直接以脈衝寬度控制
//      delay(300);
//    }

    #ifdef OUTPUT_READABLE_ACCELGYRO
        Serial.print("a/g:\t");
        Serial.print(ax); Serial.print("\t");
        Serial.print(ay); Serial.print("\t");
        Serial.print(az); Serial.print("\t");
        Serial.print(gx); Serial.print("\t");
        Serial.print(gy); Serial.print("\t");
        Serial.println(gz);
    #endif

    #ifdef OUTPUT_BINARY_ACCELGYRO
        Serial.write((uint8_t)'$');
        Serial.write((uint8_t)'2');
        Serial.write((uint8_t)(ax1 >> 8)); Serial.write((uint8_t)(ax1 & 0xFF));
        Serial.write((uint8_t)(ay1 >> 8)); Serial.write((uint8_t)(ay1 & 0xFF));
        Serial.write((uint8_t)(az1 >> 8)); Serial.write((uint8_t)(az1 & 0xFF));
        Serial.write((uint8_t)(gx1 >> 8)); Serial.write((uint8_t)(gx1 & 0xFF));
        Serial.write((uint8_t)(gy1 >> 8)); Serial.write((uint8_t)(gy1 & 0xFF));
        Serial.write((uint8_t)(gz1 >> 8)); Serial.write((uint8_t)(gz1 & 0xFF));
        Serial.write((uint8_t)(ax2 >> 8)); Serial.write((uint8_t)(ax2 & 0xFF));
        Serial.write((uint8_t)(ay2 >> 8)); Serial.write((uint8_t)(ay2 & 0xFF));
        Serial.write((uint8_t)(az2 >> 8)); Serial.write((uint8_t)(az2 & 0xFF));
        Serial.write((uint8_t)(gx2 >> 8)); Serial.write((uint8_t)(gx2 & 0xFF));
        Serial.write((uint8_t)(gy2 >> 8)); Serial.write((uint8_t)(gy2 & 0xFF));
        Serial.write((uint8_t)(gz2 >> 8)); Serial.write((uint8_t)(gz2 & 0xFF));
        Serial.write((uint8_t)(f1));
        Serial.write((uint8_t)(f2));
        Serial.write((uint8_t)(f3));
        Serial.write((uint8_t)(f4));
        Serial.write((uint8_t)(servoActive));
        Serial.write((uint8_t)(angle));
        Serial.write((uint8_t)'\r');
        Serial.write((uint8_t)'\r');
    #endif
}
