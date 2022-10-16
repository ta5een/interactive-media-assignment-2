/**
 * A convenient class to store the dimensions of something.
 */
public class Dimensions {
  public float w;
  public float h;

  public Dimensions(float w, float h) {
    this.w = w;
    this.h = h;
  }

  public Dimensions add(float w, float h) {
    return new Dimensions(this.w + w, this.h + h);
  }

  public Dimensions sub(float w, float h) {
    return new Dimensions(this.w - w, this.h - h);
  }
}
