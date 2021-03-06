import java.util.*; 
import java.lang.Math; 

JSONObject json;
PriorityQueue<PVector> front;
JSONObject obs;
PVector prev = new PVector(0, 0);
PVector current = new PVector(0, 0);
PVector destination = new PVector(100, 100);
PShape[] obstacles;
PImage knight_sprite;
PImage castle_sprite;
PImage tar_pit_sprite;
PImage tavern_sprite;
PImage tree_sprite;
PImage cave_sprite;
HashMap<String, ArrayList<String> >has = new HashMap<String, ArrayList<String>>();
HashMap<String, ArrayList<String> >wants = new HashMap<String, ArrayList<String>>();
ArrayList<String> knight_has = new ArrayList<String>();
HashMap<String, PVector> key_loc = new HashMap<String, PVector>();
HashMap<PVector, Float> cost_so_far = new HashMap<PVector, Float>();
HashMap<PVector, PVector> path = new HashMap<PVector, PVector>();
Cave cave;
Tree tree;
Tavern tavern;
Castle castle;
Knight knight;
Tar_pit tar_pit;

King king;
Rameses rameses;
LadyLupa ladylupa;
TreeSpirit treespirit;
Innkeeper innkeeper;
Blacksmith blacksmith;
HashMap<PVector, Double> priority = new HashMap<PVector, Double>(); 
HashMap<PVector, PVector> came_from = new HashMap<PVector, PVector>(); 
PVector now = new PVector(100, 100);
boolean move = false;

class Knight {
  PVector position;
  int gold = 0;
  boolean water = false;
  boolean fenrir = false;
  boolean blade = false;
  boolean axe = false;
  boolean wolfsbane = false;
  boolean wood = false;
  boolean sword = false;
  boolean poisoned_sword = false;
  boolean poisioned_fenrir = false;
  boolean fire = false;
  boolean ale = false;
  ArrayList<PVector> path;
  Knight(PVector position) {
    this.position = position;
    path = new ArrayList<PVector>();
  }

  void show(PVector n) {
    stroke(255);
    
    knight_sprite.resize(50, 50);
   // println("............", n);

    image(knight_sprite, n.x - knight_sprite.width/2, n.y - knight_sprite.height/2);
  }
}

class Castle {
  PVector position;
  Castle(PVector position) {
    this.position = position;
  }
}

class Tar_pit {
  PVector position;
  Tar_pit(PVector position) {
    this.position = position;
  }
}

class Tavern {
  PVector position;
  Tavern(PVector position) {
    this.position = position;
  }
}

class Tree {
  PVector position;
  Tree(PVector position) {
    this.position = position;
  }
}

class Cave {
  PVector position;
  Cave(PVector position) {
    this.position = position;
  }
}

class Blacksmith {
  PVector position;
  boolean axe = false;
  boolean blade = false;
  int gold = 0;
  Blacksmith(PVector position) {
    this.position = position;
  }
}

class LadyLupa {
  PVector position;
  boolean fenrir = false;
  boolean want_wolfsbane = false;
  LadyLupa(PVector position) {
    this.position = position;
  }
}

class Innkeeper {
  PVector position;
  boolean ale = false;
  boolean water = false;
  int gold = 0;
  Innkeeper(PVector position) {
    this.position = position;
  }
}

class TreeSpirit {
  PVector position;
  boolean wolfsbane = false;
  boolean want_water = false;

  TreeSpirit(PVector position) {
    this.position = position;
  }
}

class King {
  PVector position;
  King(PVector position) {
    this.position = position;
  }
  int greet_gold;
}

class Rameses {
  PVector position;
  Rameses(PVector position) {
    this.position = position;
  }
}

class Vec_Sort implements Comparator<PVector> {
  public int compare(PVector one, PVector two) {
    return (int)(priority.get(one) - priority.get(two));
  }
}

void setup() {  
  size(640, 480);
  strokeWeight(2);
  background(255, 255, 255);
  json = loadJSONObject("../map2.json");

  JSONArray pos =  json.getJSONArray("knight_start");              //knight
  knight = new Knight(new PVector(pos.getInt(0), pos.getInt(1)));
  knight_sprite = loadImage("../knight.png");
  knight.position = new PVector(pos.getInt(0), pos.getInt(1));
  JSONObject kl = json.getJSONObject("key_locations");             //key locations
  pos = kl.getJSONArray("castle");
  castle = new Castle(new PVector(pos.getInt(0), pos.getInt(1)));
  castle_sprite = loadImage("../castle.png");
  king = new King(new PVector(pos.getInt(0), pos.getInt(1)));
  key_loc.put("castle", new PVector(pos.getInt(0), pos.getInt(1)));
  pos = kl.getJSONArray("tar_pit");
  tar_pit = new Tar_pit(new PVector(pos.getInt(0), pos.getInt(1)));
  tar_pit_sprite = loadImage("../tarpit1.png");
  rameses = new Rameses(new PVector(pos.getInt(0), pos.getInt(1)));
  key_loc.put("rameses", new PVector(pos.getInt(0), pos.getInt(1)));
  pos = kl.getJSONArray("tavern");
  tavern = new Tavern(new PVector(pos.getInt(0), pos.getInt(1)));
  tavern_sprite = loadImage("../tavern.png");
  innkeeper = new Innkeeper(new PVector(pos.getInt(0), pos.getInt(1)));
  key_loc.put("Innkeeper", new PVector(pos.getInt(0), pos.getInt(1)));
  pos = kl.getJSONArray("tree");
  tree = new Tree(new PVector(pos.getInt(0), pos.getInt(1)));
  tree_sprite = loadImage("../tree.png");
  treespirit = new TreeSpirit(new PVector(pos.getInt(0), pos.getInt(1)));
  key_loc.put("Tree Spirit", new PVector(pos.getInt(0), pos.getInt(1)));
  pos = kl.getJSONArray("cave");
  cave = new Cave(new PVector(pos.getInt(0), pos.getInt(1)));
  cave_sprite = loadImage("../cave.png");
  ladylupa = new LadyLupa(new PVector(pos.getInt(0), pos.getInt(1)));
  key_loc.put("Lady Lupa", new PVector(pos.getInt(0), pos.getInt(1)));
  //pos = kl.getJSONArray("forge");
  //blacksmith = new Blacksmith(new PVector(pos.getInt(0), pos.getInt(1)));
  //key_loc.put("Blacksmith", new PVector(pos.getInt(0), pos.getInt(1)));
  obs = json.getJSONObject("obstacles");
  //front.add(new PVector(knight.position.x, knight.position.y));

  //int gk = json.getInt("greet_king");
  //king.greet_gold = gk;

  destination = knight.position;
  //JSONObject state = json.getJSONObject("state_of_world");
  //JSONArray has_jarr = state.getJSONArray("Has");

  //for (int h = 0; h < has_jarr.size(); h++ ) {
  //  if (has.containsKey(has_jarr.getJSONArray(h).getString(0)))
  //    has.get(has_jarr.getJSONArray(h).getString(0)).add(has_jarr.getJSONArray(h).getString(1));

  //  else {
  //    has.put(has_jarr.getJSONArray(h).getString(0), new ArrayList<String>());
  //    has.get(has_jarr.getJSONArray(h).getString(0)).add(has_jarr.getJSONArray(h).getString(1));
  //  }
  //}
  //JSONArray wants_jarr = state.getJSONArray("Wants");
  //for (int w = 0; w < wants_jarr.size(); w++ ) {
  //  if (wants.containsKey(wants_jarr.getJSONArray(w).getString(0)))
  //    wants.get(wants_jarr.getJSONArray(w).getString(0)).add(wants_jarr.getJSONArray(w).getString(1));

  //  else {
  //    wants.put(wants_jarr.getJSONArray(w).getString(0), new ArrayList<String>());
  //    wants.get(wants_jarr.getJSONArray(w).getString(0)).add(wants_jarr.getJSONArray(w).getString(1));
  //  }
  //}

  //knight_has.add("1gold");
  //has.put("King", new ArrayList<String>());
  ////has.get("King").add(Integer.toString(gk));
  //print(key_loc);
  //print(has);
  //print(wants);
  destination = knight.position;
  update();
  //find("Fenrir");
  //print(ladylupa.want_wolfsbane);
  knight.show(knight.position);
  Vec_Sort vs = new Vec_Sort();

  front = new PriorityQueue<PVector>(4, vs);
  front.offer(knight.position);
  came_from.put(knight.position, new PVector());
  cost_so_far.put(knight.position, 0.0);
  knight.show(knight.position);
}

void draw() {
  update();
  knight.show(knight.position);
  PVector s = knight.position;
  path = moveto(s, destination);
  while(path.get(now) != s && path.get(now)!=null){
    knight.path.add(now);
    knight.show(now);
    //knight.position = now;
    //delay(1000);
    now = came_from.get(now);
  }
  //knight.show(knight.path.get(knight.path.size()-1));
}




boolean polyPoint(float px, float py) {
  boolean collision = false;

  // go through each of the vertices, plus
  // the next vertex in the list

  for (int j = 0; j< obstacles.length; j++) {
    for (int current=0; current<obstacles[j].getVertexCount(); current++) {
      int next = 0;
      // get next vertex in list
      // if we've hit the end, wrap around to 0
      next = current+1;
      if (next == obstacles[j].getVertexCount()) next = 0;

      // get the PVectors at our current position
      // this makes our if statement a little cleaner
      PVector vc = obstacles[j].getVertex(current);    // c for "current"
      PVector vn = obstacles[j].getVertex(next);       // n for "next"

      // compare position, flip 'collision' variable
      // back and forth
      if (((vc.y >= py && vn.y < py) || (vc.y < py && vn.y >= py)) &&
        (px < (vn.x-vc.x)*(py-vc.y) / (vn.y-vc.y)+vc.x)) {
        collision = !collision;
      }
    }
  }

  return collision;
}

double heuristics(PVector start, PVector goal) {
  double h = Math.sqrt((double)((start.x - goal.x) * (start.x - goal.x) + (start.y - goal.y) * (start.y - goal.y)));
  return h;
}



void mouseClicked() {
 // knight.position = 
  destination = new PVector(mouseX, mouseY);
  print("destination", destination);
  Vec_Sort vs = new Vec_Sort();
  now = destination;
  front = new PriorityQueue<PVector>(4, vs);
  front.offer(knight.position);
  came_from.clear();
  cost_so_far.clear();
  came_from.put(knight.position, new PVector());
  cost_so_far.put(knight.position, 0.0);
  
}

void update() {

  clear();
  background(0, 0, 0);
  stroke(120, 120, 150);
  fill(100, 100, 100);
  knight_sprite.resize(50, 50);
  //image(knight_sprite, knight.position.x - knight_sprite.width/2, knight.position.y - knight_sprite.height/2);
   knight.show(knight.position);
  //circle();
  castle_sprite.resize(60, 60);
  image(castle_sprite, castle.position.x - castle_sprite.width/2, castle.position.y - castle_sprite.height/2);
  tar_pit_sprite.resize(50, 50);
  image(tar_pit_sprite, tar_pit.position.x - tar_pit_sprite.width/2, tar_pit.position.y - tar_pit_sprite.height/2);
  tavern_sprite.resize(50, 50);
  image(tavern_sprite, tavern.position.x - tavern_sprite.width/2, tavern.position.y - tavern_sprite.height/2);
  tree_sprite.resize(50, 50);
  image(tree_sprite, tree.position.x - tree_sprite.width/2, tree.position.y - tree_sprite.height/2);
  cave_sprite.resize(60, 50);
  image(cave_sprite, cave.position.x - cave_sprite.width/2, cave.position.y - cave_sprite.height/2);
  //knight_sprite.resize(50, 50);
  //print(knight.position);

  //circle(blacksmith.position.x, blacksmith.position.y, 4);
  int i = 0;
  obstacles = new PShape[obs.size()];

  for (int j = 0; j<obs.size(); j++) { 
    obstacles[j] = createShape();
  }

  for (Object key : obs.keys()) {
    JSONArray posi = obs.getJSONArray((String) key);
    obstacles[i].beginShape();
    for (int p = 0; p < posi.size(); p++) {
      obstacles[i].vertex(posi.getJSONArray(p).getInt(0), posi.getJSONArray(p).getInt(1));
    } 
    obstacles[i].endShape(CLOSE);
    shape(obstacles[i]);
    i++;
  }
 // delay(100);
}

HashMap moveto(PVector source, PVector dest) {
  Vec_Sort vs = new Vec_Sort();

  front = new PriorityQueue<PVector>(2, vs);
  front.offer(source);
  came_from.clear();
  cost_so_far.clear();
  came_from.put(source, new PVector());
  cost_so_far.put(source, 0.0);
  while (!front.isEmpty()) {
    current = front.poll();
    if (current.x > dest.x - 2 && current.x < dest.x + 2 && current.y < dest.y + 2 && current.y > dest.y - 2) {
      // came_from.put(current, current);
      break;
    }
    PVector[] successors = new PVector[8];
    if (!polyPoint(current.x - 2, current.y)) {            //left
      successors[0] = new PVector(current.x - 2, current.y);
    } else
      successors[0] = new PVector(current.x, current.y);
    if (!polyPoint(current.x + 2, current.y)) {            //right
      successors[1] = new PVector(current.x + 2, current.y);
    } else
      successors[1] = new PVector(current.x, current.y);
    if (!polyPoint(current.x, current.y - 20)) {            //up
      successors[2] = new PVector(current.x, current.y - 2);
    } else
      successors[2] = new PVector(current.x, current.y);
    if (!polyPoint( current.x, current.y + 2)) {            //down
      successors[3] = new PVector(current.x, current.y + 2);
    } else
      successors[3] = new PVector(current.x, current.y);

    if (!polyPoint( current.x - 2, current.y - 2)) {         //diagnolleftup
      successors[4] = new PVector(current.x - 2, current.y - 2);
    } else
      successors[4] = new PVector(current.x, current.y);
    if (!polyPoint( current.x + 2, current.y - 2)) {         //diagnolrightup
      successors[5] = new PVector(current.x + 2, current.y - 2);
    } else
      successors[5] = new PVector(current.x, current.y);
    if (!polyPoint( current.x + 2, current.y + 2)) {         //diagnolrightdown
      successors[6] = new PVector(current.x + 2, current.y + 2);
    } else
      successors[6] = new PVector(current.x, current.y);
    if (!polyPoint( current.x - 2, current.y + 2)) {         //diagnolleftdown
      successors[7] = new PVector(current.x - 2, current.y + 2);
      //print("ttt");
    } else
      successors[7] = new PVector(current.x, current.y);
    //HashMap<PVector, Double> h = new HashMap<PVector, Double>(); 
    for (int j = 0; j < 8; j++) {
      if (successors[j].x > 0 && successors[j].y > 0 && successors[j].x < 640 && successors[j].y < 480) {
        float new_cost = cost_so_far.get(current) + dist(current.x, current.y, successors[j].x, successors[j].y);
        if (!cost_so_far.containsKey(successors[j]) || new_cost < cost_so_far.get(successors[j])) {
          cost_so_far.put(successors[j], new_cost);
          priority.put(successors[j], new_cost+heuristics(dest, successors[j]));
          front.offer(successors[j]);
          came_from.put(successors[j], current);
        }
      }
      //print(current);
    }
    //print(current);
   knight.position = came_from.get(current);
   //knight.show(knight.position);
    //delay(100);
    //redraw();
    // stroke(255);
    //knight_sprite.resize(50, 50);
    //image(knight_sprite, came_from.get(current).x - knight_sprite.width/2, came_from.get(current).y - knight_sprite.height/2);
    //update();
  }
  //Collections.sort(front, new Sortbyroll()); 
  return came_from;
}

void GameOver() {
  //clear();
  textSize(64);
  text("win", 250, 200); 
  fill(200, 200, 200);
}
