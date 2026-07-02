public class BarraVita extends Entita {


  public BarraVita(Player p) {
    super(50, 40, 67*2, 12);
  }

  public BarraVita(Boss b) {
    super((width-500)/2, 20+30, 500, 20);
  }


  void update(Player p) {
    rectMode(CORNER);
    stroke(0);
    fill(250, 70, 70);
    rect(this.x, this.y, this.l, this.h);
    if (p.hp>0) {
      fill(50, 200, 50);
      rect(this.x, this.y, (this.l*p.hp)/p.maxHp, this.h);
    }
  }

  void update(Boss b) {
    stroke(0);
    rectMode(CORNER);
    fill(100);
    rect(this.x, this.y, this.l, this.h);
    fill(200, 50, 50);
    textMode(CENTER);
    textSize(50);
    text("Mr Anaconda", width/2-100, this.y-18);
    if (b.hp>0) {
      rect(this.x, this.y, (this.l*b.hp)/b.maxHp, this.h);
    }
  }
}
