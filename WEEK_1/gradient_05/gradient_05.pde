// WEEK 1: VARIATION 3 (Diagonal Slant)
void setup() {
  size(400, 300);
  pixelDensity(1);
}

void draw() {
  loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      // Combining x and y together maps values along a diagonal vector
      float diagonalValue = (float)x / width + (float)y / height; 
      float normalizedDiag = map(diagonalValue, 0, 2, 0, 1); // Max combined value is 2
      
      // Palette: Tech Teal (0, 200, 180) to Velvet Red (140, 10, 40)
      int red = int(map(normalizedDiag, 0, 1, 0, 140));
      int green = int(map(normalizedDiag, 0, 1, 200, 10));
      int blue = int(map(normalizedDiag, 0, 1, 180, 40));
      
      pixels[x + y * width] = color(red, green, blue);
    }
  }
  updatePixels();
}