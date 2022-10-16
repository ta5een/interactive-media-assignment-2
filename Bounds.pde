/**
 * A convenient class to define an area of interest in the window.
 */
public class Bounds {
  /** The top-left position of this area of interest. */
  public PVector pos;
  /** The dimensions of this area of interest. */
  public Dimensions dim;

  public Bounds(PVector pos, Dimensions dim) {
    this.pos = pos;
    this.dim = dim;
  }

  public Bounds(float x, float y, float w, float h) {
    this.pos = new PVector(x, y);
    this.dim = new Dimensions(w, h);
  }

  /**
   * Returns a `PVector` with the x and y values determining the translations
   * required to horizontally and vertically centre something with dimensions
   * `itemDim` to this `Bounds`.
   */
  public PVector calculateTranslationToCenter(Dimensions itemDim) {
    float translateX = this.pos.x + ((this.dim.w - itemDim.w) / 2.0);
    float translateY = this.pos.y + ((this.dim.h - itemDim.h) / 2.0);
    return new PVector(translateX, translateY);
  }
}
