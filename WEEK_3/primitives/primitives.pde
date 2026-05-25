void setup() {
  size(640, 360);
  rectMode(CENTER);
}

void draw() {
  background(240, 240, 245);

  fill(160, 32, 240);
  noStroke();
  ellipse(160, height/2, 130, 90);

  fill(255, 127, 0);
  noStroke();
  pushMatrix();
    translate(width/2, height/2);
    rotate(QUARTER_PI);
    rect(0, 0, 85, 85);
  popMatrix();

  fill(0, 200, 115);
  noStroke();
  arc(480, height/2, 110, 110, 0, PI + HALF_PI);
}