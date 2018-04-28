




void mousePressed() {
  switch(sysState) {
  case INIT:
    checkInitButton();
    break;
  case SHOWDATA:
    checkShowDataButton();
    break;
  case TOUCHFINGER:
    checkTouchFingerButton();
    break;
  case SENSEANGLE:
    checkSenseAngleButton();
    break;
  }
}

class Button {
  int x, y, w, h;
  String text;
  Button(int xi, int yi, int wi, int hi, String texti) {
    x = xi;
    y = yi;
    w = wi;
    h = hi;
    text = texti;
  }
  void show() {
    //if(mouseX >= x-w/2
    pushMatrix();
    translate(x, y);
    rectMode(CENTER);
    fill(lightBlue);
    stroke(deepBlue);
    rect(0, 0, w, h, 10);
    textAlign(CENTER);
    fill(deepBlue);
    textSize(30);
    text(text, 0, 10);
    textAlign(LEFT);
    rectMode(CORNER);
    popMatrix();
  }
}

ArrayList<Button> initButtons = new ArrayList<Button>();

void initAllButton() {
   initButtons.add(new Button(500, 200, 280, 100, "RAW"));
   initButtons.add(new Button(500, 340, 280, 100, "FINGER"));
   initButtons.add(new Button(500, 480, 280, 100, "ANGLE"));
}

void drawInitButtons() {
  for ( Button btn : initButtons ) {
    btn.show();
  }
}
void checkInitButton() {
  
}




void checkShowDataButton() {
}

void checkTouchFingerButton() {
}

void checkSenseAngleButton() {
}
