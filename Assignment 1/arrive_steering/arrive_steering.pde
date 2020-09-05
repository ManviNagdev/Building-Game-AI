int count;
int i;
PVector target = new PVector(0,0);
Character ch;
PVector direction = new PVector(0,0);
float slowR = 200;
class Character{
  PVector position;
  PVector velocity;
  float orientation = 45;
  ArrayList<PVector> path;
  float maxSpeed;
  PVector accel = new PVector(0,0);
  float targetSpeed = 0;
  Character(PVector position, PVector velocity, float orientation, float maxSpeed){
    
    this.position = position;
    this.velocity = velocity;
    this.orientation = orientation;
    this.maxSpeed = maxSpeed;
    path = new ArrayList<PVector>();
  }
}
void setup(){
  frameRate(60);
  size(800, 600);
  strokeWeight(2);
  background(255, 255, 255);
  PVector position = new PVector(20, height-20);
  count = 0;
  PVector velocity = new PVector(2,2);
  
  ch = new Character(position, velocity, 45.0, 6);
  
  i = 0;
}

void draw(){
  clear();
  stroke(0, 255, 255);
  count++;
  fill(0, 255, 255);
  if (abs(ch.position.x - target.x) < 2 && abs(ch.position.y - target.y)<2){
    ch.velocity.x = 0;
    ch.velocity.y = 0;
    
  }
  else{
    
    ch.accel.mult(0);

    direction.x = -ch.position.x + target.x;
    direction.y = -ch.position.y + target.y;
    if (direction.mag() < slowR){
      ch.targetSpeed = ch.maxSpeed * direction.mag() / slowR;
    }
    else{
      ch.targetSpeed = ch.maxSpeed;
    }
    ch.accel.add(direction.normalize().mult(ch.targetSpeed)); 
    
    ch.velocity = ch.accel.add(ch.velocity);
    ch.velocity.limit(ch.maxSpeed);
    ch.position.add(ch.velocity);
    ch.orientation = face(ch.velocity);
  }
  
  for(int j = 0; j<ch.path.size(); j++) {
    fill(0, 255, 255);
    circle(ch.path.get(j).x, ch.path.get(j).y, 2);
   }
  translate(ch.position.x, ch.position.y);
  
  rotate(ch.orientation);
  stroke(255, 255, 255);
  fill(255, 255, 255);
  circle(0, 0, 20);
  triangle(2, -10, 2, 10, 30, 0);
  if (count%2==0 ){

    ch.path.add(new PVector(ch.position.x, ch.position.y));
  }
  
}
float face(PVector velocity) {
  return atan2(velocity.y, velocity.x);
}

 void mousePressed(){
   target = new PVector(mouseX, mouseY);
 }
 

 
