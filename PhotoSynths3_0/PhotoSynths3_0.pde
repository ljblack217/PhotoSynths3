import KinectPV2.*;
import java.nio.*;
import java.util.ArrayList;
import beads.*;
PImage bGround;

float adjHeight;

KinectPV2 kinect;

int maxDis = 2000;
int nY;
int nX;

//defaults
float maxLength = 100;
int maxK = 6;
boolean grow = false;
boolean reset = false;
float light = 0.5;
int itemCount = 0;
Synth main;
Collision mouse;

//assets
PImage[] fingers;
PImage body;
boolean mouseOn = false;
boolean skin = true;

//audio
AudioContext sound;
Gain g1;
Gain g2;
Gain g3;

SamplePlayer crunch;
SamplePlayer[] chew;
SamplePlayer[] cracks;

Collision[][] collisions;
void setup() {
  
  
  kinect = new KinectPV2(this);
  kinect.enableDepthImg(true);
  kinect.enablePointCloud(true);
  kinect.init();
  fingers = new PImage[6];
  for (int i = 0; i<6; i++) {
    fingers[i] = loadImage("Finger"+i+".png");
    fingers[i].resize(0, int(maxLength*1.4));
  }
  body = loadImage("middle.png");
  //size(1280, 720, P3D);
  fullScreen(P2D);
  body.resize(150, 0);
  mouse = new Collision(100);

  frameRate(50);
  main = new Synth(width/2, height/2, maxK);
  //main.updateSynth(light);
  //collisions.add(mouse);
  setupBackground();
  
  audioSetup();
  
}
void draw() {
  //PImage pointConvert = image();

  surface.setTitle(str(frameRate));
  background(0);
  fill(0);
  mouse.update(mouseX, mouseY);
  drawBackground(kinect.getRawDepthData());

  if (reset == true) {
    itemCount = 0;
    main = new Synth(width/2, height/2, maxK);
    main.updateSynth(light);
    reset = false;
  }
  if (grow == true) {
    main.updateSynth(light);
  }
  if (mouseOn) {
    mouse.drawCol();
  }

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
  } else if (key == 's') {
    if (skin) {
      skin = false;
    } else {
      skin = true;
    }
  } else if (key == 'm') {
    if (mouseOn) {
      mouseOn = false;
    } else {
      mouseOn = true;
    }
  }
}
