

Zombie[] zombies;
Brain[] brains;
PVector gravity;

int score = 0;
int lives = 5;
boolean isGameOver = false;

void setup() {
  size(800, 600);


  gravity = new PVector(0, 0.4);


  zombies = new Zombie[2];
  zombies[0] = new Zombie(width / 2 - 60, height - 100, 6.0, color(150, 90, 220));
  zombies[1] = new Zombie(width / 2 + 60, height - 100, 14.0, color(90, 160, 150));


  brains = new Brain[5];
  for (int i = 0; i < brains.length; i++) {
    brains[i] = new Brain();
  }
}

void draw() {

  background(255, 204, 213);

  if (!isGameOver) {


    for (int j = 0; j < zombies.length; j++) {

      PVector g = gravity.copy().mult(zombies[j].mass);
      zombies[j].applyForce(g);


      if (mousePressed) {
        PVector mouseTarget = new PVector(mouseX, mouseY);
        PVector mouseAttraction = PVector.sub(mouseTarget, zombies[j].position);

        mouseAttraction.normalize();
        mouseAttraction.mult(50.0);

        zombies[j].applyForce(mouseAttraction);
      }


      if (keyPressed) {
        if (key == 'a' || keyCode == LEFT) zombies[j].applyForce(new PVector(-1.5, 0));
        if (key == 'd' || keyCode == RIGHT) zombies[j].applyForce(new PVector(1.5, 0));
      }


      zombies[j].update();
      zombies[j].display();
    }


    for (int i = 0; i < brains.length; i++) {
      brains[i].update();
      brains[i].display();


      for (int j = 0; j < zombies.length; j++) {
        float distance = PVector.dist(zombies[j].position, brains[i].position);
        float collisionThreshold = (zombies[j].mass * zombies[j].radiusMultiply) + brains[i].radius;

        if (distance < collisionThreshold) {
          score++;
          brains[i].reset();
          break;
        }
      }


      if (brains[i].position.y > height) {
        lives--;
        brains[i].reset();

        if (lives <= 0) {
          isGameOver = true;
        }
      }
    }


    displayUI();

  } else {
    displayGameOver();
  }
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
    for (int j = 0; j < zombies.length; j++) {
      zombies[j].applyForce(new PVector(0, -15));
    }
  }


  if (key == 'r' || key == 'R') {
    score = 0;
    lives = 5;
    isGameOver = false;
    setup();
  }
}




class Brain {
  PVector position;
  float speed;
  float radius = 15;

  Brain() {
    position = new PVector(0, 0);
    reset();
  }

  void reset() {
    position.x = random(50, width - 50);
    position.y = random(-200, -20);
    speed = random(2.5, 6.0);
  }

  void update() {
    position.y += speed;
  }

  void display() {
    fill(50, 220, 120);
    stroke(80, 40, 50);
    strokeWeight(2);
    ellipse(position.x, position.y, radius * 2, radius * 1.6);
    line(position.x, position.y - 5, position.x, position.y + 5);
  }
}




class Zombie {
  PVector position;
  PVector velocity;
  PVector acceleration;

  float mass;
  int radiusMultiply = 3;
  color zombieColor;


  Zombie(float x, float y, float m, color c) {
    position = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    mass = m;
    zombieColor = c;
  }


  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }

  void update() {
    velocity.add(acceleration);
    velocity.mult(0.94);
    velocity.limit(26);

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
    float eyeOffset = playerSize * 0.15;
    ellipse(position.x - eyeOffset, position.y - 5, 8, 8);
    ellipse(position.x + eyeOffset, position.y - 5, 8, 8);
  }

  void checkEdges() {
    float r = mass * radiusMultiply;
    if (position.x - r < 0) {
      position.x = r;
      velocity.x *= -0.4;
    }
    if (position.x + r > width) {
      position.x = width - r;
      velocity.x *= -0.4;
    }
    if (position.y + r > height) {
      position.y = height - r;
      velocity.y = 0;
    }
    if (position.y - r < 0) {
      position.y = r;
      velocity.y *= -0.1;
    }
  }
}
