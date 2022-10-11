public class Bounds {
  public PVector pos;
  public Dimensions dim;

  public Bounds(PVector pos, Dimensions dim) {
    this.pos = pos;
    this.dim = dim;
  }

  public Bounds(PVector pos, float w, float h) {
    this.pos = pos;
    this.dim = new Dimensions(w, h);
  }
  
  public Bounds(float x, float y, float w, float h) {
    this.pos = new PVector(x, y);
    this.dim = new Dimensions(w, h);
  }

  public PVector calculateTranslationToCenter(Dimensions itemDim) {
    float translateX = this.pos.x + ((this.dim.w - itemDim.w) / 2.0);
    float translateY = this.pos.y + ((this.dim.h - itemDim.h) / 2.0);
    return new PVector(translateX, translateY);
  }
}
