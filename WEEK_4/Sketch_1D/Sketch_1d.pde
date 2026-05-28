float xstep = 8; 
float factor, ypos;

void setup() {
  size(600, 400); 
}

void draw() {
  background(15, 12, 28); 
  
  for (int i = 0; i < width/xstep; i++) {
    
    factor = float(i) * 0.04;
    ypos = map(noise(factor, frameCount * 0.02), 0, 1, 50, height - 50); 
    
    float size = map(ypos, 0, height, 4, 24);
    
    if (i % 2 == 0) {
      fill(0, 230, 255);
    } else {
      fill(255, 45, 130);
    }
    
    noStroke();
    ellipse(xstep/2 + (xstep * i), ypos, size, size); 
  }
}