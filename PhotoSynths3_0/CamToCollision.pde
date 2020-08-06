class Collision{ 
  PVector pos;
  float radius;
  Collision(float inradius){
    radius = inradius;
    pos = new PVector();
  }
  void update(float x, float y){
    pos.x = x;
    pos.y = y;
  }
  void drawMouse(){
    fill(0);
    ellipse(pos.x,pos.y,radius*2,radius*2);
  }
}
