public class Colpo extends Entita {
  Player vittima;
  Nemico shooter;
  float vx, vy;
  float danno=20;
  boolean isOver;
  boolean parried;

  public Colpo(Player vittimaIn, Nemico shooterIn) {
    super(shooterIn.x, shooterIn.y, 30, 30);
    this.vittima=vittimaIn;
    this.shooter=shooterIn;
    this.vx=-15;
    this.vy=(-this.vittima.y+this.shooter.y)/(abs(this.vittima.x-this.shooter.x)/this.vx);
    /*if (this.vy>this.vx) {
     this.vy=this.vy/(this.vy)*this.vx;
     this.vx=this.vx/(this.vx)*this.vy;
     }*/
    /*if(this.vittima.y-this.shooter.y>0) this.vy=-vx;
     else this.vy=vx;
     this.vx=(this.vittima.x-this.shooter.x)/(abs(this.vittima.y-this.shooter.y)/this.vy);
     }*/


    //this.vy=(this.vittima.y-this.shooter.y)/-vx;
    //this.vx=(this.vittima.x-this.shooter.x)/10/2;


    //this.vy=(this.vittima.y-this.shooter.y)/-this.vx/2;
    this.isOver=false;
    this.parried=false;
  }



  public Colpo(Player vittimaIn, Nemico shooterIn, float vxIn, float vyIn, float yIn) {
    super(shooterIn.x, yIn, 30, 30);
    this.vittima=vittimaIn;
    this.shooter=shooterIn;
    this.vx=vxIn;
    this.vy=vyIn;
    this.isOver=false;
    this.parried=false;
  }

  public Colpo(Player vittimaIn, Nemico shooterIn, float vxIn, float vyIn, float yIn, float r) {
    super(shooterIn.x, yIn, r*2, r*2);
    this.vittima=vittimaIn;
    this.shooter=shooterIn;
    this.vx=vxIn;
    this.vy=vyIn;
    this.isOver=false;
    this.parried=false;
  }
  
  public Colpo(Player vittimaIn, Nemico shooterIn, float vxIn, float vyIn, float yIn, float r, float dannoIn) {
    super(shooterIn.x, yIn, r*2, r*2);
    this.vittima=vittimaIn;
    this.shooter=shooterIn;
    this.vx=vxIn;
    this.vy=vyIn;
    this.isOver=false;
    this.parried=false;
    this.danno=dannoIn;
  }




  public void update() {
    this.move();
    this.show();
    if (!this.parried) {
      this.attacca(this.vittima);
    } else this.attacca(this.shooter);
  }

  public void move() {
    this.x+=this.vx;
    this.y+=this.vy;
    if (this.isOut()) this.isOver=true;
  }

  public void show() {
    fill(128, 60, 27);
    stroke(0);
    circle(this.x, this.y, this.l);
  }


  /*public void attacca(Entita e) {
   if (this.collide(e)) {
   this.isOver=true;
   }
   }*/


  public void attacca(Player p) {
    if (this.collide(p)) {
      if (p.isParrying&&!this.parried) {
        this.vx*=-1;
        this.vy*=-1;

        this.parried=true;
        p.hasParried=true;
        parryEffect=10;
        p.aura+=100;
      } else if (p.frameInvAttuali<=0) {
        p.hp-=this.danno;
        p.frameInvAttuali=p.frameInv;
        this.isOver=true;
      }
    }
  }

  public void attacca(Nemico n) {
    if (this.collide(n)) {
      if (n.frameInvAttuali<=0) {
        n.hp-=this.danno;
        n.frameInvAttuali=p.frameInv;
      }
      this.isOver=true;
    }
  }
}
