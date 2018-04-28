import processing.serial.*;

boolean DEBUG = true;
boolean LOG = false;

Serial port;

Table table;



final int INIT = 0;
final int SHOWDATA = 1;
final int TOUCHFINGER = 2;
final int SENSEANGLE = 3;

int sysState = INIT;



color lightBlue = color(193, 215, 236);
color blue = color(104, 155, 208);
color deepBlue = color(62, 116, 176);
color cyan = color(116, 250, 206);
color bgColor = color(230, 230, 230);
color gray = color(50, 50, 50);
color lightGray = color(160, 160, 160);

short ax1, ay1, az1, gx1, gy1, gz1;
float axg1, ayg1, azg1;
float roll1, yaw1, pitch1;
short ax2, ay2, az2, gx2, gy2, gz2;
float axg2, ayg2, azg2;
float roll2, yaw2, pitch2;
int f1, f2, f3, f4;
int buff;
byte[] inbuffer = new byte[12];
int time, oldtime;
int id;
short motorupdate = 0;
short angle = 0;


short[] ax1Arr = new short[20];
short[] ay1Arr = new short[20];
short[] az1Arr = new short[20];
short[] gx1Arr = new short[20];
short[] gy1Arr = new short[20];
short[] gz1Arr = new short[20];
short[] ax2Arr = new short[20];
short[] ay2Arr = new short[20];
short[] az2Arr = new short[20];
short[] gx2Arr = new short[20];
short[] gy2Arr = new short[20];
short[] gz2Arr = new short[20];
short[] angleArr = new short[20];


int packetSize = 34;
short[] teapotPacket = new short[packetSize];  // InvenSense Teapot packet
int serialCount = 0;                 // current packet byte position
int aligned = 0;


float allScale = 0.8;
float circleScale = 1.0;

PImage logo;

void setup() {

  size(1000, 800);
  background(bgColor);

  initValues();

  if (!DEBUG) {
    println(Serial.list());
    String portName = Serial.list()[3];
    port = new Serial(this, portName, 38400);
  }

  if (LOG) {
    table = new Table();

    table.addColumn("id");
    table.addColumn("time");
    table.addColumn("ax1");
    table.addColumn("ay1");
    table.addColumn("az1");
    table.addColumn("gx1");
    table.addColumn("gy1");
    table.addColumn("gz1");
    table.addColumn("ax2");
    table.addColumn("ay2");
    table.addColumn("az2");
    table.addColumn("gx2");
    table.addColumn("gy2");
    table.addColumn("gz2");
    table.addColumn("f1");
    table.addColumn("f2");
    table.addColumn("f3");
    table.addColumn("f4");
  }
  logo = loadImage("logo.png");
  
  initAllButton();
}

void draw() {
  background(bgColor);
  noFill();

  image(logo, 350, 0, 300, 60);

  pushMatrix();
  translate(0, 70);

  switch(sysState) {
  case INIT:
    drawInit();
    break;
  case SHOWDATA:
    drawShowData();
    break;
  case TOUCHFINGER:
    drawTouchFinger();
    break;
  case SENSEANGLE:
    drawSenseAngle();
    break;
  }

  popMatrix();
}









void initValues() {
  for (int i = 0; i < 20; ++i) {
    ax1Arr[i] = 0;
    ay1Arr[i] = 0;
    az1Arr[i] = 0;
    gx1Arr[i] = 0;
    gy1Arr[i] = 0;
    gz1Arr[i] = 0;
    ax2Arr[i] = 0;
    ay2Arr[i] = 0;
    az2Arr[i] = 0;
    gx2Arr[i] = 0;
    gy2Arr[i] = 0;
    gz2Arr[i] = 0;
    yaw1 = 0;
    yaw2 = 0;
    angleArr[i] = 0;
  }
}

void serialEvent(Serial port) {

  while (port.available() > 0) {
    int ch = port.read();
    //print((char)ch);
    if (aligned < 4) {
      // make sure we are properly aligned on a 16-byte packet
      if (ch == '$') {
        serialCount = 0;
      }
      if (serialCount == 0) {
        if (ch == '$') aligned++; 
        else aligned = 0;
      } else if (serialCount == 1) {
        if (ch == '2') aligned++; 
        else aligned = 0;
      } else if (serialCount == packetSize-2) {
        if (ch == '\r') aligned++; 
        else aligned = 0;
      } else if (serialCount == packetSize-1) {
        if (ch == '\r') aligned++; 
        else aligned = 0;
      }
      println((char)ch + " " + aligned + " " + serialCount);
      serialCount++;
      if (serialCount == packetSize) serialCount = 0;
    } else {
      if (serialCount > 0 || ch == '$') {
        teapotPacket[serialCount++] = (short)ch;
        if (serialCount == packetSize) {
          serialCount = 0; // restart packet byte position

          oldtime = time;
          time = millis();

          ax1 = (short)((teapotPacket[2] << 8) + teapotPacket[3]);
          ay1 = (short)((teapotPacket[4] << 8) + teapotPacket[5]);
          az1 = (short)((teapotPacket[6] << 8) + teapotPacket[7]);
          gx1 = (short)((teapotPacket[8] << 8) + teapotPacket[9]);
          gy1 = (short)((teapotPacket[10] << 8) + teapotPacket[11]);
          gz1 = (short)((teapotPacket[12] << 8) + teapotPacket[13]);

          ax2 = (short)((teapotPacket[14] << 8) + teapotPacket[15]);
          ay2 = (short)((teapotPacket[16] << 8) + teapotPacket[17]);
          az2 = (short)((teapotPacket[18] << 8) + teapotPacket[19]);
          gx2 = (short)((teapotPacket[20] << 8) + teapotPacket[21]);
          gy2 = (short)((teapotPacket[22] << 8) + teapotPacket[23]);
          gz2 = (short)((teapotPacket[24] << 8) + teapotPacket[25]);

          f1 = (short)(teapotPacket[26]);
          f2 = (short)(teapotPacket[27]);
          f3 = (short)(teapotPacket[28]);
          f4 = (short)(teapotPacket[29]);

          motorupdate = (short)(teapotPacket[30]);
          angle = (short)(teapotPacket[31]);


          if (LOG) {
            TableRow newRow = table.addRow();
            id = table.getRowCount() - 1;
            newRow.setInt("id", id);
            newRow.setInt("time", time);
            newRow.setInt("ax1", ax1);
            newRow.setInt("ay1", ay1);
            newRow.setInt("az1", ay1);
            newRow.setInt("gx1", gx1);
            newRow.setInt("gy1", gy1);
            newRow.setInt("gz1", gy1);
            newRow.setInt("ax2", ax2);
            newRow.setInt("ay2", ay2);
            newRow.setInt("az2", ay2);
            newRow.setInt("gx2", gx2);
            newRow.setInt("gy2", gy2);
            newRow.setInt("gz2", gy2);
            newRow.setInt("f1", f1);
            newRow.setInt("f2", f2);
            newRow.setInt("f3", f3);
            newRow.setInt("f4", f4);
          }

          for (int i = 0; i < 19; ++i) {
            ax1Arr[i] = ax1Arr[i+1];
            ay1Arr[i] = ay1Arr[i+1];
            az1Arr[i] = az1Arr[i+1];
            gx1Arr[i] = gx1Arr[i+1];
            gy1Arr[i] = gy1Arr[i+1];
            gz1Arr[i] = gz1Arr[i+1];
            ax2Arr[i] = ax2Arr[i+1];
            ay2Arr[i] = ay2Arr[i+1];
            az2Arr[i] = az2Arr[i+1];
            gx2Arr[i] = gx2Arr[i+1];
            gy2Arr[i] = gy2Arr[i+1];
            gz2Arr[i] = gz2Arr[i+1];
          }
          ax1Arr[19] = ax1;
          ay1Arr[19] = ay1;
          az1Arr[19] = az1;
          gx1Arr[19] = gx1;
          gy1Arr[19] = gy1;
          gz1Arr[19] = gz1;
          ax2Arr[19] = ax2;
          ay2Arr[19] = ay2;
          az2Arr[19] = az2;
          gx2Arr[19] = gx2;
          gy2Arr[19] = gy2;
          gz2Arr[19] = gz2;


          if (motorupdate == 1) {
            for (int i = 0; i < 19; ++i) {
              angleArr[i] = angleArr[i+1];
            }
            angleArr[19] = angle;
          }

          roll1 = degrees(atan2(ay1, az1));
          roll2 = degrees(atan2(ay2, az2));
          pitch1 = degrees(atan2(ax1, sqrt(ay1*ay1 + az1*az1)));
          pitch2 = degrees(atan2(ax2, sqrt(ay2*ay2 + az2*az2)));


          yaw1 = degrees(radians(yaw1) + gz1*3.5*(time-oldtime)/1000000)*0.99;
          yaw2 = degrees(radians(yaw2) + gz2*3.5*(time-oldtime)/1000000)*0.99;


          //print(id + "\t" + time + "\t");
          //print(ax1 + "\t" + ay1 + "\t" + az1 + "\t" + gx1 + "\t" + gy1 + "\t" + gz1 + "\t");
          //print(ax2 + "\t" + ay2 + "\t" + az2 + "\t" + gx2 + "\t" + gy2 + "\t" + gz2 + "\t");
          //println(f1 + "\t" + f2 + "\t" + f3 + "\t" + f4);
          println(yaw2);
        }
      }
    }
  }
}
