void setup() {
  size(400, 300);
  pixelDensity(1);
}

void draw() {
  loadPixels();

  for (int x = 0; x < width; x++) {
    float normalizedX = map(x, 0, width - 1, 0, 1);
    float curve = pow(normalizedX, 1.8);
    int red = int(map(curve, 0, 1, 255, 140));
    int green = int(map(curve, 0, 1, 255, 30));
    int blue = int(map(curve, 0, 1, 255, 30));

    for (int y = 0; y < height; y++) {
      pixels[x + y * width] = color(red, green, blue);
    }
  }

  updatePixels();
}
