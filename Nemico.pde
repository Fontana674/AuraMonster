public class Nemico extends Entita {
  int hp, maxHp;
  int danno;
  int frameInv;
  int frameInvAttuali;

  public Nemico(float x, float y, float l, float h, int danno, int maxHp) {
    super(x, y, l, h);
    this.danno=danno;
    this.maxHp=maxHp;
    this.hp=maxHp;
    this.frameInv=20;
    this.frameInvAttuali=this.frameInv;
  }

  void update() {
    this.show();
    this.colpisci();
    this.frameInvAttuali--;
  }

  void show() {
    rectMode(CENTER);
    fill(255);
    rect(this.x, this.y, this.l, this.h);
  }

  void colpisci() {
    if (this.collide(p) && p.frameInvAttuali<0) {
      p.hp-=this.danno;
      p.frameInvAttuali=p.frameInv;
    }
  }
}
