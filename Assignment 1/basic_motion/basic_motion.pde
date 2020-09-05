
int count;
PVector[] target = new PVector[4];
int i;

Character ch;
class Character{
  PVector position;
  PVector velocity;
  float orientation = 45;
  ArrayList<PVector> path;
  
  Character(PVector position, PVector velocity, float orientation){
    
    this.position = position;
    this.velocity = velocity;
    this.orientation = orientation;
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
  
  ch = new Character(position, velocity, 45.0);
  target[0] = new PVector(width-20, height-20);
  target[1] = new PVector(width-20, 20);
  target[2] = new PVector(20, 20);
  target[3] = new PVector(20, height-20);
  i = 0;
}

void draw(){
  clear();
  stroke(0, 255, 255);
  count++;
  fill(0, 255, 255);
 
 if(target[i].x - ch.position.x > 0){
   ch.velocity.x = 2;
 }
 else if(target[i].x-ch.position.x == 0){
   ch.velocity.x = 0;
 }
 
 else if (target[i].x-ch.position.x < 0){
   ch.velocity.x = -2;
 }
  if(target[i].y-ch.position.y > 0){
   ch.velocity.y = 2;
  
 }
  else if(target[i].y-ch.position.y == 0){
   ch.velocity.y = 0;
   
 }
 
 else if (target[i].y-ch.position.y < 0){
   ch.velocity.y = -2;
   
 }
   
  ch.position.add(ch.velocity);
  ch.orientation = face(ch.velocity);
  for(int j = 0; j<ch.path.size(); j++) {
    fill(0, 255, 255);
    circle(ch.path.get(j).x, ch.path.get(j).y, 10);
   }
  translate(ch.position.x, ch.position.y);
  
  rotate(ch.orientation);
  stroke(255, 255, 255);
  fill(255, 255, 255);
  circle(0, 0, 20);
  triangle(2, -10, 2, 10, 30, 0);
  if (count%10==0 ){

    ch.path.add(new PVector(ch.position.x, ch.position.y));
  }
  
  if(ch.velocity.x == 0 && ch.velocity.y == 0 ){
    i += 1; 
    
    ch.velocity.x = 2;
    ch.velocity.y = 2;
    if (i==4){
    ch.velocity.x = 0;
    ch.velocity.y = 0;
    i=3;
   
  }
  }
}
float face(PVector velocity) {
  return atan2(velocity.y, velocity.x);
}
