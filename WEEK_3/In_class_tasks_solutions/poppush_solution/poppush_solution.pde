float[] angles = {0, 0, 0, 0, 0};

float xpos = 80;
float xstep = 60;

void setup() {
  size(400, 400);
  rectMode(CENTER);
}

void draw() {
  background(20, 20, 25);
  
  for(int i = 0; i < angles.length; i++) {
    pushMatrix();
    translate(xpos + (xstep * i), height/2);
    rotate(radians(angles[i]));
    noStroke();
    
    
    if (i % 3 == 0) {
      fill(255, 90, 95);    
    } else if (i % 3 == 1) {
      fill(255, 90, 95);   
    } else {
      fill(255, 210, 60);   
    }
    
    rect(0, 0, 50, 50); 
    
    angles[i] = angles[i] + (0.5 * (i + 1));
    popMatrix();
  }
}