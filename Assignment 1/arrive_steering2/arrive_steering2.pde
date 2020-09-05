int count;
int i;
PVector target = new PVector(20, height-20);
Character ch;
PVector direction = new PVector(0,0);
float slowR = 200;
float timeToTarget = 5;
float distance = 0;
PVector steering = new PVector(0, 0);
PVector desired_velocity = new PVector(0, 0);
class Character{
  PVector position;
  PVector velocity;
  float orientation = 45;
  ArrayList<PVector> path;
  float maxSpeed;
  PVector accel;
  float targetSpeed = 4;
  Character(PVector position, PVector velocity, float orientation, float maxSpeed){
    
    this.position = position;
    this.velocity = velocity;
    this.orientation = orientation;
    this.maxSpeed = maxSpeed;
    path = new ArrayList<PVector>();
  }
}
void setup(){
  
  size(800, 600);
  strokeWeight(2);
  background(255, 255, 255);
  PVector position = new PVector(20, height-20);
  count = 0;
  PVector velocity = new PVector(0,0);
  
  ch = new Character(position, velocity, 45.0, 2);
  
  i = 0;
}

void draw(){
  clear();
  stroke(0, 255, 255);
  count++;
  fill(0, 255, 255);
   //target = new PVector(mouseX, mouseY);
 // target = new PVector(mouseX, mouseY);
  if (abs(ch.position.x - target.x) < 4 && abs(ch.position.y - target.y)<4){
    ch.velocity.x = 0;
    ch.velocity.y = 0;
    
  }
  else{
    
   
    
    direction.x =  target.x - ch.position.x;
    direction.y =  target.y - ch.position.y;
    distance = PVector.dist(ch.position, target);
    
    desired_velocity = direction;
    //if (distance < slowR) {
    
    //  desired_velocity = desired_velocity.normalize().mult(ch.maxSpeed * (distance / slowR));
    //} 
    
    //else {
    
    //desired_velocity = desired_velocity.normalize().mult(ch.maxSpeed);
    //}
    
    
    steering.x = desired_velocity.x - ch.velocity.x;
    steering.y = desired_velocity.y - ch.velocity.y;
    steering.div(timeToTarget);
    if (steering.mag() > ch.maxSpeed){
      steering.normalize().mult(ch.maxSpeed);
    }
    
    ch.velocity = ch.velocity.add(steering);
    //ch.velocity.div(timeToTarget);
    
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
 

 
