import processing.sound.*;

// Defining the 4 required sound samples
SoundFile kick;
SoundFile wood;
SoundFile glass;
SoundFile hihat; 

// --- TEMPO CONTROL ---
// Cranked up to 158 BPM for a much faster, high-energy pace!
float bpm = 158; 
float myFrameRate = (bpm / 60) * 4; // Each frame remains a 16th note step

// Visual feedback variables
float kickScale = 1.0;
float woodY = 0;
float glassVisualSize = 0;

void setup() {
  size(640, 360);
  frameRate(myFrameRate);
  
  // Cleaned paths: Processing automatically looks inside your 'data' folder!
  kick  = new SoundFile(this, "sample_kick_w_echo.wav");
  wood  = new SoundFile(this, "samples_Clicky_wood.wav");
  glass = new SoundFile(this, "sample_plucked_glass.wav");
  hihat = new SoundFile(this, "sample_hihat.wav"); 
}

void draw() {
  // Static light pink background
  background(255, 204, 213);
  
  // 16-step loop using the modulo operator (%)
  int step = frameCount % 16;
  int currentBar = frameCount / 16;

  // 1. KICK DRUM (sample_kick_w_echo.wav)
  if (step == 0 || step == 6 || step == 8 || step == 11) {
    kick.play();
    kickScale = 1.6; 
  }

  // 2. WOOD BLOCK / SNARE (samples_Clicky_wood.wav)
  if (step == 4 || step == 12) {
    wood.play();
    woodY = random(-20, 20); // Screen shake effect
  }

  // 3. PLUCKED GLASS (sample_plucked_glass.wav) WITH TIME ALTERNATION
  if (currentBar % 2 == 0) {
    if (step == 2 || step == 10) {
      glass.play();
      glassVisualSize = 100;
    }
  } else {
    if (step == 3 || step == 14) {
      glass.play();
      glassVisualSize = 130;
    }
  }

  // 4. HI-HAT (sample_hihat.wav) WITH ELEMENT OF RANDOMNESS
  if (step % 2 == 0) {
    hihat.amp(random(0.3, 0.6)); // Randomize volume for human feel
    hihat.play();
  } else {
    if (random(1) < 0.25) { // 25% chance of a rapid trap stutter
      hihat.amp(random(0.2, 0.4));
      hihat.play();
    }
  }

  // --- AUDIO-REACTIVE VISUALIZATION ---
  drawVisuals();
}

void drawVisuals() {
  pushMatrix();
  translate(width / 2, height / 2 + woodY);
  
  // 1. Kick Visual (Red Diamond)
  stroke(255, 50, 50);
  strokeWeight(4);
  noFill();
  rectMode(CENTER);
  pushMatrix();
  rotate(QUARTER_PI);
  rect(0, 0, 100 * kickScale, 100 * kickScale);
  popMatrix();
  
  // 2. Glass Visual (Cyan Expanding Circle)
  stroke(0, 180, 220); 
  ellipse(0, 0, glassVisualSize, glassVisualSize);
  
  popMatrix();
  
  // Smoothly shrink visual values back down frame-by-frame
  kickScale = lerp(kickScale, 1.0, 0.2);
  woodY = lerp(woodY, 0, 0.2);
  glassVisualSize = lerp(glassVisualSize, 0, 0.15);
  
  // Text UI
  fill(80, 40, 50); // Dark berry text color
  textAlign(CENTER, CENTER);
  textSize(20);
  int currentStepDisplay = (frameCount % 16) + 1;
  text("Step: " + currentStepDisplay + " | Bar: " + (frameCount / 16), width / 2, height - 40);
}