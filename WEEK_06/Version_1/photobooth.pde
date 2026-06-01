import processing.video.*;

Capture cam;
PImage staticPicture; // Holds your uploaded Zara Larson image

int savedCount = 0;
int maxFrames = 10;
int currentVersion = 1;

// Define individual panel dimensions
int PANEL_W = 640;
int PANEL_H = 480;

// ==========================================
// WEEK 4: CONVOLUTION KERNELS
// ==========================================
float[][] identity = {{0,0,0},{0,1,0},{0,0,0}};
float[][] smooth = {{1/9.0, 1/9.0, 1/9.0},{1/9.0, 1/9.0, 1/9.0},{1/9.0, 1/9.0, 1/9.0}};
float[][] blur = {{0.0625, 0.125, 0.0625},{0.125, 0.25, 0.125},{0.0625, 0.125, 0.0625}};
float[][] sharpen = {{0, -1, 0},{-1, 5, -1},{0, -1, 0}};
float[][] edge = {{-1, -1, -1},{-1, 8, -1},{-1, -1, -1}};

void setup() {
  // Dual-panel layout window (1280x480)
  size(1280, 480); 

  // Initialize Webcam (standard 640x480)
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("No cameras detected."); 
    exit();
  } else {
    cam = new Capture(this, PANEL_W, PANEL_H, cameras[0], 30);
    cam.start();     
  }

  // Updated with the exact requested filename string
  staticPicture = loadImage("ZaraLarson.jpg");
  
  // Conform image dimensions to match the panel grid layout smoothly
  staticPicture.resize(PANEL_W, PANEL_H); 
}

void draw() {
  if (cam.available() == true) {
    cam.read();
  }
  
  float[][] currentKernel = edge; 
  String currentDitherMethod = "floyd"; 

  // -----------------------------------------------------------
  // STEP 1: DEFINE STYLES BASED ON INPUT SELECTION (Keys 1, 2, 3)
  // -----------------------------------------------------------
  if (currentVersion == 1) {
    currentKernel = edge;
    currentDitherMethod = "floyd";
  } else if (currentVersion == 2) {
    currentKernel = sharpen;
    currentDitherMethod = "atkinson";
  } else if (currentVersion == 3) {
    currentKernel = blur;
    currentDitherMethod = "simple";
  }
  
  // -----------------------------------------------------------
  // STEP 2: PROCESS AND DRAW PANEL 1 (LIVE WEBCAM - LEFT SIDE)
  // -----------------------------------------------------------
  PImage ditheredLiveCam = processImagePipeline(cam, currentKernel, currentDitherMethod);
  image(ditheredLiveCam, 0, 0);
  
  // -----------------------------------------------------------
  // STEP 3: PROCESS AND DRAW PANEL 2 (STATIC IMAGE - RIGHT SIDE)
  // -----------------------------------------------------------
  PImage ditheredStaticPic = processImagePipeline(staticPicture, currentKernel, currentDitherMethod);
  image(ditheredStaticPic, PANEL_W, 0);

  // -----------------------------------------------------------
  // COSMETIC OVERLAY: Comic Strip Borders and Frames
  // -----------------------------------------------------------
  drawComicStripFrames();
  drawUI();
}

// ======================================================================
// MAIN RENDER ENGINE: Filter + Greyscale Pass + Error Diffusion Dither
// ======================================================================
PImage processImagePipeline(PImage src, float[][] kernel, String ditherMethod) {
  PImage convolvedOutput = convolveToNewBuffer(src, kernel);
  PImage fullyProcessed = ditherImageLoop(convolvedOutput, ditherMethod);
  return fullyProcessed;
}

// ==========================================
// CONVOLUTION SUB-ROUTINE
// ==========================================
PImage convolveToNewBuffer(PImage input, float[][] kernel) {
  PImage output = createImage(input.width, input.height, RGB);
  input.loadPixels();
  output.loadPixels();

  for (int y = 1; y < input.height-1; y++) {
    for (int x = 1; x < input.width-1; x++) {
      float sumR = 0; float sumG = 0; float sumB = 0;

      for (int offsetY = -1; offsetY <= 1; offsetY++) {
        for (int offsetX= -1; offsetX <= 1; offsetX++) {
          int neighbourIndex = (y + offsetY) * input.width + (x + offsetX);
          
          sumR += red(input.pixels[neighbourIndex]) * kernel[offsetY+1][offsetX+1];
          sumG += green(input.pixels[neighbourIndex]) * kernel[offsetY+1][offsetX+1];
          sumB += blue(input.pixels[neighbourIndex]) * kernel[offsetY+1][offsetX+1];
        }
      }
      sumR = constrain(sumR, 0, 255);
      sumG = constrain(sumG, 0, 255);
      sumB = constrain(sumB, 0, 255);
      
      int index = y * input.width + x;
      output.pixels[index] = color(sumR, sumG, sumB);
    }
  }
  output.updatePixels();
  return output;
}

// ==========================================
// DITHER SUB-ROUTINE
// ==========================================
PImage ditherImageLoop(PImage buffer, String ditherMethod) {
  PImage processed = buffer.get(); 
  processed.loadPixels();
  
  for (int i = 0; i < processed.pixels.length; i++) {
    float greyValue = red(processed.pixels[i]);
    float newPixelValue = (greyValue > 127) ? 255 : 0;
    float error = greyValue - newPixelValue;
    
    processed.pixels[i] = color(newPixelValue);

    if (ditherMethod.equals("floyd")) {
      fsDither(processed, i, error);
    } else if (ditherMethod.equals("atkinson")) {
      atkinsonDither(processed, i, error);
    } else if (ditherMethod.equals("simple")) {
      diffuseError(processed, i, error);
    }
  }
  
  processed.updatePixels();
  return processed;
}

// ==========================================
// DITHER ARRAY MANIPULATION PATTERNS
// ==========================================
void diffuseError(PImage img, int i, float error) {
  if (i < img.pixels.length-1) {
    float nextGreyValue = red(img.pixels[i+1]);
    img.pixels[i+1] = color(nextGreyValue + error);
  }
}

void fsDither(PImage img, int i, float error) {
  int[] offsets = { 1, img.width-1, img.width, img.width+1 };
  float[] ditherRatios = { 7/16.0, 3/16.0, 5/16.0, 1/16.0 };

  for (int j = 0; j < offsets.length; j++) {
    int neighbourIndex = i + offsets[j];
    if (neighbourIndex < img.pixels.length) {
      float neighbourGrey = red(img.pixels[neighbourIndex]);
      img.pixels[neighbourIndex] = color(neighbourGrey + (error*ditherRatios[j]));
    }
  }
}

void atkinsonDither(PImage img, int i, float error) {
  int[] offsets = { 1, 2, img.width-1, img.width, img.width+1, img.width*2 };

  for (int j = 0; j < offsets.length; j++) {
    int neighbourIndex = i + offsets[j];
    if (neighbourIndex < img.pixels.length) {
      float neighbourGrey = red(img.pixels[neighbourIndex]);
      img.pixels[neighbourIndex] = color(neighbourGrey + (error/8.0));
    }
  }
}

// ==========================================
// OPTIONAL EXTRA: DRAW COMIC STRIP FRAMES
// ==========================================
void drawComicStripFrames() {
  noFill();
  stroke(0);        
  strokeWeight(24);
  rect(0, 0, width, height);
  line(PANEL_W, 0, PANEL_W, height); // Central comic layout gutter
  
  stroke(255);      
  strokeWeight(4);
  rect(12, 12, width-24, height-24);
  line(PANEL_W, 12, PANEL_W, height-12);
}

// ==========================================
// PANEL DISPLAY TEXT OVERLAY
// ==========================================
void drawUI() {
  fill(0, 180); 
  noStroke();
  rect(20, height - 65, 330, 48);
  
  fill(255);
  textSize(14);
  text("Active Setup Style Variant: " + currentVersion, 30, height - 48);
  text("Press [1, 2, 3] to Change | [S] to Save (" + savedCount + "/10)", 30, height - 28);
}

// ==========================================
// INTERACTIVE RUNTIME INPUT CONTROLS
// ==========================================
void keyPressed() {
  if (key == '1') currentVersion = 1;
  if (key == '2') currentVersion = 2;
  if (key == '3') currentVersion = 3;

  if (key == 's' || key == 'S') {
    if (savedCount < maxFrames) {
      saveFrame("portfolio/story_v" + currentVersion + "_reel_" + savedCount + ".jpg");
      println("Captured dual-panel strip configuration saved to portfolio folder.");
      savedCount++;
    } else {
      println("Comic reel limit reached! You have already exported 10 snapshots.");
    }
  }
}