Crowd crowd;

class Crowd{
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

class Character{
  PVector position;
  PVector velocity;
  PVector accel;
  
  float orientation;
  ArrayList<PVector> path;
  float maxSpeed;
  
  float maxForce;
  float targetSpeed = 4;
  PVector target;
  Character(PVector position, float orientation){
    
    accel = new PVector(0, 0);
    float angle = orientation;
    velocity = new PVector(cos(angle), sin(angle));
    this.position = position;  
    maxSpeed = 4;
    maxForce = 0.05;
    path = new ArrayList<PVector>();
    
  }
  
  void applyForce(PVector force){
    accel.add(force);
  }
  
  void move(ArrayList<Character> characters){
    applyBehaviors(characters);
    
    checkBoundary();
    update();
    show();
  }
  
  PVector seek(PVector target) {
    PVector desired_velocity = PVector.sub(target, position);
    desired_velocity.normalize();
    desired_velocity.mult(maxSpeed);
    PVector steer = PVector.sub(desired_velocity,velocity);
    steer.limit(maxForce);
    return steer;
  }
  
  PVector separate (ArrayList<Character> characters) {
    
    float separation_distance = 50; 
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
    return new PVector(0,0);
  }
   PVector align (ArrayList<Character> characters) {

    float neighbor_distance = 50;
    PVector sum = new PVector(0,0);
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
      PVector steer = PVector.sub(sum,velocity);
      steer.limit(maxForce);
      return steer;

    } else {
      return new PVector(0,0);
    }
  }
    PVector cohesion(ArrayList<Character> characters){
      float neighbor_distance = 50;
      PVector sum = new PVector(0,0);
      int count = 0;
      for (Character other : characters){
        float d = PVector.dist(position, other.position);
        if ((d > 0) && (d < neighbor_distance)) {
          sum.add(other.position); 
          count++;
        } 
      }
      if (count > 0){
        sum.div(count);
        return seek(sum);
        
      }
      else{
        return new PVector(0, 0);
      }
    }
    void applyBehaviors(ArrayList<Character> characters) {
    PVector sep = separate(characters);
    PVector seek = seek(new PVector(mouseX,mouseY));
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
  
  
  void update(){
    velocity.add(accel);
    velocity.limit(maxSpeed);
    position.add(velocity);
    accel.mult(0);
  }
  
  void show(){
  
    float rot_angle = velocity.heading2D() + radians(90);
    
    fill(255, 255, 255);
    stroke(255, 255, 255);
    pushMatrix();
    translate(position.x, position.y);
    rotate(rot_angle);
    circle(0,10,10);
    beginShape(TRIANGLES);
    
    
    vertex(0, -10);
    vertex(-5, 10);
    vertex(5, 10);
    
    endShape();
    popMatrix();
  }
  
  
 void checkBoundary(){
  if (position.x < -10) velocity.x *= -1;
    if (position.y < -10) velocity.y *= -1;
    if (position.x > width+10) velocity.x *= -1;
    if (position.y > height+10) velocity.y *= -1;
 } 
}
void setup(){
  
  size(800, 600);
  
  background(255, 255, 255);
  crowd = new Crowd();
  for (int j = 0; j < 200; j++) {
    crowd.addCharacter(new Character(new PVector(random(width),random(height)), random(180)));
  }
  
}

void draw(){
  clear();
  background(0, 0, 0);
  crowd.move();
}




  
  
  
  
  
