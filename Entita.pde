public class Entita {
  float x;
  float y;
  float l;
  float h;

  public Entita(float x, float y, float l, float h) {
    this.x=x;
    this.y=y;
    this.h=h;
    this.l=l;
  }

  public void insegui(Entita e, float vx, float vy) {
    if (this.x<e.x) x+=vx;
    if (this.x>e.x) x-=vx;
    if (this.y<e.y) y+=vy;
    if (this.y>e.y) y-=vy;
  }

  public boolean collide(Entita e) {
    if (this.y + this.h/2 >= e.y - e.h/2 &&this.y - this.h/2 <= e.y + e.h/2 &&this.x + this.l/2 >= e.x - e.l/2 &&this.x - this.l/2 <= e.x + e.l/2) return true;
    return false;
  }

  public boolean isOut() {
    if (this.x+this.l/2>width||this.x<this.l/2||this.y+this.h/2>height||this.y<this.h/2) return true;
    return false;
  }
  
  public void showHitBox(){
    stroke(0);
    noFill();
    rect(this.x,this.y,this.l,this.h);
  }
}
