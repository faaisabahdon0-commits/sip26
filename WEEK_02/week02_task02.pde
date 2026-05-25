PImage img;
int[] redBuckets = new int[256];
int[] greenBuckets = new int[256];
int[] blueBuckets = new int[256];

void setup() {
  size(600, 750);
  pixelDensity(1);
  img = loadImage("histogram/data/Michael_cover.jpeg");
  img.resize(600, 600);
  
  img.loadPixels();
  for (int i = 0; i < img.pixels.length; i++) {
    color c = img.pixels[i];
    int r = int(red(c));
    int g = int(green(c));
    int b = int(blue(c));
    
    redBuckets[r]++;
    greenBuckets[g]++;
    blueBuckets[b]++;
  }
}

void draw() {
  background(15);
  image(img, 0, 0);
  
  int maxR = 0;
  int maxG = 0;
  int maxB = 0;
  
  for (int i = 0; i < 256; i++) {
    if (redBuckets[i] > maxR) maxR = redBuckets[i];
    if (greenBuckets[i] > maxG) maxG = greenBuckets[i];
    if (blueBuckets[i] > maxB) maxB = blueBuckets[i];
  }
  
  int graphHeight = 110;
  int bottomLine = height - 20;
  
  for (int i = 0; i < 256; i++) {
    float xPos = map(i, 0, 255, 30, width - 30);
    
    float rBarHeight = map(redBuckets[i], 0, maxR, 0, graphHeight);
    float gBarHeight = map(greenBuckets[i], 0, maxG, 0, graphHeight);
    float bBarHeight = map(blueBuckets[i], 0, maxB, 0, graphHeight);
    
    strokeWeight(1.5);
    
    stroke(255, 50, 50, 130);
    line(xPos, bottomLine, xPos, bottomLine - rBarHeight);
    
    stroke(50, 255, 50, 130);
    line(xPos, bottomLine, xPos, bottomLine - gBarHeight);
    
    stroke(50, 100, 255, 130);
    line(xPos, bottomLine, xPos, bottomLine - bBarHeight);
  }
}