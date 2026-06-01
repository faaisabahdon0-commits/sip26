import processing.sound.*; 

// Audio Assets
SoundFile planetaryTrack; // The primary background audio track (week7sound.wav)
SinOsc baseDrone;         
SawOsc telemetryLead;     
Pulse radarEcho;          
LowPass atmosphereBox;    

// Visual Assets & Analysis
PImage pictureRihanna;    
Waveform audioWave;       
int soundSamples = 256;

void setup() {
  size(1280, 720);   // Widescreen canvas
  imageMode(CENTER); // Centers the images for clean rotation and multiplication

  // 1. Load Visual Asset
  pictureRihanna = loadImage("Rihanna.jpg");
  pictureRihanna.resize(300, 300); // Scale down slightly so multiple copies fit nicely

  // 2. Load, Loop, and Set Up the Single Audio File
  planetaryTrack = new SoundFile(this, "week7sound.wav");
  planetaryTrack.loop();
  planetaryTrack.amp(0.35); // Bumped up amplitude since it's the solo track now

  // 3. Initialize Audio Synthesizers (Teacher Criteria)
  baseDrone = new SinOsc(this);
  telemetryLead = new SawOsc(this);
  radarEcho = new Pulse(this);
  atmosphereBox = new LowPass(this);

  // 4. Route week7sound into the Visual Analysis Engine & Filter
  audioWave = new Waveform(this, soundSamples);
  atmosphereBox.process(planetaryTrack);
  audioWave.input(planetaryTrack); // Everything now dances directly to week7sound!

  // Start synths
  baseDrone.play();
  telemetryLead.play();
  radarEcho.play();

  baseDrone.amp(0.15);
  telemetryLead.amp(0.06);
  radarEcho.amp(0.02);
}

void draw() {
  // -----------------------------------------------------------
  // AUDIO SYNTH MODULATIONS (Teacher Criteria)
  // -----------------------------------------------------------
  float internalLFO = sin(frameCount * 0.05);
  baseDrone.freq(55.0 + (sin(frameCount * 0.01) * 8.0));
  
  float modulatedFrequency = 220.0 + (internalLFO * 140.0); 
  telemetryLead.freq(modulatedFrequency);

  float filterSweep = map(cos(frameCount * 0.02), -1, 1, 400, 2800);
  atmosphereBox.freq(filterSweep);
  radarEcho.freq(950.0 + (sin(frameCount * 0.12) * 250.0));

  // Poll live data stream from week7sound
  audioWave.analyze(); 
  float realTimeAudioSample = 0.0;
  if (audioWave.data.length > 0) {
    realTimeAudioSample = audioWave.data[0]; // Range from -1.0 to 1.0
  }

  // -----------------------------------------------------------
  // VISUALS: MOVING PURPLE & PINK BACKGROUND
  // -----------------------------------------------------------
  for (int y = 0; y < height; y += 2) {
    float inter = map(y, 0, height, 0, 1);
    float audioFlash = realTimeAudioSample * 60.0;
    
    color purpleBase = color(75 + audioFlash, 15, 130 + (sin(frameCount * 0.02) * 20));
    color pinkBase   = color(255, 20 + audioFlash, 147 + (cos(frameCount * 0.01) * 30));
    
    float waveMovement = sin(frameCount * 0.03 + y * 0.006) * 0.15;
    color finalGradientColor = lerpColor(purpleBase, pinkBase, inter + waveMovement);
    
    stroke(finalGradientColor);
    strokeWeight(2);
    line(0, y, width, y);
  }

  // -----------------------------------------------------------
  // VISUALS: MULTIPLYING & MOVING RIHANNA IMAGES
  // -----------------------------------------------------------
  // Dynamically calculate how many copies to draw based on the beat (3 to 8 copies)
  int imageCopies = int(map(abs(realTimeAudioSample), 0, 0.7, 3, 8));
  imageCopies = constrain(imageCopies, 3, 8); 

  for (int i = 0; i < imageCopies; i++) {
    pushMatrix();
    
    // Arrange copies in an orbital ring layout
    float angle = (frameCount * 0.015) + (i * TWO_PI / imageCopies);
    
    // Push the images outward reactively when sound levels spike
    float radius = 220.0 + (realTimeAudioSample * 120.0);
    
    float posX = (width / 2.0) + cos(angle) * radius;
    float posY = (height / 2.0) + sin(angle) * radius;
    
    translate(posX, posY);
    
    // Make individual images spin on their own axes
    rotate(angle * 1.5 + realTimeAudioSample);
    
    // Audio-reactive scaling: images pulse larger on heavy beats
    float dynamicScale = map(abs(realTimeAudioSample), 0, 1, 0.5, 1.2);
    scale(dynamicScale);
    
    // Tint the image pink/purple and make it flash translucent to the music
    float flashAlpha = map(abs(realTimeAudioSample), 0, 1, 130, 245);
    tint(255, 120, 220, flashAlpha);
    
    // Render instance
    image(pictureRihanna, 0, 0);
    
    popMatrix();
  }
  noTint(); // Reset tint so it doesn't affect the lines below

  // -----------------------------------------------------------
  // VISUALS: LAYERED AUDIO GLOW-WAVES
  // -----------------------------------------------------------
  noFill();
  for (int layer = 0; layer < 3; layer++) {
    if (layer == 0) { stroke(255, 0, 170, 180); strokeWeight(6); } 
    else if (layer == 1) { stroke(186, 85, 211, 140); strokeWeight(4); } 
    else { stroke(255, 182, 193, 210); strokeWeight(2); }
    
    beginShape();
    for (int i = 0; i < audioWave.data.length; i++) {
      float x = map(i, 0, audioWave.data.length - 1, 0, width);
      float sampleAmp = audioWave.data[i];
      float waveHeightModifier = sampleAmp * (280.0 + (layer * 60.0)); 
      float constantMotion = sin(i * 0.07 + frameCount * 0.08 + (layer * 2.0)) * 30.0;
      
      float y = (height / 2.0) + waveHeightModifier + constantMotion;
      y = constrain(y, 15, height - 15);
      vertex(x, y);
    }
    endShape();
  }
}