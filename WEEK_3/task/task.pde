float angle = 0;

void setup() {
  size(700, 700);
  rectMode(CENTER);
  smooth(); 
}

void draw() {
  blendMode(BLEND);
  background(15);
  
  blendMode(DIFFERENCE);
  noStroke();
  
  int layers = 12;
  float scaleFactor = 40;
  
  for (int i = 0; i < layers; i++) {
    pushMatrix();
    
    translate(width / 2, height / 2);
    rotate(radians(angle * (i + 1) * 0.15));
    
    if (i % 3 == 0) {
      fill(255, 65, 130);
    } else if (i % 3 == 1) {
      fill(0, 180, 255);
    } else {
      fill(255, 210, 0);
    }
    
    float currentSize = 80 + (i * scaleFactor);
    
    if (i % 3 == 0) {
      rect(0, 0, currentSize, currentSize);
    } else if (i % 3 == 1) {
      ellipse(0, 0, currentSize * 1.1, currentSize * 1.1);
    } else {
      float halfSize = currentSize / 2.0;
      triangle(-halfSize, halfSize, halfSize, halfSize, 0, -halfSize);
    }
    
    popMatrix();
  }
  
  angle += 0.4; 
}