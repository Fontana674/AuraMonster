public class Hitbox extends Entita {
  float count;
  boolean pogo;
  PImage sprite;
  int direzione;

  public Hitbox(float x, float y, float l, float h, int direzione) { //1=destra, 2 su, 3 sinistra, 4 giu
    super(x, y, l, h);
    this.count=10;
    this.direzione=direzione;
    this.sprite=loadImage("hitbox.png");
  }

  public void update(Player p) {
    show();
    move(p);
    this.count--;
  }

  public void show() {
    fill(255, 0, 0);
    switch (this.direzione) {
    case 1:
      image(sprite, this.x, this.y, this.l, this.h);
      break;
    case 2:
      push();
      translate(this.x, this.y);
      rotate(3*PI/2);
      image(sprite, 0, 0, this.l, this.h);
      pop();
      break;
    case 3:
      pushMatrix();
      translate(this.x, this.y);
      scale(-1, 1);
      image(sprite, 0, 0, l, h);
      popMatrix();
      break;
    case 4:
      push();
      translate(this.x, this.y);
      rotate(PI/2);
      image(sprite, 0, 0, this.l, this.h);
      pop();
      break;
    default:
      image(sprite, this.x, this.y, this.l, this.h);
      break;
    }
    noFill();
  }

  public void move(Player p) {
    if (p.d && p.x < width - p.l/2 - p.bordo) this.x += p.vx;
    if (p.a && p.x > p.l / 2 + p.bordo) this.x -= p.vx;
    this.y+=p.vy;
  }
}
