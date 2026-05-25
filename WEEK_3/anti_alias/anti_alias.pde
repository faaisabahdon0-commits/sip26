float angle = 0;

void setup() {
  size(800, 800);
  rectMode(CENTER);
  smooth();
}

void draw() {
  background(255);
  blendMode(DIFFERENCE);
  
  int steps = 5;
  int spacing = width / steps;
  int counter = 0;
  
  for (int x = spacing / 2; x < width; x += spacing) {
    for (int y = spacing / 2; y < height; y += spacing) {
      
      pushMatrix();
      translate(x, y);
      
      if (counter % 2 == 0) {
        rotate(radians(angle));
      } else {
        rotate(radians(-angle));
      }
      
      if (counter % 3 == 0) {
        fill(255);
        stroke(255);
        rect(0, 0, 110, 110);
      } else if (counter % 3 == 1) {
        fill(255);
        noStroke();
        ellipse(0, 0, 120, 120);
      } else {
        fill(255);
        noStroke();
        triangle(-60, 50, 60, 50, 0, -60);
      }
      
      popMatrix();
      counter++;
    }
  }
  
  angle += 0.5;
}