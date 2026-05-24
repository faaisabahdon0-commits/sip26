void setup() {
  size(400, 300);
  pixelDensity(1);
}

void draw() {
  loadPixels();
  
  float centerX = width / 2.0;
  float centerY = height / 2.0;
  float maxDist = dist(0, 0, centerX, centerY); // Maximum edge boundary span

  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      float currentDist = dist(x, y, centerX, centerY);
      float normalizedDist = map(currentDist, 0, maxDist, 0, 1);
      
      
      int red = int(map(normalizedDist, 0, 1, 255, 50));
      int green = int(map(normalizedDist, 0, 1, 210, 15));
      int blue = int(map(normalizedDist, 0, 1, 40, 60));
      
      pixels[x + y * width] = color(red, green, blue);
    }
  }
  updatePixels();
}