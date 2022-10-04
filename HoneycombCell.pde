public interface HoneycombCellDimensionsCalculator {
  public float getCellWidth();
  public float getCellExtent();
}

public class HoneycombCell {
  private final color HONEY_COLOR = #FFEAA1;
  private final color EMPTY_COLOR = #FFFBEB;
  private final color STROKE_COLOR = #FFB800;
  private final int STROKE_WEIGHT = 3;

  private final String label;
  private final PVector position;

  private float fillLevel = 0.0;

  /**
   * Constructs a new `HoneycombCell` with the given label and its position in
   * the grid of other cells.
   */
  public HoneycombCell(String label, PVector position) {
    this.label = label;
    this.position = position;
  }

  public float getFillLevel() {
    return this.fillLevel;
  }

  public void setFillLevel(float level) {
    assert(level >= 0.0 && level <= 1.0) :
    "The `level` parameter must be between 0.0 and 1.0, inclusive";
    this.fillLevel = level;
  }

  /**
   * Draws a `HoneycombCell` with an object that delegates the calculation of
   * its bounding dimensions.
   */
  public void draw(HoneycombCellDimensionsCalculator dimensionsCalculator) {
    push();
    {
      var cellWidth = dimensionsCalculator.getCellWidth();
      var cellExtent = dimensionsCalculator.getCellExtent();
      var halfCellWidth = cellWidth / 2.0;

      var shiftX = cellWidth;
      var shiftY = 1.5 * cellExtent;
      var rowOffset = position.y % 2 == 0 ? 0.0 : halfCellWidth;

      var translateX = rowOffset + (shiftX * position.x);
      var translateY = shiftY * position.y;
      translate(translateX, translateY);

      push();
      {
        // The top-left corner of PGraphics is currently aligned to the center, so we translate it
        // leftwards and upwards
        translate(-(halfCellWidth + STROKE_WEIGHT), -(cellExtent + STROKE_WEIGHT));

        var pgDimensions =
          new PVector(cellWidth, cellExtent * 2)
          .add(STROKE_WEIGHT * 2, STROKE_WEIGHT * 2);

        var cellPG = createGraphics(int(pgDimensions.x), int(pgDimensions.y));
        cellPG.beginDraw();
        cellPG.fill(HONEY_COLOR);
        cellPG.stroke(STROKE_COLOR);
        cellPG.strokeWeight(STROKE_WEIGHT);
        cellPG.translate((cellWidth / 2) + STROKE_WEIGHT, cellExtent + STROKE_WEIGHT);
        this.drawPolygon(6, cellExtent, cellPG);
        cellPG.endDraw();
        image(cellPG, 0, 0);

        var emptyLevel = 1.0 - this.fillLevel;
        var emptyPGHeight = int(pgDimensions.y * emptyLevel);
        if (emptyPGHeight > 0) {
          var emptyPG = createGraphics(int(pgDimensions.x), emptyPGHeight);
          emptyPG.beginDraw();
          emptyPG.fill(EMPTY_COLOR);
          emptyPG.stroke(STROKE_COLOR);
          emptyPG.strokeWeight(STROKE_WEIGHT);
          emptyPG.translate((cellWidth / 2) + STROKE_WEIGHT, cellExtent + STROKE_WEIGHT);
          this.drawPolygon(6, cellExtent, emptyPG);
          emptyPG.endDraw();
          image(emptyPG, 0, 0);
        }
      }
      pop();

      push();
      {
        fill(0);
        textSize(24);
        textAlign(CENTER);
        translate(0, 7);
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
  private void drawPolygon(int sideCount, float extent, PGraphics pg) {
    pg.beginShape();

    final float thetaInc = TWO_PI / sideCount;
    float theta = -(PI / sideCount); // Start at an angle from horizontal, anticlockwise
    float x = 0.0;
    float y = 0.0;

    for (int i = 0; i < sideCount; i++) {
      x = cos(theta) * extent;
      y = sin(theta) * extent;
      pg.vertex(x, y);
      theta += thetaInc;
    }

    pg.endShape(CLOSE);
  }
}
