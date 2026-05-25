float angleOne = 0;
float angleTwo = 0;
float angleThree = 0;

float xpos = 100;
float xstep = 100;

void setup() {
  size(400, 400);
}

void draw() {
  background(20, 15, 30);
  
  pushMatrix();
    fill(255, 90, 95);
    noStroke();
    translate(xpos + (xstep * 0), height/2);
    rotate(radians(angleOne));
    triangle(-30, 20, 30, 20, 0, -35);
    angleOne = angleOne + 1.5;
  popMatrix();
  
  pushMatrix();
    fill(0, 210, 255);
    noStroke();
    translate(xpos + (xstep * 1), height/2);
    rotate(radians(angleTwo));
    quad(0, -30, 25, 0, 0, 30, -25, 0);
    angleTwo = angleTwo - 2.0;
  popMatrix();

  pushMatrix();
    fill(255, 210, 60);
    noStroke();
    translate(xpos + (xstep * 2), height/2);
    rotate(radians(angleThree));
    rectMode(CENTER);
    rect(0, 0, 45, 45);
    angleThree = angleThree + 1.0;
  popMatrix();
}