float angleOne = 0;
float angleTwo = 0;
float[] angles = {0, 0, 0, 0, 0}; 


color[] colours = {
  color(255, 0, 127),   
  color(0, 255, 255),  
  color(255, 255, 0),  
  color(255, 102, 0),   
  color(127, 0, 255)    
};

float xpos = 80;
float xstep = 60;

void setup() {
  size(400, 400);
}

void draw() {
  background(15, 15, 20); 
  
  for(int i = 0; i < angles.length; i++) {
    pushMatrix();
    fill(colours[i]);
    noStroke();
    translate(xpos + (xstep * i), height/2);
    rotate(radians(angles[i]));
    
 
    drawHeart(0, 0, 45); 
    
    angles[i] = angles[i] + (0.5 * (i + 1));
    popMatrix();
  }
}


void drawHeart(float x, float y, float size) {
  beginShape();
 
  vertex(x, y + size / 2);
  bezierVertex(x - size / 2, y - size / 4, x - size / 2, y - size, x, y - size / 3);
  bezierVertex(x + size / 2, y - size, x + size / 2, y - size / 4, x, y + size / 2);
  endShape(CLOSE);
}