int count;
int i;
PVector target = new PVector(20, height-20);
Character ch;
PVector direction = new PVector(0, 0);
float slowR = 200;
float timeToTarget = 5;
float distance = 0;
PVector steering = new PVector(0, 0);
PVector desired_velocity = new PVector(2, 2);
float maxRot = 3.14/2;
float minRot = -3.14/2;
PVector center = new PVector(10, 10);
class Character {
  PVector position;
  PVector velocity;
  PVector accel;

  float orientation;
  ArrayList<PVector> path;
  float maxSpeed;

  float maxForce;
  float targetSpeed = 4;
  PVector target;
  Character(PVector position, float orientation) {

    accel = new PVector(0, 0);
    float angle = orientation;
    velocity = new PVector(sin(angle), cos(angle));
    this.position = position;  
    maxSpeed = 2;
    maxForce = 0.05;
    path = new ArrayList<PVector>();
  }

  void update() {
    velocity.add(accel);
    velocity.limit(maxSpeed);
    position.add(velocity);
    accel.mult(0);
  }
  void show() {

    float rot_angle = velocity.heading2D() + radians(90);

    fill(255, 255, 255);
    stroke(255, 255, 255);
    pushMatrix();
    translate(position.x, position.y);
    rotate(rot_angle);
    circle(0, 15, 15);
    beginShape(TRIANGLES);

    vertex(0, -15);
    vertex(-7.5, 15);
    vertex(7.5, 15);

    endShape();
    popMatrix();
  }

  void checkBoundary() {
    if (position.x < -10) {
      velocity.x *= -20;
      position.x += velocity.x;
    }
    if (position.y < -10) {
      velocity.y *= -20;
      position.y += velocity.y;
    }
    if (position.x > width+10) {
      velocity.x *= -20;
      position.x += velocity.x;
    }
    if (position.y > height+10) {
      velocity.y *= -20;
      position.y += velocity.y;
    }
  }
}
void setup() {
  frameRate(60);
  size(800, 600);
  strokeWeight(2);
  background(255, 255, 255);

  count = 0;

  ch = new Character(new PVector(200, 200), random(180));

  i = 0;
}

void draw() {
  clear();
  stroke(0, 255, 255);
  count++;
  fill(0, 255, 255);


  center = ch.velocity.normalize().mult(10);
  target = PVector.fromAngle(ch.orientation, center);
  direction.x =  target.x - ch.position.x;
  direction.y =  target.y - ch.position.y;
  distance = PVector.dist(ch.position, target);

  desired_velocity = direction;


  steering.x = - desired_velocity.x + ch.velocity.x;
  steering.y = - desired_velocity.y + ch.velocity.y;

  if (steering.mag() > ch.maxSpeed) {
    steering.limit(ch.maxForce);
  }
  if (count%20 == 0) {
    ch.orientation += randomBinomial();
  }
  ch.velocity.add(steering);
  ch.checkBoundary();

  ch.update();


  for (int j = 0; j<ch.path.size(); j++) {
    fill(0, 255, 255);
    circle(ch.path.get(j).x, ch.path.get(j).y, 3);
  } 

  ch.show();

  if (count%2==0 ) {

    ch.path.add(new PVector(ch.position.x, ch.position.y));
  }
}


float randomBinomial() {
  return (random(-3.14/4, 3.14/4) - random(-3.14/4, 3.14/4));
}
