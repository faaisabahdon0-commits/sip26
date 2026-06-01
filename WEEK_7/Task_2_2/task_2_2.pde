import processing.video.*;
import processing.sound.*; // Core audio library for files, oscillators, and filters

Capture cam;
PImage pictureRihanna;   // Static image container for Rihanna

// ==========================================
// WEEK 7: AUDIO ENVIRONMENT (3 Oscillators + 1 Audio File + 1 Filter)
// ==========================================
SoundFile planetaryTrack; // Ambient background audio track (week7sound.wav)
SinOsc baseDrone;         // Oscillator 1: Space ship ambient engine rumble
SawOsc telemetryLead;     // Oscillator 2: Frequency Modulated (FM) signal
Pulse radarEcho;          // Oscillator 3: Onboarding scanner system pings
LowPass atmosphereBox;    // Filter: Sweeps frequency channels over the audio space

Waveform audioWave;       // Analysis: Tracks live amplitude data shapes
int soundSamples = 256;

int savedCount = 0;
int maxFrames = 10;
int currentVersion = 1; 

int PANEL_W = 640;
int PANEL_H = 480;

// Week 4 Convolution Matrices
float[][] smooth = {{1/9.0, 1/9.0, 1/9.0},{1/9.0, 1/9.0, 1/9.0},{1/9.0, 1/9.0, 1/9.0}};
float[][] sharpen = {{0, -1, 0},{-1, 5, -1},{0, -1, 0}};
float[][] edge = {{-1, -1, -1},{-1, 8, -1},{-1, -1, -1}};

void setup() {
  // Reset window size for 2 panels side-by-side (1280x480)
  size(1280, 480); 

  // 1. Initialize Video Capture Feed
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("No video capture devices discovered."); exit();
  } else {
    cam = new Capture(this, PANEL_W, PANEL_H, cameras[0], 30);
    cam.start();     
  }

  // 2. Load Rihanna Visual Panel Asset (Updated to load Rihanna2.jpg)
  pictureRihanna = loadImage("Rihanna2.jpg");
  pictureRihanna.resize(PANEL_W, PANEL_H);

  // -----------------------------------------------------------
  // AUDIO INITIALIZATION & ROUTING
  // -----------------------------------------------------------

  // Load and play the background audio file
  planetaryTrack = new SoundFile(this, "Sun_sound_effect2.wav");
  planetaryTrack.loop();
  planetaryTrack.amp(0.20); // Keep background track at a gentle level

  // Set up space synthesis generators
  baseDrone = new SinOsc(this);
  telemetryLead = new SawOsc(this);
  radarEcho = new Pulse(this);
  atmosphereBox = new LowPass(this);

  // Link analysis engine to watch the incoming background track frequencies
  audioWave = new Waveform(this, soundSamples);
  
  // Connect the planetary background track into our LowPass Filter
  atmosphereBox.process(planetaryTrack);
  audioWave.input(planetaryTrack);

  // Boot up the synth nodes
  baseDrone.play();
  telemetryLead.play();
  radarEcho.play();

  // Mix oscillator master levels
  baseDrone.amp(0.25);
  telemetryLead.amp(0.10);
  radarEcho.amp(0.03);
}

void draw() {
  if (cam.available() == true) {
    cam.read();
  }

  // -----------------------------------------------------------
  // AUDIO CODE: SCIFI FREQUENCY MODULATION (FM)
  // -----------------------------------------------------------
  float internalLFO = sin(frameCount * 0.05);

  // Deep planetary ground frequency rumble
  baseDrone.freq(55.0 + (sin(frameCount * 0.01) * 8.0));

  // FREQUENCY MODULATION (FM): Altering the lead frequency over time
  float baseFrequency = 220.0;
  float modulationDepth = 140.0;
  float modulatedFrequency = baseFrequency + (internalLFO * modulationDepth); 
  telemetryLead.freq(modulatedFrequency);

  // Modulate our LowPass Filter cutoff points automatically
  float filterSweep = map(cos(frameCount * 0.02), -1, 1, 400, 2800);
  atmosphereBox.freq(filterSweep);

  // High-frequency cockpit tracking radar alerts
  radarEcho.freq(950.0 + (sin(frameCount * 0.12) * 250.0));

  // -----------------------------------------------------------
  // AUDIO-TO-VIDEO PARAMETER MAPPING
  // -----------------------------------------------------------
  audioWave.analyze(); 
  float realTimeAudioSample = 0.0;
  if (audioWave.data.length > 0) {
    realTimeAudioSample = audioWave.data[0]; // Poll live amplitude (-1.0 to 1.0)
  }

  // Cross-link audio data straight into your visual dither thresholds
  float audioDrivenThreshold = map(realTimeAudioSample, -1.0, 1.0, 90.0, 165.0);

  // -----------------------------------------------------------
  // VARIATION CONFIGURATIONS
  // -----------------------------------------------------------
  float[][] currentKernel = edge; 
  String currentDitherMethod = "floyd"; 

  if (currentVersion == 1) {
    currentKernel = edge; currentDitherMethod = "floyd";
  } else if (currentVersion == 2) {
    currentKernel = sharpen; currentDitherMethod = "atkinson";
  } else if (currentVersion == 3) {
    currentKernel = smooth; currentDitherMethod = "simple";
  }
  
  // PANEL 1: Render Live WebCam Feed (Left-hand frame)
  PImage ditheredLiveCam = processImagePipeline(cam, currentKernel, currentDitherMethod, audioDrivenThreshold);
  image(ditheredLiveCam, 0, 0);
  
  // PANEL 2: Render Static Target - Rihanna (Right-hand frame)
  PImage ditheredRihanna = processImagePipeline(pictureRihanna, currentKernel, currentDitherMethod, audioDrivenThreshold);
  image(ditheredRihanna, PANEL_W, 0);

  // Final cosmetic borders and control dashboard readouts
  drawComicStripFrames();
  drawUI(audioDrivenThreshold, modulatedFrequency, filterSweep);
}

// ======================================================================
// PROCESSING PIPELINE CORE
// ======================================================================
PImage processImagePipeline(PImage src, float[][] kernel, String ditherMethod, float dynamicThreshold) {
  PImage convolvedOutput = convolveToNewBuffer(src, kernel);
  PImage fullyProcessed = ditherImageLoop(convolvedOutput, ditherMethod, dynamicThreshold);
  return fullyProcessed;
}

PImage convolveToNewBuffer(PImage input, float[][] kernel) {
  PImage output = createImage(input.width, input.height, RGB);
  input.loadPixels(); output.loadPixels();

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
      int index = y * input.width + x;
      output.pixels[index] = color(constrain(sumR,0,255), constrain(sumG,0,255), constrain(sumB,0,255));
    }
  }
  output.updatePixels(); return output;
}

PImage ditherImageLoop(PImage buffer, String ditherMethod, float dynamicThreshold) {
  PImage processed = buffer.get(); 
  processed.loadPixels();
  
  for (int i = 0; i < processed.pixels.length; i++) {
    float greyValue = red(processed.pixels[i]);
    
    float newPixelValue = (greyValue > dynamicThreshold) ? 255 : 0;
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
  processed.updatePixels(); return processed;
}

// Error Diffusion Math Formulas
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

// 2-Panel Comic Frame Layout Framework Outline
void drawComicStripFrames() {
  noFill(); stroke(0); strokeWeight(24);
  rect(0, 0, width, height); 
  line(PANEL_W, 0, PANEL_W, height); 
  
  stroke(255); strokeWeight(4);
  rect(12, 12, width-24, height-24);
  line(PANEL_W, 12, PANEL_W, height-12);
}

void drawUI(float thresh, float liveFreq, float liveFilter) {
  fill(0, 200); noStroke();
  rect(24, height - 102, 550, 85);
  
  fill(255); textSize(12);
  text("SYSTEM DIAGNOSTIC: SCI-FI DESCENT INTERFACE STAGE RUNNING", 34, height - 84);
  text("Looping Environment Broadcast: week7sound.wav [Sound File Engaged]", 34, height - 68);
  text("Internal Synth Telemetry (FM Lead): " + nf(liveFreq, 3, 1) + " Hz | Filter Cutoff: " + nf(liveFilter, 4, 1) + " Hz", 34, height - 52);
  text("Audio-Driven Cross-Linked Threshold: " + nf(thresh, 2, 1) + " [Webcam + Rihanna Synchronized]", 34, height - 36);
  text("Keys [1, 2, 3] Change Visual Matrix Filters | [S] Capture Portfolio Reel Frame (" + savedCount + "/10)", 34, height - 20);
}

void keyPressed() {
  if (key == '1') currentVersion = 1;
  if (key == '2') currentVersion = 2;
  if (key == '3') currentVersion = 3;

  if (key == 's' || key == 'S') {
    if (savedCount < maxFrames) {
      saveFrame("portfolio/scifi_dual_v" + currentVersion + "_panel_" + savedCount + ".jpg");
      println("Captured interactive panel configuration to portfolio folder.");
      savedCount++;
    }
  }
}