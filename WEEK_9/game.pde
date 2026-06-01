

Zombie player;
PVector gravity;
PVector jumpForce;


int score = 0;
int lives = 3;
boolean isGameOver = false;


PVector brainPos;
float brainRadius = 15;
float fallSpeed = 3.5;

void setup() {
  size(800, 600);
  
  
  player = new Zombie(width / 2, height - 100, 8.0);
  
  
  gravity = new PVector(0, 0.4);
  jumpForce = new PVector(0, -14); 
  

  spawnBrain();
}

void draw() {
  
  background(255, 204, 213);
  
  if (!isGameOver) {
    
    PVector g = gravity.copy().mult(player.mass);
    player.applyForce(g);
    
    
    
    
    if (mousePressed) {
      PVector mouseTarget = new PVector(mouseX, mouseY);
      PVector mouseAttraction = PVector.sub(mouseTarget, player.position); 
      
      mouseAttraction.normalize(); 
      mouseAttraction.mult(45.0);  
      
      player.applyForce(mouseAttraction);
    }
    
    
    if (keyPressed) {
      if (key == 'a' || keyCode == LEFT) {
        player.applyForce(new PVector(-1.2, 0)); 
      }
      if (key == 'd' || keyCode == RIGHT) {
        player.applyForce(new PVector(1.2, 0));
      }
    }
    
    
    player.update();
    player.display();
    
    
    drawBrain();
    
    
    float distance = PVector.dist(player.position, brainPos);
    float collisionThreshold = (player.mass * player.radiusMultiply) + brainRadius;
    
    if (distance < collisionThreshold) {
      score++;
      fallSpeed += 0.3; 
      spawnBrain();
    }
    
    
    if (brainPos.y > height) {
      lives--;
      if (lives <= 0) {
        isGameOver = true;
      } else {
        spawnBrain();
      }
    }
    
   
    displayUI();
    
  } else {
    displayGameOver();
  }
}


void spawnBrain() {
  brainPos = new PVector(random(50, width - 50), -20);
}


void drawBrain() {
  brainPos.y += fallSpeed;
  
 
  fill(50, 220, 120);
  stroke(80, 40, 50);
  strokeWeight(2);
  ellipse(brainPos.x, brainPos.y, brainRadius * 2, brainRadius * 1.6);
  
  
  line(brainPos.x, brainPos.y - 5, brainPos.x, brainPos.y + 5);
}

void displayUI() {
  fill(80, 40, 50); 
  textSize(22);
  textAlign(LEFT, TOP);
  text("Brains Eaten: " + score, 20, 20);
  
  textAlign(RIGHT, TOP);
  text("Lives Left: " + lives, width - 20, 20);
}

void displayGameOver() {
  fill(80, 40, 50);
  textAlign(CENTER, CENTER);
  textSize(40);
  text("GAME OVER", width / 2, height / 2 - 30);
  textSize(22);
  text("Final Score: " + score, width / 2, height / 2 + 15);
  textSize(16);
  text("Press 'R' to Restart", width / 2, height / 2 + 60);
}


void keyPressed() {
  
  if ((key == ' ' || keyCode == UP) && !isGameOver) {
    player.applyForce(jumpForce);
  }
  
  
  if (key == 'r' || key == 'R') {
    score = 0;
    lives = 3;
    fallSpeed = 3.5;
    isGameOver = false;
    setup();
  }
}



class Zombie {
  PVector position;
  PVector velocity;
  PVector acceleration;
  
  float mass;
  int radiusMultiply = 3; 
  color zombieColor = color(140, 80, 180);

  
  Zombie(float x, float y, float m) {
    position = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    mass = m;
  }
  
  
  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }

  void update() {
    velocity.add(acceleration);
    
    
    velocity.mult(0.95); 
    
    
    velocity.limit(28);
    
    position.add(velocity);
    checkEdges();
    
    
    acceleration.mult(0);
  }

  void display() {
    strokeWeight(3);
    stroke(80, 40, 50);
    fill(zombieColor);
    
    
    float playerSize = mass * radiusMultiply * 2;
    ellipse(position.x, position.y, playerSize, playerSize);
    
    fill(255, 255, 100);
    ellipse(position.x - 8, position.y - 5, 8, 8);
    ellipse(position.x + 8, position.y - 5, 8, 8);
  }

  
  void checkEdges() {
    float r = mass * radiusMultiply;
    
    
    if (position.x - r < 0) {
      position.x = r;
      velocity.x *= -0.3; 
    } 
    if (position.x + r > width) {
      position.x = width - r;
      velocity.x *= -0.3;
    }
    
    // Floor boundary constraint
    if (position.y + r > height) {
      position.y = height - r;
      velocity.y = 0; 
    }
    // Ceiling restraint
    if (position.y - r < 0) {
      position.y = r;
      velocity.y *= -0.1;
    }
  }
}