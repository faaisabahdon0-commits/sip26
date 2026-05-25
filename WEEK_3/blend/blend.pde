void setup() {
  size(400, 400);
  blendMode(BLEND);
  rectMode(CENTER);
  background(20, 10, 30);
  
  noStroke();
  blendMode(DIFFERENCE);
  
  fill(255, 100, 50);
  ellipse(width/2, height/2, 120, 120);
  
  pushMatrix();
    translate((width/2)+25, (height/2)-125);
    fill(50, 255, 150);
    drawTriangle();
  popMatrix();
  
  fill(200, 50, 255);
  rect((width/2)-25, (height/2)+25, 100, 100);
}

void drawTriangle() {
  triangle(
    0, 100,
    100, 100,
    50, 0
  );
}