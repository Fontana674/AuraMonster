public class Piattaforma extends Entita {
  Boolean isSolid;
  Piattaforma(float x, float y, float w, float h, Boolean solid) {
    super(x, y, w, h);
    this.isSolid=solid;
  }

  // disegna la piattaforma come un rettangolo
  void show() {
    rectMode(CENTER);
    stroke(0);
    fill(120);          // colore grigio
    rect(this.x, this.y, this.l, this.h);
  }

  boolean collide(Entita e) {
    if (!this.isSolid) {
      if (this.y + this.h/2+3 >= e.y + e.h/2 && this.y - this.h/2 <= e.y + e.h/2 &&this.x + this.l/2 >= e.x - e.l/4 &&this.x - this.l/2 <= e.x + e.l/4) return true;
      return false;
    }
    else return(super.collide(e));
  }

  void collidi(Player p) {
    if (this.collide(p)&&p.vy>0&&(!p.s||isSolid)) {
      p.y = this.y - p.h/2;
      p.vy = 0;
      p.inAir = false;
      //p.platform = true;
    } else p.inAir=true;
  }
}
