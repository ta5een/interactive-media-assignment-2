public class Bounds {
  private PVector minBounds;
  private PVector maxBounds;

  public Bounds(PVector topLeft, PVector dimensions) {
    this.minBounds = topLeft;
    this.maxBounds = topLeft.copy().add(dimensions.x, dimensions.y);
  }

  public boolean isOverlapped(PVector inspector) {
    return (
      inspector.x >= minBounds.x
        && inspector.x <= maxBounds.x
        && inspector.y >= minBounds.y
        && inspector.y <= maxBounds.y
     );
  }
}
