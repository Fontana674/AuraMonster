Player p;
ArrayList<Nemico> nemici;
ArrayList<Piattaforma> pl;
Boss b;
int restartCount, restartCountDef;
int parryEffect=0;

void setup() {
  size(1200, 720);
  rectMode(CENTER);
  p=new Player();
  b=new Boss();
  nemici=new ArrayList<Nemico>();
  nemici.add(b);
  //nemici.add(new Nemico(500, 600-20, 30, 40, 10, 1000));
  background(255);
  pl= new ArrayList<Piattaforma>();
  pl.add(new Piattaforma(width/2, height, width, 10, true));
  pl.add(new Piattaforma(120, 500, 180, 20, false));
  pl.add(new Piattaforma(200, 300, 160, 20, false));
  //pl.add(new Piattaforma(700, 250, 200, 20, false));
  pl.add(new Piattaforma(650, 390, 120, 20, false));
  pl.add(new Piattaforma(400, 500, 120, 20, false));
  restartCountDef=90;
  restartCount=restartCountDef;
}

void draw() {
  if(parryEffect<0){
  background(255);
  imageMode(CENTER);
  if (p.hp>0&&b.hp>0) {
    for (int i=0; i<pl.size(); i++) {
      pl.get(i).show();
    }
    for (int i=0; i<pl.size(); i++) {
      pl.get(i).collidi(p);
      if (!p.inAir) break;
    }

    p.update(nemici, b);
    for (int i= nemici.size()-1; i>=0; i--) {
      nemici.get(i).update();
    }

    b.update(p, nemici);
    if (p.hp<0) {
      stroke(255, 0, 0);
      circle(width, height, 100);
    }
  } else {
    textAlign(CENTER);
    textSize(200);
    if (p.hp>0) {
      fill(0, 255, 0);
      text("YOU WIN", width/2, height/2);
    } else {
      fill(255, 0, 0);
      text("YOU LOSE", width/2, height/2);
    }
    textSize(50);
    text("hold r to restart", width/2, height/2+100);
  }

  if (restartCount<0) {
    rectMode(CENTER);
    p=new Player();
    b=new Boss();
    nemici=new ArrayList<Nemico>();
    nemici.add(b);
    //nemici.add(new Nemico(500, 600-20, 30, 40, 10, 1000));
    background(255);
    pl= new ArrayList<Piattaforma>();
    pl.add(new Piattaforma(width/2, height, width, 10, true));
    pl.add(new Piattaforma(120, 500, 180, 20, false));
    pl.add(new Piattaforma(200, 300, 160, 20, false));
    //pl.add(new Piattaforma(700, 250, 200, 20, false));
    pl.add(new Piattaforma(650, 390, 120, 20, false));
    pl.add(new Piattaforma(400, 500, 120, 20, false));
    restartCount=restartCountDef;
  }

  if (p.r) restartCount--;
  else restartCount=restartCountDef;
  }
  parryEffect-=1;
}

void keyPressed() {
  p.checkKey(true);
  if (p.e&&p.k.inHand) {
    p.parry();
  } else if (!p.isParrying) {
    if (p.ranged) {
      p.lancia();
    } else {
      p.melee();
    }
  }
}


void keyReleased() {
  p.checkKey(false);
}

//if checkq and pressq  cambiamod()
