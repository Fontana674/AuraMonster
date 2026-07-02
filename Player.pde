public class Player extends Entita {
  boolean w, s, a, d, q, e, up, down, left, right, r;
  boolean inAir = true;
  boolean doubleJump=false;
  float vx, vy;
  int bordo=5;
  boolean ranged=true;
  int lastSprite=1; //1 no katana, 2 ranged, 3 melee, 4 attacco destra,5 attacco sinistra, 6 attacco alto, 7 attacco basso,
  boolean lastQ;
  float range;
  int delayAttacco=0, delayRanged=10, delayMelee=20;
  Hitbox hitBox;
  boolean guardaSx=true;
  int hp, maxHp;
  PImage sprite;
  int frameInv;
  int frameInvAttuali;
  Katana k;
  Boolean isParrying=false;
  Boolean hasParried=false;
  float countParry; //quanto manca a poter fare il parry
  float countParryM;

  float countFineParry; //quanto manca alla fine del parry
  float countFineParryM;
  BarraVita b;
  float dannoMelee, dannoRange;
  float aura;
  //Boolean onPlatform=false;

  public Player() {
    super(width/2, height-90, 90, 90);
    this.vx = 5;
    this.vy = 0;
    this.k=new Katana(this);
    this.range=60;
    this.maxHp=400;
    this.hp=this.maxHp;
    this.sprite=loadImage("mrauralancio.png");
    this.frameInv=30;
    this.frameInvAttuali=0;

    this.countFineParryM=10;
    this.countFineParry=0;

    this.countParryM=50;
    this.countParry=0;

    this.dannoMelee=20;
    this.dannoRange=40;
    b=new BarraVita(this);
    this.aura=500;
  }

  void update(ArrayList<Nemico> nemici, Boss boss) {
    this.moveAura(boss);
    this.k.update(this, boss);
    this.cambiaMod();
    if (this.hitBox!=null) {
      this.hitBox.update(this);
      if (this.hitBox.count<=0) this.hitBox=null;
    }
    this.delayAttacco--;
    this.frameInvAttuali--;
    this.colpisciNemici(nemici);
    b.update(p);
    this.show();
    this.gestoreParry();

    //println("is para "+this.isParrying);
    /*
    if (!this.lastRanged==ranged) {
     if (ranged) {
     this.sprite=loadImage("mrauralancio.png");
     } else {
     this.sprite=loadImage("mrauramelee.png");
     }
     }*/
  }

  void show() {
    this.skin();
    stroke(0);
    if (this.a && !this.d) this.guardaSx=true;
    else if (this.d) this.guardaSx=false;
    if (this.guardaSx) {
      pushMatrix();
      translate(this.x, this.y);
      scale(-1, 1);
      rectMode(CENTER);
      //rect(this.x, this.y, this.l, this.h);
      imageMode(CENTER);
      image(sprite, 0, 0, this.l, this.h);
      popMatrix();
    } else {
      rectMode(CENTER);
      imageMode(CENTER);
      //rect(this.x, this.y, this.l, this.h);
      image(sprite, this.x, this.y, this.l, this.h);
    }
  }

  void checkKey(boolean result) {
    if (key == 'W' || key == 'w') this.w = result;
    if (key == 'A' || key == 'a') this.a = result;
    if (key == 'S' || key == 's') this.s = result;
    if (key == 'D' || key == 'd') this.d = result;
    if (key == 'Q' || key == 'q') this.q = result;
    if (key == 'E' || key == 'e') this.e = result;
    if (key == 'R' || key == 'r') this.r = result;

    if (keyCode == UP) this.up = result;
    if (keyCode == LEFT) this.left = result;
    if (keyCode == DOWN) this.down = result;
    if (keyCode == RIGHT) this.right = result;
  }

  void moveMilano() {
    if (w && this.y>this.h/2+bordo) this.y-=5;
    if (s && this.y<height-this.h/2-bordo) this.y+=5;
    if (d && this.x<width-this.l/2-bordo) this.x+=15;
    if (a && this.x>this.l/2+bordo) this.x-=15;
  }

  void moveAura(Boss b) {
    if (inAir) {
      this.vy += 0.6;
    } else vy=0;
    if (!this.inAir) {
      this.vy = 0;
      this.doubleJump=false;
    }
    if (this.w && !this.inAir) {
      this.vy-=17;
      this.inAir = true;
    }
    if ((this.inAir && !this.w) && !doubleJump) {
      if (this.vy<0) this.vy=0;
    }
    if (this.d && this.x < width - this.l/2 - this.bordo) this.x += this.vx;
    if (this.a && this.x > this.l / 2 + this.bordo) this.x -= this.vx;
    if (this.y-this.h/2<=0){
      this.y=this.h/2+this.bordo;
      this.vy=0;
    }
    this.y += this.vy;
    if (this.collide(b)) {
      this.x-=5;
    }
  }


  void lancia() {
    if (this.delayAttacco<0) {
      if (this.right&&this.k.inHand) {
        this.k.inHand=false;
        this.k.vx=15;
        this.k.vy=0;
        this.delayAttacco=this.delayRanged;
      } else if (this.left&&this.k.inHand) {
        this.k.inHand=false;
        this.k.vx=-15;
        this.k.vy=0;
        this.delayAttacco=this.delayRanged;
      } else if (this.down&&this.k.inHand) {
        this.k.inHand=false;
        this.k.vx=0;
        this.k.vy=15;
        this.inAir=true;
        this.doubleJump=true;
        this.delayAttacco=this.delayRanged;
        if (this.vy>0) this.vy=0;
        this.vy=-15;
      } else if (this.up&&this.k.inHand) {
        this.k.inHand=false;
        this.k.vx=0;
        this.k.vy=-15;
        this.delayAttacco=this.delayRanged;
      }
    }
  }

  void melee() {
    if (this.delayAttacco<0) {
      if (hitBox==null&&this.k.inHand) {
        if (this.right) {
          this.hitBox = new Hitbox(this.x+this.l/2+this.range/2, this.y, this.range, this.h, 1);
          this.delayAttacco=this.delayMelee;
        } else if (this.left) {
          this.hitBox = new Hitbox(this.x-this.l/2-this.range/2, this.y, this.range, this.h, 3);
          this.delayAttacco=this.delayMelee;
        } else if (this.down && this.inAir) {
          this.hitBox = new Hitbox(this.x, this.y+this.l/2+this.range/2, this.h, this.range, 4);
          this.delayAttacco=this.delayMelee;
        } else if (this.up) {
          this.hitBox = new Hitbox(this.x, this.y-this.l/2-this.range/2, this.h, this.range, 2);
          this.delayAttacco=this.delayMelee;
        }
      }
    }
  }

  void cambiaMod() {
    if (this.q&&!this.lastQ&&k.inHand) {
      this.ranged=!this.ranged;
    }
    this.lastQ=this.q;
  }

  void colpisciNemici(ArrayList<Nemico> nemici) {
    for (int i= nemici.size()-1; i>=0; i--) {
      if (this.hitBox!=null) {
        if (this.hitBox.collide(nemici.get(i)) && nemici.get(i).frameInvAttuali<0) {
          nemici.get(i).frameInvAttuali=nemici.get(i).frameInv;
          nemici.get(i).hp-=this.dannoMelee;
          if (this.hitBox.direzione==4) {
            this.vy=-14;
            this.doubleJump=true;
            this.aura+=200;
          }
          this.aura+=100;
        }
      } else if (!this.k.inHand && (!this.k.stepSister || this.k.count<=0)) {
        if (this.k.collide(nemici.get(i)) && nemici.get(i).frameInvAttuali<0) {
          nemici.get(i).frameInvAttuali=nemici.get(i).frameInv;
          nemici.get(i).hp-=this.dannoRange;
          this.aura+=150;
        }
      }
      if (nemici.get(i).hp<=0) {
        nemici.remove(i);
      }
    }
    /*for (int i=0; i<nemici.size(); i++) {
     println(nemici.get(i).hp);
     }*/
  }

  public void parry() {
    if (!isParrying && countParry <= 0) {
      isParrying = true;
      countFineParry = countFineParryM;
    } else {
      isParrying=false;
      countParry = countParryM;
    }
  }

  public void gestoreParry() {
    if (isParrying) {
      countFineParry--;
      noFill();
      stroke(0, 255, 0);
      circle(this.x, this.y, this.l+30);
      if (countFineParry <= 0) {
        isParrying = false;
        if (this.hasParried){ 
          countParry = 5;
      } // parte cooldown
        else this.countParry=this.countParryM;
        this.hasParried=false;
        this.frameInvAttuali=this.frameInv/2;
      }
    } else {
      if (countParry > 0) {
        countParry--;
      }
    }
  }

  int spriteNow() { //0 no katana, 1 ranged, 2 melee, 3 attacco destra, 4 attacco sinistra, 5 attacco alto mentre sale, 6 att alto mentre scende, 7 att basso mentre sale, 8 att basso mentre scende //parry
    if (!this.k.inHand) return 0;
    if (this.isParrying) return 9;
    if (this.ranged) return 1;
    if (this.hitBox!=null) {
      switch(this.hitBox.direzione) {
      case 1:
        if (this.guardaSx) return 4;
        return 3;

      case 2:
        if (this.vy>=0) return 6;
        else return 5;
      case 3:
        if (this.guardaSx) return 3;
        return 4;

      case 4:
        if (this.vy>=0) return 8;
        else return 7;
      }
    }

    return 2;
  }


  void skin() {
    int spriteNow=this.spriteNow();
    if (spriteNow!=this.lastSprite) {
      switch(spriteNow) {
      case 0:
        this.sprite=loadImage("mrauraNoKat.png");
        break;

      case 1:
        this.sprite=loadImage("mrauralancio.png");
        break;

      case 2:
        this.sprite=loadImage("mrauramelee.png");
        break;

      case 3:
        this.sprite=loadImage("mrauraAttD.png");
        break;

      case 4:
        this.sprite=loadImage("mrauraAttS.png");
        break;

      case 5:
        this.sprite=loadImage("mrauraAttAltoS.png");
        break;
      case 6:
        this.sprite=loadImage("mrauraAttAltoG.png");
        break;
      case 7:
        this.sprite=loadImage("mrauraAttBassoS.png");
        break;
      case 8:
        this.sprite=loadImage("mrauraAttBassoG.png");
        break;
      case 9:
        this.sprite=loadImage("mrparry.png");
        break;
      }
    }
    this.lastSprite=spriteNow;
  }
}
