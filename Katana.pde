public class Katana extends Entita {
  float vx, vy;
  PImage im;
  boolean inHand;
  boolean stepSister=false; //isIncastrata
  float a;
  float countIniz=3*frameRate;
  float count=countIniz; //tempo in cui rimane incastrata nel muro

  public Katana(Player p) {
    super(p.x+75, p.y-5, 67, 67);
    this.inHand=true;
    this.im=loadImage("katana.png");
    this.a=0;
  }

  void update(Player p, Boss b) {
    this.show();
    this.move(p, b);
  }

  void show() {
    /*if (inHand) {
     image(im, this.x, this.y, this.l, this.h);
     } else */    if (stepSister && x<50&&count>0) {
      pushMatrix();
      translate(this.x, this.y);
      scale(-1, 1);
      this.showLancio();
      popMatrix();
    } else if (stepSister && y>height-40&&count>0) {
      pushMatrix();
      translate(this.x, this.y);
      scale(1, -1);
      this.showLancio();
      popMatrix();
    } else if (stepSister&&count>0) {
      image(im, this.x, this.y, this.l, this.h);
    }
  }

  void showLancio() {
    image(im, 0, 0, this.l, this.h);
  }


  void move(Player p, Boss b) {
    if (inHand) {
      this.x=p.x+this.l/2;
      this.y=p.y-5;
    } else if (!stepSister) {
      this.x+=this.vx;
      this.y+=this.vy;
      this.ruota();
      this.checkBound(p, b);
    } else {
      this.checkBound(p,b);
    }
  }

  void ruota() {
    this.a+=0.3;
    push();
    translate(this.x, this.y);
    rotate(this.a);
    this.showLancio();
    pop();
  }

  void checkBound(Player p, Boss b) {
    // if (this.x-this.l/2>=width||this.x+this.l/2<=0||this.y+this.h/2<=0||this.y-this.h/2>=height) {
    if ((this.x+5>=width-b.l+80||this.x-5<=0||this.y-5<=0||this.y+5>=height)||this.stepSister) {
      this.stepSister=true;
      this.vx=0;
      this.vy=0;
      this.count--;
    }
    if (this.count<=0) {
      this.insegui(p, 10, 10);
      //this.stepSister=false;
    }
    this.ritorna(p);
  }

  public void insegui(Entita e, float vx, float vy) {
    if (this.x<e.x) x+=vx;
    if (this.x>e.x) x-=vx;
    if (this.y<e.y) y+=vy;
    if (this.y>e.y) y-=vy;
    this.ruota();
  }

  void ritorna(Player p) {
    if (this.collide(p)&&stepSister) {
      this.stepSister=false;
      this.count=this.countIniz;
      this.inHand=true;
      this.x=p.x+this.l/2;
      this.y=p.y-5;
    }
  }
}
