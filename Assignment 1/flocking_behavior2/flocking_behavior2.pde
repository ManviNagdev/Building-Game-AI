Crowd crowd;
Character target1;
Character target2;
PVector center1 = new PVector(10, 10);
PVector center2 = new PVector(50, 50);
PVector target_temp;
PVector d_velocity;
PVector direction = new PVector(0, 0);
float distance = 0;
PVector steering = new PVector(0, 0);
float maxRot = 3.14/2;
float minRot = -3.14/2;
int itr = 0;
float rot;
class Crowd {
  ArrayList<Character> characters; 

  Crowd() {
    characters = new ArrayList<Character>(); 
  }

  void move() {
    for (Character ch : characters) {
      ch.move(characters);  
    }
  }

  void addCharacter(Character ch) {
    characters.add(ch);
  }
}

class Character {
  PVector position;
  PVector velocity;
  PVector accel;

  float orientation = 45;
  ArrayList<PVector> path;
  float maxSpeed;

  float maxForce;
  float targetSpeed = 4;
  PVector target;
  Character(PVector position, float orientation) {
    accel = new PVector(0, 0);
    float angle = orientation;
    velocity = new PVector(cos(angle), sin(angle));
    this.position = position;  
    maxSpeed = 4;
    maxForce = 0.05;
    path = new ArrayList<PVector>();
  }

  void applyForce(PVector force) {
    accel.add(force);
  }

  void move(ArrayList<Character> characters) {
    applyBehaviors(characters);
    checkBoundary();
    update();
    show();
  }

  PVector seek(PVector target) {
    PVector desired_velocity = PVector.sub(target, position);
    desired_velocity.normalize();
    desired_velocity.mult(maxSpeed);
    PVector steer = PVector.sub(desired_velocity, velocity);
    steer.limit(maxForce);
    return steer;
  }

  PVector separate (ArrayList<Character> characters) {

    float separation_distance = 30; 
    PVector sum = new PVector();
    int count = 0;
    for (Character other : characters) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < separation_distance)) {
        PVector sep_dist = PVector.sub(position, other.position);
        sep_dist.normalize();        
        sep_dist.div(d);  
        sum.add(sep_dist);
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      sum.normalize();
      sum.mult(maxSpeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxForce);
      return steer;
    }
    return new PVector(0, 0);
  }
  PVector align (ArrayList<Character> characters) {

    float neighbor_distance = 50;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Character other : characters) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbor_distance)) {
        sum.add(other.velocity);

        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      sum.normalize();
      sum.mult(maxSpeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxForce);
      return steer;
    } else {
      return new PVector(0, 0);
    }
  }
  PVector cohesion(ArrayList<Character> characters) {
    float neighbor_distance = 50;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Character other : characters) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbor_distance)) {
        sum.add(other.position); 
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);
    } else {
      return new PVector(0, 0);
    }
  }
  void applyBehaviors(ArrayList<Character> characters) {
    PVector sep = separate(characters);
    PVector seek;
    if (PVector.dist(target1.position, position) < PVector.dist(target2.position, position)) {
      seek = seek(target1.position);
      fill(255, 200, 255);
      stroke(255, 200, 255);
    } else {
      seek = seek(target2.position);
      fill(200, 255, 255);
      stroke(200, 255, 255);
    }
    PVector alignment = align(characters);
    PVector coh = cohesion(characters);
    sep.mult(1.5);
    seek.mult(0.5);
    alignment.mult(1.0);
    coh.mult(1.0);
    applyForce(sep);
    applyForce(seek);
    applyForce(alignment);
    applyForce(coh);
  }


  void update() {
    velocity.add(accel);
    velocity.limit(maxSpeed);
    position.add(velocity);
    accel.mult(0);
  }

  void show() {

    float rot_angle = velocity.heading2D() + radians(90);

    
    pushMatrix();
    translate(position.x, position.y);
    rotate(rot_angle);
    circle(0, 10, 10);
    beginShape(TRIANGLES);


    vertex(0, -10);
    vertex(-5, 10);
    vertex(5, 10);

    endShape();
    popMatrix();
  }


  void checkBoundary() {
    if (position.x < -10) {
      velocity.x *= -40;
      position.x += velocity.x;
    }
    if (position.y < -10) {
      velocity.y *= -40;
      position.y += velocity.y;
    }
    if (position.x > width+10) {
      velocity.x *= -40;
      position.x += velocity.x;
    }
    if (position.y > height+10) {
      velocity.y *= -40;
      position.y += velocity.y;
    }
  }
}
void setup() {

  size(800, 600);
  //fullScreen();
  background(255, 255, 255);
  crowd = new Crowd();
  for (int j = 0; j < 200; j++) {
    crowd.addCharacter(new Character(new PVector(random(width), random(height)), random(180)));
  }
  target1 = new Character(new PVector(random(width), random(height)), random(180));
  target2 = new Character(new PVector(random(width), random(height)), random(180));
}

void draw() {
  clear();
  background(0, 0, 0);
  crowd.move();
  itr++;
  center1 = target1.velocity.normalize().mult(10);
  target_temp = PVector.fromAngle(target1.orientation, center1);
  direction.x =  target_temp.x - target1.position.x;
  direction.y =  target_temp.y - target1.position.y;
  distance = PVector.dist(target1.position, target_temp);

  d_velocity = direction;


  steering.x = - d_velocity.x + target1.velocity.x;
  steering.y = - d_velocity.y + target1.velocity.y;

  if (steering.mag() > target1.maxSpeed) {
    steering.limit(target1.maxForce);
  }
  if (itr%20 == 0) {
    target1.orientation += randomBinomial();
  }

  target1.checkBoundary();

  target1.update();


  rot = target1.velocity.heading2D() + radians(90);

  fill(255, 0, 255);
  stroke(255, 0, 255);
  pushMatrix();
  translate(target1.position.x, target1.position.y);
  rotate(rot);
  circle(0, 15, 15);
  beginShape(TRIANGLES);

  vertex(0, -15);
  vertex(-7.5, 15);
  vertex(7.5, 15);

  endShape();
  popMatrix();


  center2 = target2.velocity.normalize().mult(10);
  target_temp = PVector.fromAngle(target2.orientation, center2);
  direction.x =  target_temp.x - target2.position.x;
  direction.y =  target_temp.y - target2.position.y;
  distance = PVector.dist(target2.position, target_temp);

  d_velocity = direction;


  steering.x = - d_velocity.x + target2.velocity.x;
  steering.y = - d_velocity.y + target2.velocity.y;

  if (steering.mag() > target2.maxSpeed) {
    steering.limit(target2.maxForce);
  }  
  if (itr%20 == 0) {
    target2.orientation += randomBinomial();
  }

  target2.checkBoundary();

  target2.update();
  rot = target2.velocity.heading2D() + radians(90);

  fill(0, 255, 255);
  stroke(0, 255, 255);
  pushMatrix();
  translate(target2.position.x, target2.position.y);
  rotate(rot);
  circle(0, 15, 15);
  beginShape(TRIANGLES);

  vertex(0, -15);
  vertex(-7.5, 15);
  vertex(7.5, 15);

  endShape();
  popMatrix();
}


float randomBinomial() {
  return (random(-3.14/4, 3.14/4) - random(-3.14/4, 3.14/4));
}
