float maxLength = 70;
int maxK = 6;
boolean grow = false;
boolean reset = false;
float light = 0.5;
int itemCount = 0;
Synth main;
Collision mouse;
ArrayList <Collision> collisions;
PImage[] fingers;
PImage body;

void setup() {
  imageMode(CENTER);
  fingers = new PImage[6];
  for(int i = 0; i<6; i++){
   fingers[i] = loadImage("Finger"+i+".png");
   fingers[i].resize(0,int(maxLength*1.4));
  }
  body = loadImage("middle.png");
   size(1280,720);
  
  body.resize(150,0);
  mouse = new Collision(100);
 
  frameRate(25);
  main = new Synth(width/2, height/2, maxK);
  //main.updateSynth(light);
  //collisions.add(mouse);
}
void draw() {
  frame.setTitle(str(frameRate));
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
