public class Boss extends Nemico {
  ArrayList<Colpo> colpi;
  float countColpo;
  float countColpoMax;
  Boolean fase2a;
  float countFase; //frame mancanti alla fine della fase
  int fase; //numero fase attuale 0=colpi mirati, 1=colpi orizzontali, 2 tanti colpi in riga, 3 anaconda
  int lastSprite;
  PImage sprite;
  BarraVita barra;
  Anaconda a;
  int countMuro3;
  boolean isCaricando3;

  public Boss() {
    super(width-100, height/2, 300, height, 100, 1000);
    this.colpi= new ArrayList<Colpo>();
    this.countColpoMax=20;
    this.countColpo=this.countColpoMax;
    this.sprite=loadImage("mranaconda.png");
    this.barra= new BarraVita(this);
    this.a=null;
    this.fase=0;
    this.countFase=500;
    this.countMuro3=150;
    this.isCaricando3=false;
    this.hp=maxHp;
    fase2a=false;
  }

  public void update(Player p, ArrayList<Nemico> n ) {
    println(this.countColpo);
    this.attacco(p, n);
    this.checkProiettili();
    this.barra.update(this);
    this.skin();
  }

  public void show() {
    image(this.sprite, this.x, this.y, this.l, this.h);
  }

  public void spara(Player p) {
    this.countColpo--;
    if (this.countColpo<=0) {
      this.countColpo=this.countColpoMax;
      this.colpi.add(new Colpo(p, this));
    }
  }

  public void spara(Player p, float y) {
    this.countColpo--;
    float yf=y;
    do {
      yf=random(y-150, y+150);
    } while (yf<50||yf>height-50);
    if (this.countColpo<=0) {
      this.countColpo=this.countColpoMax;
      this.colpi.add(new Colpo(p, this, -10, 0, yf));
    }
  }

  public void sparaNc(Player p, float y) {
    this.colpi.add(new Colpo(p, this, -20, 0, y));
  }
  public void sparaNc(Player p, float y, float r, float danno) {
    this.colpi.add(new Colpo(p, this, -20, 0, y, r, danno)); //Player vittimaIn, Nemico shooterIn, float vxIn, float vyIn, float yIn, float r, float dannoIn
  }

  public void checkProiettili() {
    for (int i=this.colpi.size()-1; i>=0; i--) {
      this.colpi.get(i).update();
      if (this.colpi.get(i).isOver) this.colpi.remove(i);
    }
  }

  public void attacco(Player p, ArrayList<Nemico> n) {
    if (this.countFase>0) {
      switch(this.fase) {
      case 0:
        this.fase0(p);
        break;

      case 1:
        this.fase1(p);
        break;

      case 2:
        this.fase2(p);
        break;

      case 3:
        this.fase3(p, n);
        break;
      }
    }
    this.countFase--;
    if (this.hp<this.maxHp/2){
      this.fase=3;
      this.countFase=10;
    }
    if (this.countFase<=0&&this.colpi.size()==0) {
      this.fase++;
      if(this.fase>2&&!(this.hp<this.maxHp/2)) this.fase=0;
      if (this.hp<this.maxHp/2) this.fase=3;
      switch(this.fase) {
      case 0:
        this.countFase=random(200, 500);
        break;

      case 1:
        this.countFase=random(200, 500);
        break;

      case 2:
        this.countColpo=random(200, 300);
        this.countFase=random(1000, 2000);
        break;

      case 3:
        this.countFase=2000;
        break;
      }
      if (this.fase!=3&&this.a!=null) {
        nemici.remove(a);
        this.a=null;
      }
    }
  }

  /*public void attacco(Player p, ArrayList<Nemico> n) {
   if (this.countFase>0) {
   switch(this.fase) {
   case 0:
   this.fase0(p);
   break;
   
   case 1:
   this.fase1(p);
   break;
   
   case 2:
   this.fase2(p);
   break;
   
   case 3:
   this.fase3(p, n);
   break;
   }
   }
   if (this.fase<2)this.countFase--;
   if (this.countFase<=0&&this.colpi.size()==0&&this.hp>70*this.maxHp/100) {
   this.fase=(int) random(3);
   this.countFase=random(200, 400);
   if (this.fase==2) this.countColpo=100;
   
   if (this.fase!=3&&this.a!=null) {
   nemici.remove(a);
   this.a=null;
   }
   }
  /*if (this.hp<70*this.maxHp/100) {
   this.fase=2;
   if (!this.fase2a) {
   this.countColpo=30;
   this.fase2a=true;
   }
   this.countFase=-2000;
   }
   if (this.hp<this.maxHp/2) this.fase=3;
   }*/

  public void fase0(Player p) { //spara mirato
    this.spara(p);
  }

  public void fase1(Player p) {
    this.spara(p, p.y);
  }

  public void fase2(Player p) {

    float r = 40;

    this.countColpo--;
    if (this.countColpo <= 0) {

      for (float i = r; i < height; i += r) {
        this.sparaNc(p, i, r/2, 40);
      }
      this.countColpo = 150;
    }

    // timer durata fase
    this.countFase--;
  }
  public void fase3(Player p, ArrayList<Nemico> n) {

    /*float r=40;
     if (int(random(60))==1) {
     for (float i=r; i<height; i+=r) {
     this.sparaNc(p, i, r/2, 40);
     }
     }*/
    if (int(random(800))==1) this.isCaricando3=true;
    this.muroColpi3();
    if (int(random(200))==1) this.sparaNc(p, p.y);
    if (a!=null) {
      if (this.a.isOver) {
        n.remove(a);
        this.a=null;
      }
    }
    if (this.a==null) {
      this.a=new Anaconda(p.y, this, -15);
      n.add(this.a);
    }
  }

  public int spriteNow() { //0 base,1 telegrafa
    if (this.fase==2&&this.colpi.size()==0 || isCaricando3) return 1;
    return 0;
  }

  public void skin() {
    int spriteNow= this.spriteNow();
    if (this.lastSprite!=spriteNow) {
      switch(spriteNow) {
      case 0:
        this.sprite=loadImage("mranaconda.png");
        break;
      case 1:
        this.sprite=loadImage("mranacondaTele.png");
        break;
      }
    }
    this.lastSprite=spriteNow;
  }


  public void muroColpi3() {
    if (isCaricando3) {
      this.countMuro3--;
      if (this.countMuro3<0) {
        float r=40;
        for (float i=r; i<height; i+=r) {
          this.sparaNc(p, i, r/2, 40);
        }
        this.countMuro3=150;
        this.isCaricando3=false;
      }
    }
  }
}
