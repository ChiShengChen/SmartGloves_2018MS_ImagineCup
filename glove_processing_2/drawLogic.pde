void drawTouchFinger() {
}

void drawSenseAngle() {
}

void drawInit() {
  drawInitButtons();
}



void drawShowData() {
  // MPU1 raw data charts
  drawChart(ax1Arr, "MPU1: Accel X", 0, 0, allScale, allScale);
  drawChart(ay1Arr, "MPU1: Accel Y", 230, 0, allScale, allScale);
  drawChart(az1Arr, "MPU1: Accel Z", 460, 0, allScale, allScale);
  drawChart(gx1Arr, "MPU1: Gyro  X", 0, 100, allScale, allScale);
  drawChart(gy1Arr, "MPU1: Gyro  Y", 230, 100, allScale, allScale);
  drawChart(gz1Arr, "MPU1: Gyro  Z", 460, 100, allScale, allScale);

  // MPU2 raw data charts
  drawChart(ax2Arr, "MPU2: Accel X", 0, 250, allScale, allScale);
  drawChart(ay2Arr, "MPU2: Accel Y", 230, 250, allScale, allScale);
  drawChart(az2Arr, "MPU2: Accel Z", 460, 250, allScale, allScale);
  drawChart(gx2Arr, "MPU2: Gyro  X", 0, 350, allScale, allScale);
  drawChart(gy2Arr, "MPU2: Gyro  Y", 230, 350, allScale, allScale);
  drawChart(gz2Arr, "MPU2: Gyro  Z", 460, 350, allScale, allScale);

  drawChartAngle(angleArr, "Motor Angle:", 550, 460, allScale+0.5, allScale+0.5);

  drawCircle(f1, "Index finger", 20, 490, circleScale, circleScale);
  drawCircle(f2, "Middle finger", 150, 490, circleScale, circleScale);
  drawCircle(f3, "Third finger", 280, 490, circleScale, circleScale);
  drawCircle(f4, "Little finger", 410, 490, circleScale, circleScale);

  drawSerialData();

  drawRollPitchYaw(roll1, pitch1, yaw1, "Roll / Pitch / Yaw", 700, 20);
  drawRollPitchYaw(roll2, pitch2, yaw2, "Roll / Pitch / Yaw", 700, 270);
}


void drawChart(short[] arr, String label, int x, int y, float xS, float yS) {
  pushMatrix();
  noFill();
  translate(x, y);
  scale(xS, yS);
  strokeWeight(3);
  stroke(blue);
  rect(19, 20, 192, 80);
  stroke(deepBlue);
  strokeWeight(4);
  //color(113, 247, 235);

  beginShape();
  for (int i = 0; i < 20; ++i) { 
    vertex(20+10*i, 60+map(arr[i], -32768, 32768, -40, 40));
  }
  endShape();
  fill(blue);
  textSize(16);
  text(label, 20, 15);
  popMatrix();
}




void drawChartAngle(short[] arr, String label, int x, int y, float xS, float yS) {
  pushMatrix();
  noFill();
  translate(x, y);
  scale(xS, yS);
  strokeWeight(3);
  stroke(blue);
  rect(19, 20, 192, 80);
  stroke(deepBlue);
  strokeWeight(4);
  //color(113, 247, 235);

  beginShape();
  for (int i = 0; i < 20; ++i) { 
    vertex(20+10*i, 60+map(arr[i], 180, 0, -30, 30));
  }
  endShape();
  fill(blue);
  textSize(16);
  text(label, 20, 15);
  popMatrix();
}





void drawCircle(int status, String label, int x, int y, float xS, float yS) {
  pushMatrix();
  translate(x, y);
  scale(xS, yS);
  if (status == 0) {
    noFill();
  } else {
    //fill(cyan);
    fill(18, 216, 178);
  }
  strokeWeight(3);
  stroke(blue);
  ellipse(50, 60, 100, 100);
  fill(blue);
  textSize(16);
  text(label, 0, 0);
  popMatrix();
}


void drawSerialData() {
  pushMatrix();
  translate(20, 650);
  fill(blue);
  stroke(blue);
  strokeWeight(1);
  textSize(13);
  text("ID", 0, 0);
  text("Time", 50, 0);
  line(90, -10, 90, 25);
  text("ax1", 100, 0);
  text("ay1", 150, 0);
  text("az1", 200, 0);
  text("gx1", 250, 0);
  text("gy1", 300, 0);
  text("gz1", 350, 0);
  line(390, -10, 390, 25);
  text("ax2", 400, 0);
  text("ay2", 450, 0);
  text("az2", 500, 0);
  text("gx2", 550, 0);
  text("gy2", 600, 0);
  text("gz2", 650, 0);
  line(690, -10, 690, 25);
  text("f1", 700, 0);
  text("f2", 720, 0);
  text("f3", 740, 0);
  text("f4", 760, 0);
  line(800, -10, 800, 25);
  text("mu", 810, 0);
  text("angle", 860, 0);

  translate(0, 25);
  fill(deepBlue);
  text(id, 0, 0);
  text(time, 50, 0);
  text(ax1, 100, 0);
  text(ay1, 150, 0);
  text(az1, 200, 0);
  text(gx1, 250, 0);
  text(gy1, 300, 0);
  text(gz1, 350, 0);
  text(ax2, 400, 0);
  text(ay2, 450, 0);
  text(az2, 500, 0);
  text(gx2, 550, 0);
  text(gy2, 600, 0);
  text(gz2, 650, 0);
  text(f1, 700, 0);
  text(f2, 720, 0);
  text(f3, 740, 0);
  text(f4, 760, 0);
  text(motorupdate, 810, 0);
  text(angle, 860, 0);
  popMatrix();
}

void drawRollPitchYaw(float roll, float pitch, float yaw, String label, int x, int y) {
  pushMatrix();
  translate(x, y);
  strokeWeight(3);
  fill(blue);
  textSize(16);
  text(label, 0, 0);
  stroke(200, 200, 200);
  line(0, 100, 160, 100);
  line(80, 20, 80, 180);
  stroke(deepBlue);
  fill(cyan);
  ellipse(map(yaw, 90, -90, 80, -80)+80, map(pitch, 90, -90, 80, -80)+100, 20, 20);
  strokeWeight(8);
  noFill();
  float rollR = -radians(roll); 
  if (rollR < 0) {
    //print(rollR);
    arc(80, 100, 180, 180, PI+HALF_PI, PI+HALF_PI-rollR);
  } else {
    arc(80, 100, 180, 180, PI+HALF_PI-rollR, PI+HALF_PI);
  }
  popMatrix();
}
