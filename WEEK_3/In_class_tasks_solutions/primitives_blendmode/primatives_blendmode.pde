void setup() {
  size(640, 360);
  rectMode(CENTER);
  blendMode(DIFFERENCE);
}

void draw() {
  background(0);

  fill(255);
  noStroke();

  rect(width/2 + 80, height/2, 100, 100);

  circle(width/2 - 80, height/2, 100);

  triangle(
    width/2, height/2 + 50, 
    width/2 - 100, height/2 + 50, 
    width/2 - 50, height/2 - 50
  );
}