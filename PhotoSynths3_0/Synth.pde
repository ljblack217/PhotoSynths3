class Synth {
  ArrayList<Knuckle> branches;
  FloatList branchAngles;
  IntList branchlife;
  PVector center;
  PVector  velocity, acceleration, pos;
  Synth(float x, float y, int knuckleMax) {
    branchAngles = new FloatList();
    branchlife = new IntList();
    center = new PVector(x, y);
    pos = center.copy();
    int knStart = 5; 
    branches = new ArrayList<Knuckle>();
    for (int s = 0; s<knStart; s++) {
      branches.add(new Knuckle(knuckleMax, 0));
      branchAngles.append(radians(((360/knStart)*s)+random(45)));
      branchlife.append(int(random(50*frameRate, 200*frameRate)));
    }
  }
  void updateSynth(float inlight) {
    boolean shifted = false;
    int i = 0;
    int del = -1;
    for (Knuckle current : branches) {
      //println(branchAngles.size());
      //float test = branchAngles.get(i);
      current.update(inlight, branchAngles.get(i), pos, center);
      if (branchlife.get(i) >0) {
        branchlife.sub(i, 1);
      } else {
        current.dead = true;
        if (current.deadY>height*2.5) {
          println(current.childrenCheck(), itemCount);
          itemCount -= current.childrenCheck()+1;
          println(itemCount);
          branches.set(i, new Knuckle(maxK, 0));
          branchAngles.set(i, radians(((360/5)*i )+random(45)));
          branchlife.set(i, int(random(40*frameRate, 160*frameRate)));
          println("del");
          del = i;
        }
      }
      i++;
    }
    if (del>-1) {
    }
    if (mouseOn) {
      if (mouse.pos.dist(pos)<mouse.radius+125/2) {
        PVector move = new PVector(1, 0);
        PVector repos = new PVector();
        repos = pos.copy();
        repos.sub(mouse.pos);
        move.rotate(repos.heading());
        pos.add(move);
        shifted = true;
      } else if (mouse.pos.dist(pos)<mouse.radius + 1) {
        shifted = true;
      }
    }
    for (int x = 0; x<nX; x++) {
      for (int y = 0; y<nY; y++) {
        if (collisions[x][y].present == true) {
          if (collisions[x][y].pos.dist(pos) < 120+collisions[x][y].radius) {
            PVector move = new PVector(1, 0);
            PVector repos = new PVector();
            repos = pos.copy();
            repos.sub(collisions[x][y].pos);
            move.rotate(repos.heading());
            pos.add(move);
            shifted = true;
          } else if ((collisions[x][y].pos.dist(pos) < 120+collisions[x][y].radius+1)) {
            shifted = true;
          }
        }
      }
    }

    if (shifted != true) {
      //println(pos.dist(center)); 
      if (pos.dist(center)>2) {


        PVector move = new PVector(1, 0);
        PVector repos = center.copy();
        repos.sub(pos);
        move.rotate(repos.heading());
        pos.add(move);
      }
    }
  }
  void drawSynth() {
    int n = 0;
    //ellipseMode(CENTER);
    for (Knuckle drawing : branches) {
      drawing.drawKnuckle(branchAngles.get(n));
      n++;
    }
    if (skin) {
      image(body, pos.x, pos.y);
    }
    //ellipse(width/2,height/2, 150,150);
  }
}

class Knuckle {
  float angle, gAng, chAng;
  float len;
  float rad = 16;
  int max;
  PVector start, end;
  ArrayList<Knuckle> children;
  boolean shifted = false;
  float rewrap;
  int imgID;
  boolean preTouched = false;
  boolean dead;
  float deadY = 0;
  boolean dead1 = true;
  Knuckle(int inMax, float in) {
    start = new PVector();
    end = new PVector();
    max = inMax - 1;
    itemCount++;
    len = 0;
    gAng = in;
    angle = 0;
    children = new ArrayList<Knuckle>();
    rewrap = 0;
    imgID = int(random(6));
  }
  void update(float light, float pAngle, PVector parent, PVector center) {
    //boolean distant = true;
    //update location

    if (rewrap>2) {
      rewrap -= 1;
    }
    start = parent.copy();
    start.y += deadY;

    angle += chAng;
    if (preTouched == false) {
      chAng = 0;
    } else {
      touchSound();
    }
    if (dead) { 
      deadY = deadY*1.1 + 1;
      if (dead1) {
        dead1 = false;
        crunchPlay();
      }
    }
    end.x = start.x + cos(pAngle+angle+gAng) * len;
    end.y = start.y + sin(pAngle+angle+gAng) * len;
    //collision
    boolean touched = false;
    for (int x = 0; x<nX; x++) {
      for (int y = 0; y<nY; y++) {
        if (collisions[x][y].present == true) {
          if (collisions[x][y].pos.dist(end) < rad+collisions[x][y].radius) {
            shifted = true;
            rewrap = 250;
            if (preTouched == false) {

              if (clockWise(collisions[x][y].pos, end, start, pAngle+angle)) {
                chAng -= radians(1);
              } else {
                chAng += radians(1);
              }
            }
            touched = true;
          } 
          if (collisions[x][y].pos.dist(end) < rad+collisions[x][y].radius + 1) {
            rewrap = 500;
            shifted = true;
          }
        }
      }
    } 
    preTouched = touched;

    if (shifted == false && (angle<radians(-1) || angle>radians(1))) {
      if (rewrap <20 ) retreat();
      if (angle<0) {
        chAng += radians(1/rewrap);
      } else if (angle>0) {
        chAng -= radians(1/rewrap);
      }
    }
    //grow
    if (len<maxLength) {
      len += light;
    } else if (max>0) {
      if (children.size()==0 && itemCount<70) {
        children.add(new Knuckle(max, 0));
      }
      if (random(5000/max) < light*2 && itemCount<70) {
        if (children.size()<2) {
          float bAngle;
          if (coin()) {
            bAngle = radians(random(20, 75));
          } else {
            bAngle = -radians(random(20, 75));
          }
          children.add(new Knuckle(max, bAngle));
        }
      }
    }
    //children
    if (children.size()>0) {
      for (Knuckle child : children) {
        child.update(light, pAngle+angle+gAng, end, center);
      }
    }
    shifted = false;
  }

  void drawKnuckle(float pAngle) {
    imageMode(CENTER);
    if (children.size()>0) {
      for (Knuckle child : children) {

        child.drawKnuckle(pAngle+angle+gAng);
      }
    }



    if (len>=1) {
      if (skin) {
        pushMatrix();
        translate(start.x, start.y);
        //println(start.x, start.y);
        rotate(pAngle+angle+gAng+radians(90));
        PImage finger = fingers[imgID];

        //finger.resize(0, int(len));
        float wid = len*0.352;
        image(finger, 0, -len*1.3/2, wid*1.3, len*1.3);
        popMatrix();
      } else {

        fill(255);
        stroke(0);
        line(end.x, end.y, start.x, start.y);
        ellipse(end.x, end.y, rad*2, rad*2);
        fill(0);
      }
    }
  }
  int childrenCheck() {
    int num = 0;
    if (children.size()>0) {
      for (Knuckle child : children) {
        num = num + child.childrenCheck();
        num ++;
      }
    }
    return num;
  }
}

boolean clockWise(PVector col, PVector end, PVector start, float angle) {
  boolean yes;
  //PVector checkStart = start.copy();
  PVector checkCol = col.copy();
  //checkStart.sub(end);
  checkCol.sub(end);
  //checkStart.rotate(-angle);
  checkCol.rotate(-angle);
  if (checkCol.heading()>0) {
    yes = true;
  } else {
    yes = false;
  }
  return yes;
}
