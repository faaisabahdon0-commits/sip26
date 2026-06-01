void setup() {
  size(400, 300);
  pixelDensity(1);
}

void draw() {
  loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      
      float diagonalValue = (float)x / width + (float)y / height; 
      float normalizedDiag = map(diagonalValue, 0, 2, 0, 1);
      
    
      int red = int(map(normalizedDiag, 0, 1, 0, 140));
      int green = int(map(normalizedDiag, 0, 1, 200, 10));
      int blue = int(map(normalizedDiag, 0, 1, 180, 40));
      
      pixels[x + y * width] = color(red, green, blue);
    }
  }
  updatePixels();
}
