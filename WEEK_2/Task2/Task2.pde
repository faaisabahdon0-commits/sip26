PImage img;

public void settings() {
  size(736, 736);
}

void setup() {
  img = loadImage("data/beyonce_cover.jpeg");
  img.loadPixels();
  noLoop();
}

void draw() {
  image(img, 0, 0);
  loadPixels();

  glitchSort();
  addGlitchBands();
  addChannelOffset();

  updatePixels();
}

void glitchSort() {
  for (int y = 0; y < height; y++) {
    int x = 0;
    while (x < width) {
      if (isRedDominant(pixels[x + y * width])) {
        int startX = x;
        while (x < width && isRedDominant(pixels[x + y * width])) {
          x++;
        }
        sortRowSegment(y, startX, x);
      }
      x++;
    }
  }

  for (int x = 0; x < width; x++) {
    int y = 0;
    while (y < height) {
      if (isBlueDominant(pixels[x + y * width])) {
        int startY = y;
        while (y < height && isBlueDominant(pixels[x + y * width])) {
          y++;
        }
        sortColumnSegment(x, startY, y);
      }
      y++;
    }
  }
}

void addGlitchBands() {
  color[] original = pixels.clone();
  int bandCount = 10;
  for (int i = 0; i < bandCount; i++) {
    int y = int(random(height));
    int bandHeight = int(random(5, 30));
    int shift = int(random(-50, 50));

    for (int yy = y; yy < min(height, y + bandHeight); yy++) {
      for (int x = 0; x < width; x++) {
        int sx = x + shift;
        if (sx < 0) sx += width;
        if (sx >= width) sx -= width;
        pixels[x + yy * width] = original[sx + yy * width];
      }
    }
  }
}

void addChannelOffset() {
  color[] original = pixels.clone();
  int offset = 4;
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      int idx = x + y * width;
      if ((x + y) % 20 < 6) {
        int rIdx = constrain(idx + offset, 0, pixels.length - 1);
        int gIdx = constrain(idx - offset, 0, pixels.length - 1);
        int bIdx = constrain(idx + offset * width, 0, pixels.length - 1);
        float r = red(original[rIdx]);
        float g = green(original[gIdx]);
        float b = blue(original[bIdx]);
        pixels[idx] = color(r, g, b);
      }
    }
  }
}

boolean isRedDominant(color c) {
  float r = red(c);
  float g = green(c);
  float b = blue(c);
  return (r > g && r > b && r > 100);
}

boolean isBlueDominant(color c) {
  float r = red(c);
  float g = green(c);
  float b = blue(c);
  return (b > r && b > g && b > 90);
}

void sortRowSegment(int y, int startX, int endX) {
  int len = max(0, endX - startX);
  if (len < 2) return;

  color[] segment = new color[len];
  for (int i = 0; i < len; i++) {
    segment[i] = pixels[(startX + i) + y * width];
  }

  for (int i = 0; i < segment.length - 1; i++) {
    for (int j = i + 1; j < segment.length; j++) {
      if (brightness(segment[i]) > brightness(segment[j])) {
        color temp = segment[i];
        segment[i] = segment[j];
        segment[j] = temp;
      }
    }
  }

  for (int i = 0; i < len; i++) {
    pixels[(startX + i) + y * width] = segment[i];
  }
}

void sortColumnSegment(int x, int startY, int endY) {
  int len = max(0, endY - startY);
  if (len < 2) return;

  color[] segment = new color[len];
  for (int i = 0; i < len; i++) {
    segment[i] = pixels[x + (startY + i) * width];
  }

  for (int i = 0; i < segment.length - 1; i++) {
    for (int j = i + 1; j < segment.length; j++) {
      if (saturation(segment[i]) < saturation(segment[j])) {
        color temp = segment[i];
        segment[i] = segment[j];
        segment[j] = temp;
      }
    }
  }

  for (int i = 0; i < len; i++) {
    pixels[x + (startY + i) * width] = segment[i];
  }
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    saveFrame("glitch_####.png");
    println("Saved glitch image");
  }
}
