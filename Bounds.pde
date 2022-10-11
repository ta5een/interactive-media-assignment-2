public class Bounds {
  public PVector pos;
  public Dimensions dim;

  public Bounds(PVector pos, Dimensions dim) {
    this.pos = pos;
    this.dim = dim;
  }

  public Bounds(float x, float y, float w, float h) {
    this.pos = new PVector(x, y);
    this.dim = new Dimensions(w, h);
  }
}
