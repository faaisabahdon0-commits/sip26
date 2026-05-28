float zOffset = 0;

void setup() {
  size(600, 600);
}

void draw() {
  loadPixels();
  
  float noiseScale = map(mouseX, 0, width, 0.005, 0.05);
  float speed = map(mouseY, 0, height, 0.01, 0.08);
  
  for (int i = 0; i < pixels.length; i++) {
    int x = i % width;
    int y = i / width;
    
    float n = noise(x * noiseScale, y * noiseScale, zOffset);
    
    float r = map(sin(n * TWO_PI), -1, 1, 0, 255);
    float g = map(cos(n * HALF_PI), -1, 1, 0, 255);
    float b = map(n, 0, 1, 150, 255);
    
    if (n > 0.45 && n < 0.55) {
      pixels[i] = color(255, 255, 255);
    } else {
      pixels[i] = color(r, g, b);
    }
  }
  
  updatePixels();
  zOffset += speed;
}