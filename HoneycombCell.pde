public interface HoneycombCellDimensionsCalculator {
  public float getCellWidth();
  public float getCellExtent();
}

/**
 * Responsible for drawing the hexagonal cell of a honeycomb.
 */
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
      float cellWidth = dimensionsCalculator.getCellWidth();
      float cellExtent = dimensionsCalculator.getCellExtent();
      float halfCellWidth = cellWidth / 2.0;

      float shiftX = cellWidth;
      float shiftY = 1.5 * cellExtent;
      float rowOffset = position.y % 2 == 0 ? 0.0 : halfCellWidth;

      float translateX = rowOffset + (shiftX * position.x);
      float translateY = shiftY * position.y;
      translate(translateX, translateY);

      push();
      {
        // The top-left corner of PGraphics is currently aligned to the center, so we translate it
        // leftwards and upwards
        translate(-(halfCellWidth + STROKE_WEIGHT), -(cellExtent + STROKE_WEIGHT));

        // Define the dimensions of the PGraphics to draw the background and fill shapes
        Dimensions pgDim =
          new Dimensions(cellWidth, cellExtent * 2)
          .add(STROKE_WEIGHT * 2, STROKE_WEIGHT * 2);

        PGraphics cellPG = createGraphics(int(pgDim.w), int(pgDim.h));
        cellPG.beginDraw();
        cellPG.fill(HONEY_COLOR);
        cellPG.stroke(STROKE_COLOR);
        cellPG.strokeWeight(STROKE_WEIGHT);
        cellPG.translate((cellWidth / 2) + STROKE_WEIGHT, cellExtent + STROKE_WEIGHT);
        this.drawPolygon(6, cellExtent, cellPG);
        cellPG.endDraw();
        image(cellPG, 0, 0);

        float emptyLevel = 1.0 - this.fillLevel;
        int emptyPGHeight = int(pgDim.h * emptyLevel);
        if (emptyPGHeight > 0) {
          PGraphics emptyPG = createGraphics(int(pgDim.w), emptyPGHeight);
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
