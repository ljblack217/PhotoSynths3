void audioSetup(){
  sound = new AudioContext();
  chew = new SamplePlayer[5];
  cracks = new SamplePlayer[4];
  //g1 for chews
  g1 = new Gain(sound, 1,0.1);
  //g2 for cracks
  g2 = new Gain(sound, 1, 0.1);
  for(int c = 0; c<5; c++){
    chew[c] = new SamplePlayer(sound, SampleManager.sample(dataPath("")+"/chew"+c+".wav"));
    chew[c].setKillOnEnd(false);
    chew[c].setToEnd();
    g1.addInput(chew[c]);
  }
  for(int k = 0; k < 4; k++){
    cracks[k] = new SamplePlayer(sound, SampleManager.sample(dataPath("")+"/knuckle"+k+".wav"));
    cracks[k].setKillOnEnd(false);
    cracks[k].setToEnd();
    g2.addInput(cracks[k]);
  }
  sound.out.addInput(g1);
  sound.out.addInput(g2);
  sound.start();
}
void touchSound(){
  if(int(random(20)) == 0){
    playChew(int(random(5)));
  }
}
void retreat(){
  if(int(random(100))==0){
    playChew(int(random(5)));
  }
  if(int(random(20))==0){
    int c = int(random(4));
    cracks[c].setToLoopStart();
    cracks[c].start();
  }
}

void playChew(int sel){
  chew[sel].setToLoopStart();
  chew[sel].start();
}
