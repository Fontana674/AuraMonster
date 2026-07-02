public class Anaconda extends Nemico {
  float vx;
  Boolean isOver;
  Boolean comeBack;
  
  float countS; //frame in cui sta ferma
  float countStart;//frame in cui sta ferma all'inizio
  float countCb; //frame in cui sta ferma al bordo
  Boss maestro;
  PImage corpo;
  PImage testa;
  float lt;
  float ht;

  public Anaconda(float y, Boss maestroIn, float vxIn) {
    super(maestroIn.x-maestroIn.l/2+50, y, 50, 50, 70, maestroIn.hp); //float x, float y, float l, float h, int danno, int maxHp
    this.vx=vxIn;
    this.isOver=false;
    this.comeBack=false;
    this.maestro=maestroIn;
    this.corpo= loadImage("corpo.png");
    this.testa= loadImage("testa.png");
    
    this.ht=this.h*(7/2);
    this.lt=this.h;
    this.countCb=60;
    this.countStart=100;
    this.countS=this.countStart;
  }

  public void update() {
    if(this.countS<=0)this.move();
    this.removeHp();
    this.colpisci();
    this.checkOver();
    if(this.maestro.isCaricando3) tint(250,-250,0);
    this.show();
    noTint();
    this.frameInvAttuali--;
    this.countS--;
  }

  public void show() {
    imageMode(CORNER);
    image(corpo, this.x-(this.l-this.lt)/2, this.y-this.h/2, this.l-this.lt, this.h);
    image(testa, this.x-this.l/2-this.lt/2, this.y-this.ht/2, this.lt, this.ht);
    imageMode(CENTER);
    }

  public void move() {
    this.x+=this.vx;
    this.l-=this.vx*2;
  }

  public void checkOver() {
    if(this.x-this.l/2-this.lt/2<=0&&!this.comeBack){
      this.vx*=-2;
      this.countS=this.countCb;
      this.comeBack=true;
    }else if(this.x>this.maestro.x-this.maestro.l/2&&this.comeBack) this.isOver=true;
  }
  
  public void removeHp(){
    if(this.hp>this.maestro.hp) this.hp=this.maestro.hp;
    else if(this.hp<this.maestro.hp) this.maestro.hp=this.hp;
  }
}
