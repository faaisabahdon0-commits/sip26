float[] angles = {0, 0, 0, 0, 0};

float xpos = 60;
float xstep = 70;

void setup() {
  size(400, 400);
  rectMode(CENTER);
}

void draw() {
  background(20, 20, 35);
  
  for(int i = 0; i < angles.length; i++) {
    pushMatrix();
    translate(xpos + (xstep * i), height/2);
    rotate(radians(angles[i]));
    noStroke();
    
    // Modulo alternates shapes and colors down the line
    if (i % 3 == 0) {
      fill(255, 90, 95); // Coral Pink
      // Draw a diamond shape using a quad
      quad(0, -30, 22, 0, 0, 30, -22, 0);
    } 
    else if (i % 3 == 1) {
      fill(0, 210, 255); // Electric Blue
      // Draw a star/cross using two thin rectangles
      rect(0, 0, 45, 12);
      rect(0, 0, 12, 45);
    } 
    else {
      fill(255, 210, 60); // Bright Yellow
      // Draw a classic triangle
      triangle(-25, 20, 25, 20, 0, -25);
    }
    
    // Each shape rotates at a different speed based on its index
    angles[i] = angles[i] + (0.8 * (i + 1));
    popMatrix();
  }
}