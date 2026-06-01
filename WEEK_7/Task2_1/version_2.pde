import processing.sound.*; 

SoundFile sunEffect;      // The ONLY audio file used now
SinOsc baseDrone;         
SawOsc telemetryLead;     
Pulse radarEcho;          
LowPass atmosphereBox;    

Waveform audioWave;       
int soundSamples = 256;

void setup() {
  size(1280, 720); 

  // 1. Load ONLY the Sun Sound Effect
  // (Change the spelling inside the quotes if your file doesn't have a space before .wav)
  sunEffect = new SoundFile(this, "Sun_soundeffect .wav");
  sunEffect.loop();
  sunEffect.amp(0.40); 

  // 2. Audio Synthesizers
  baseDrone = new SinOsc(this);
  telemetryLead = new SawOsc(this);
  radarEcho = new Pulse(this);
  atmosphereBox = new LowPass(this);

  // 3. Route the Sun Effect into the Visual Analysis Engine
  audioWave = new Waveform(this, soundSamples);
  atmosphereBox.process(sunEffect);
  audioWave.input(sunEffect); 

  // Start synths
  baseDrone.play();
  telemetryLead.play();
  radarEcho.play();

  baseDrone.amp(0.15);
  telemetryLead.amp(0.06);
  radarEcho.amp(0.02);
}

void draw() {
  // Synthesizer modulations
  float internalLFO = sin(frameCount * 0.05);
  baseDrone.freq(55.0 + (sin(frameCount * 0.01) * 8.0));
  
  float modulatedFrequency = 220.0 + (internalLFO * 140.0); 
  telemetryLead.freq(modulatedFrequency);

  float filterSweep = map(cos(frameCount * 0.02), -1, 1, 400, 2800);
  atmosphereBox.freq(filterSweep);
  radarEcho.freq(950.0 + (sin(frameCount * 0.12) * 250.0));

  // Poll the Sun Sound data for visuals
  audioWave.analyze(); 
  float realTimeAudioSample = 0.0;
  if (audioWave.data.length > 0) {
    realTimeAudioSample = audioWave.data[0]; 
  }

  // DRAW THE PURPLE & PINK BACKGROUND
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

  // DRAW THE AUDIO GLOW-WAVES
  noFill();
  for (int layer = 0; layer < 3; layer++) {
    if (layer == 0) { stroke(255, 0, 170, 160); strokeWeight(5); } 
    else if (layer == 1) { stroke(186, 85, 211, 120); strokeWeight(3); } 
    else { stroke(255, 182, 193, 190); strokeWeight(2); }
    
    beginShape();
    for (int i = 0; i < audioWave.data.length; i++) {
      float x = map(i, 0, audioWave.data.length - 1, 0, width);
      float sampleAmp = audioWave.data[i];
      float waveHeightModifier = sampleAmp * (250.0 + (layer * 75.0)); 
      float constantMotion = sin(i * 0.07 + frameCount * 0.08 + (layer * 2.0)) * 35.0;
      
      float y = (height / 2.0) + waveHeightModifier + constantMotion;
      y = constrain(y, 10, height - 10);
      vertex(x, y);
    }
    endShape();
  }
}