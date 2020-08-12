class Collision { 
  PVector pos;
  float radius;
  boolean present;
  Collision(float inradius) {
    radius = inradius;
    pos = new PVector();
  }
  void update(float x, float y) {
    pos.x = x;
    pos.y = y;
  }
  void drawCol() {
    if (present) {
      fill(0);
      ellipse(pos.x, pos.y, radius*2, radius*2);
    }
  }
}
void setupBackground() {
  adjHeight = (512/float(width))*float(height);
  //println(adjHeight);
  bGround = createImage(512, round(adjHeight), RGB);
  //setup collision array
  nX = 512/32 + 1;
  nY = round(adjHeight/32) + 1;
  collisions = new Collision[nX][nY];
  //println(nX, nY);
  for (int x = 0; x<nX; x++) {
    for (int y = 0; y<nY; y++) {
      collisions[x][y] = new Collision(map(16, 0, 512, 0, width)*1.4);
      collisions[x][y].update(map(x, 0, nX-1, 0, width), map(y, 0, nY-1, 0, height));
      //println(collisions[x][y].pos.x, collisions[x][y].pos.y);
    }
  }
  //float xratio = float(width)/512;
  //float yratio = float(height)/adjHeight;
}

void drawBackground(int[] inImg) {
  imageMode(CORNER);
  image(bGround, 0, 0, width, height);
  //println(inImg.length,bGround.pixels.length);
  bGround.loadPixels();
  for (int x = 0; x<512; x++) {
    for (int y = 0; y<round(adjHeight); y++) {
      int loc = x+ y*512;
      int dpth = inImg[loc];
      int xCol = int(map(x, 0, 512, 0, nX-1));
      int yCol = int(map(y, 0, adjHeight, 0, nY-1));
      if (dpth < 2000) { 
        if (x%32 == 0 && y%32 == 0) {
          collisions[xCol][yCol].present = true;
        }
        bGround.pixels[loc] = color(0);
        //println(loc);
      } else {
        if (x%32 == 0 && y%32 == 0) {
          collisions[xCol][yCol].present = false;
        }
        bGround.pixels[loc] = color(255);
      }
    }
  }
  bGround.updatePixels();
}
