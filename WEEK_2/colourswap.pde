PImage img;

void setup() {
  size(600, 600);
  pixelDensity(1);
  
  img = loadImage("beyonce_cover.jpeg");
  img.resize(600, 600);
  
  img.loadPixels();
  for (int i = 0; i < img.pixels.length; i++) {
    color c = img.pixels[i];
    float r = red(c);
    float g = green(c);
    float b = blue(c);
    
    img.pixels[i] = color(g, r, b);
  }
  img.updatePixels();
}

void draw() {
  background(0);
  image(img, 0, 0);
}