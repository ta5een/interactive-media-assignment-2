public interface HoneycombCellDimensionsCalculator {
  public float getCellWidth();
  public float getCellExtent();
}

public class HoneycombCell {
  private final String label;
  private final PVector position;

  public HoneycombCell(String label, PVector position) {
    this.label = label;
    this.position = position;
  }

  public void draw(HoneycombCellDimensionsCalculator dimensionsCalculator) {
    push();
    {
      float centerToEdge = dimensionsCalculator.getCellWidth() / 2.0;
      float extent = dimensionsCalculator.getCellExtent();

      float shiftX = 2 * centerToEdge;
      float shiftY = 1.5 * extent;
      float oddRowOffset = position.y % 2 == 0 ? 0.0 : centerToEdge;

      translate(oddRowOffset + (shiftX * position.x), shiftY * position.y);
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

  private void drawPolygon(int sideCount, float extent) {
    beginShape();

    final float thetaInc = TWO_PI / sideCount;
    float theta = -(PI / sideCount);
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
