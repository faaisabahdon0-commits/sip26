PImage img;
int[] redBuckets = new int[256];
int[] greenBuckets = new int[256];
int[] blueBuckets = new int[256];

void setup() {
  size(600, 750);
  pixelDensity(1);
  img = loadImage("data/michael_cover.jpeg");
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
  int graphTop = bottomLine - graphHeight;

  noFill();
  stroke(255, 255, 255, 80);
  line(30, graphTop, width - 30, graphTop);

  for (int i = 0; i < 256; i++) {
    float xPos = map(i, 0, 255, 30, width - 30);

    float rBarHeight = map(redBuckets[i], 0, maxR, 0, graphHeight);
    float gBarHeight = map(greenBuckets[i], 0, maxG, 0, graphHeight);
    float bBarHeight = map(blueBuckets[i], 0, maxB, 0, graphHeight);

    strokeWeight(2);

    stroke(255, 60, 60, 180);
    line(xPos, bottomLine, xPos, bottomLine - rBarHeight);

    stroke(60, 255, 90, 180);
    line(xPos, bottomLine, xPos, bottomLine - gBarHeight);

    stroke(70, 140, 255, 180);
    line(xPos, bottomLine, xPos, bottomLine - bBarHeight);
  }
}
