class Synth {
  ArrayList<Knuckle> branches;
  FloatList branchAngles;
  PVector center;
  PVector  velocity, acceleration, pos;
  Synth(float x, float y, int knuckleMax) {
    branchAngles = new FloatList();
    center = new PVector(x, y);
    pos = center.copy();
    int knStart = int(random(3)+3); 
    branches = new ArrayList<Knuckle>();
    for (int s = 0; s<knStart; s++) {
      branches.add(new Knuckle(knuckleMax, 0));
      branchAngles.append(radians(((360/knStart)*s)+random(45)));
    }
  }
  void updateSynth(float inlight) {
    boolean shifted = false;
    int i = 0;
    for (Knuckle current : branches) {
      //println(branchAngles.size());
      //float test = branchAngles.get(i);
      current.update(inlight, branchAngles.get(i),pos, center);
      i++;
    }
    for (Collision check : collisions) {
      if (check.pos.dist(pos)<check.radius) {
        PVector move = new PVector(1, 0);
        PVector repos = new PVector();
        repos = pos.copy();
        repos.sub(check.pos);
        move.rotate(repos.heading());
        pos.add(move);
        shifted = true;
      }else if(check.pos.dist(pos)<check.radius + 1){
        shifted = true;
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
    for (Knuckle drawing : branches) {
      drawing.drawKnuckle();
    }
  }
}

class Knuckle {
  float angle, gAng, chAng;
  float len;
  float rad = 10;
  int max;
  PVector start, end;
  ArrayList<Knuckle> children;
  boolean shifted = false;
  float rewrap;
  int imgID;
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
  void update(float light, float pAngle, PVector parent,PVector center) {
  //boolean distant = true;
    //update location
    
    if (rewrap>1){
      rewrap -= 1;
    }
    start = parent;
    angle += chAng;
    chAng = 0;
    end.x = start.x + cos(pAngle+angle+gAng) * len;
    end.y = start.y + sin(pAngle+angle+gAng) * len;
    //collision
    for (Collision check : collisions) {
      if (check.pos.dist(end) < rad+check.radius) {
        shifted = true;
        rewrap = 500;
        if (clockWise(check.pos, end, start, pAngle+angle)) {
          chAng -= radians(1);
          
        } else {
          chAng += radians(1);
          
        }
      } if (check.pos.dist(end) < rad+check.radius + 1) {
        rewrap = 500;
        shifted = true;
      }
    } 

    if (shifted == false && (angle<radians(-1) || angle>radians(1))) {
      if (angle<0) {
        chAng += radians(1/rewrap);
      } else if (angle>0) {
        chAng -= radians(1/rewrap);
      } 
    }
    //wrap
    
    
    
    
    //grow
    if (len<maxLength) {
      len += light;
    } else if (max>0) {
      if (children.size()==0) {
        children.add(new Knuckle(max, 0));
      }
      if (random(5000/max) < light*2 && itemCount<150) {
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
        child.update(light, pAngle+angle+gAng, end,center);
      }
    }
    shifted = false;
  }

  void drawKnuckle() {
    if (children.size()>0) {
      for (Knuckle child : children) {
        child.drawKnuckle();
      }
    }
    
    fill(255);
    stroke(0);
    line(end.x, end.y, start.x, start.y);
    ellipse(end.x, end.y, rad*2, rad*2);
    fill(0);
    
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
