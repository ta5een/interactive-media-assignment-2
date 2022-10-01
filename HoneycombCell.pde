public interface HoneycombCellDimensionsCalculator {
  public float getCellWidth();
  public float getCellExtent();
}

public class HoneycombCell {
  private final String label;
  private final PVector position;

  /**
   * Constructs a new `HoneycombCell` with the given label and its position in
   * the grid of other cells.
   */
  public HoneycombCell(String label, PVector position) {
    this.label = label;
    this.position = position;
  }

  /**
   * Draws a `HoneycombCell` with an object that delegates the calculation of
   * its bounding dimensions.
   */
  public void draw(HoneycombCellDimensionsCalculator dimensionsCalculator) {
    push();
    {
      var extent = dimensionsCalculator.getCellExtent();
      var halfWidth = dimensionsCalculator.getCellWidth() / 2.0;

      var shiftX = 2 * halfWidth;
      var shiftY = 1.5 * extent;
      var rowOffset = position.y % 2 == 0 ? 0.0 : halfWidth;

      translate(rowOffset + (shiftX * position.x), shiftY * position.y);
      strokeWeight(3);
      drawPolygon(6, extent);
      push();
      {
        fill(0);
        textSize(24);
        textAlign(CENTER);
        text(this.label, 0, 0);
      }
      pop();
    }
    pop();
  }

  /**
   * Draws a polygon with `sideCount` number of sides and an equal width and
   * height of `extent`.
   */
  private void drawPolygon(int sideCount, float extent) {
    beginShape();

    final float thetaInc = TWO_PI / sideCount;
    float theta = -(PI / sideCount); // Start at an angle from horizontal, anticlockwise
    float x = 0.0;
    float y = 0.0;

    for (int i = 0; i < sideCount; i++) {
      x = cos(theta) * extent;
      y = sin(theta) * extent;
      vertex(x, y);
      theta += thetaInc;
    }

    endShape(CLOSE);
  }
}
