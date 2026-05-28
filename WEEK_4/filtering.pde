PImage picture;

color colorA;
color colorB;

void setup() {
  size(517, 606);
  background(0);
  picture = loadImage("Brandy.jpeg");
  
  colorA = color(2, 65, 166);
  colorB = color(250, 182, 47);
}

void draw() {
  image(picture, 0, 0);

  loadPixels();
  for (int i = 0; i < pixels.length; i++) {
    pixels[i] = duotone(pixels[i], colorA, colorB);
  }
  updatePixels();
}

color threshold(color pixel, int threshold) {
   if (red(pixel) > threshold) {
     return color(255);
   } else {
     return color(0);
   }
}  

color duotone(color pixel, color colorA, color colorB) {
  float tone = red(pixel);
  float lerpAmount = norm(tone, 0, 255);
  return lerpColor(colorA, colorB, lerpAmount);
}

color sepia(color pixel) {
  float r = red(pixel);
  float g = green(pixel);
  float b = blue(pixel);
  
  float outputRed = (r * .393) + (g *.769) + (b * .189);
  float outputGreen = (r * .349) + (g *.686) + (b * .168);
  float outputBlue = (r * .272) + (g *.534) + (b * .131);
  
  return color(outputRed, outputGreen, outputBlue);
}

color contrast(color pixel, float contrastAmount) {
  float r = red(pixel);
  float g = green(pixel);
  float b = blue(pixel);

  float contrastFactor = (259*(contrastAmount+255)) / (255* (259-contrastAmount));

  r = (contrastFactor * (r -128)) + 128;
  g = (contrastFactor * (g -128)) + 128;
  b = (contrastFactor * (b -128)) + 128;

  return color(r, g, b);
}

color brighten(color pixel, float brightness) {
  float r = red(pixel);
  float g = green(pixel);
  float b = blue(pixel);

  r = r + brightness;
  g = g + brightness;
  b = b + brightness;

  return color(r, g, b);
}

color invert(color pixel) {
  float r = red(pixel);
  float g = green(pixel);
  float b = blue(pixel);

  r = 255-r;
  g = 255-g;
  b = 255-b;

  return color(r, g, b);
}