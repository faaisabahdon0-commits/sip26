void setup() {
  size(600, 400);
  noLoop();
}

void draw() {
  for (int y = 0; y < height; y++) {
    float inter = map(y, 0, height, 0, 1);
    color c1 = color(0, 102, 204);
    color c2 = color(255, 204, 0);
    color gradientColor = lerpColor(c1, c2, inter);
    stroke(gradientColor);
    line(0, y, width, y);
  }
}
