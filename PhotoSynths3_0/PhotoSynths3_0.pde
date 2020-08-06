float maxLength = 50;
int maxK = 10;
boolean grow = false;
boolean reset = false;
float light = 0.5;
int itemCount = 0;
Synth main;
Collision mouse;
ArrayList <Collision> collisions;

void setup() {
  mouse = new Collision(100);
  size(1280,720);
  frameRate(50);
  main = new Synth(width/2, height/2, maxK);
  //main.updateSynth(light);
  //collisions.add(mouse);
}
void draw() {
  background(255);
  fill(0);
  collisions = new ArrayList<Collision>();
  mouse.update(mouseX,mouseY);
  collisions.add(mouse);
  if (reset == true) {
    itemCount = 0;
    main = new Synth(width/2, height/2, maxK);
    main.updateSynth(light);
    reset = false;
  }
  if (grow == true) {
    main.updateSynth(light);
 
  }
  mouse.drawMouse();
  main.drawSynth();
  
}

boolean coin() {
  return boolean(int(random(2)));
}

void keyPressed() {
  if (key == ' ') {
    if (grow == true) {
      grow = false;
    } else {
      grow =  true;
    }
  } else if (key == 'r') {
    reset = true;
  }
}
