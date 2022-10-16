

public interface HoneycombCellDimensionsCalculator {
  public float getCellWidth();
  public float getCellExtent();
}

/**
 * Responsible for drawing the hexagonal cell representing a honeycomb.
 */
public class HoneycombCell {
  private final String label;
  private final PVector position;
  private int tier = 1;

  private float lerpAmount = 0.0;
  private float currTierProgress = 0.0;
  private float prevTierProgress = 0.0;
  private int currGreenValue;
  private int prevGreenValue;

  /**
   * Constructs a new `HoneycombCell` with the given label and its column and
   * row position in the grid.
   */
  public HoneycombCell(String label, PVector position) {
    this.label = label;
    this.position = position;
    this.currGreenValue = legend.CELL_GREEN_VALUE;
    this.prevGreenValue = this.currGreenValue;
  }

  public void setNumberOfCases(int cases) {
    this.tier = legend.getTierForCases(cases);
    this.lerpAmount = 0.0;
    this.prevTierProgress = this.currTierProgress;
    this.currTierProgress = float(cases) / float(legend.getMaximumForTier(this.tier));
    this.prevGreenValue = this.currGreenValue;
    //this.currGreenValue = floor(map(this.tier, 1, MAX_TIERS, greenValue * 0.9, greenValue * 0.5));
    this.currGreenValue = legend.getGreenValueForTier(this.tier);
  }

  /**
   * Draws a `HoneycombCell` with an object that extends
   * `HoneycombCellDimensionsCalculator` to calculate its dimensions.
   */
  public void draw(HoneycombCellDimensionsCalculator dimensionsCalculator) {
    push();
    {
      if (this.lerpAmount < 1.0) {
        this.lerpAmount = min(1.0, this.lerpAmount + 0.2);
      }

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
        // The top-left corner of PGraphics is currently aligned to the center,
        // so we translate it leftwards and upwards
        translate(-(halfCellWidth + CELL_STROKE_WEIGHT), -(cellExtent + CELL_STROKE_WEIGHT));

        // Define the dimensions of the PGraphics to draw the background and
        // fill shapes
        Dimensions pgDim =
          new Dimensions(cellWidth, cellExtent * 2)
          .add(CELL_STROKE_WEIGHT * 2, CELL_STROKE_WEIGHT * 2);

        int greenValue = floor(lerp(this.prevGreenValue, this.currGreenValue, this.lerpAmount));
        color fillColor = color(legend.CELL_RED_VALUE, greenValue, legend.CELL_BLUE_VALUE);

        PGraphics cellPG = createGraphics(int(pgDim.w), int(pgDim.h));
        cellPG.beginDraw();
        cellPG.fill(fillColor);
        cellPG.stroke(CELL_STROKE_COLOR);
        cellPG.strokeWeight(CELL_STROKE_WEIGHT);
        cellPG.translate((cellWidth / 2) + CELL_STROKE_WEIGHT, cellExtent + CELL_STROKE_WEIGHT);
        this.drawPolygon(6, cellExtent, cellPG);
        cellPG.endDraw();
        image(cellPG, 0, 0);

        float progress = lerp(this.prevTierProgress, this.currTierProgress, this.lerpAmount);
        float emptyLevel = 1.0 - (progress % 1);
        int emptyPGHeight = int(pgDim.h * emptyLevel);

        if (emptyPGHeight > 0) {
          PGraphics emptyPG = createGraphics(int(pgDim.w), emptyPGHeight);
          emptyPG.beginDraw();
          emptyPG.fill(CELL_EMPTY_COLOR);
          emptyPG.stroke(CELL_STROKE_COLOR);
          emptyPG.strokeWeight(CELL_STROKE_WEIGHT);
          emptyPG.translate((cellWidth / 2) + CELL_STROKE_WEIGHT, cellExtent + CELL_STROKE_WEIGHT);
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

        textSize(12);
        text(String.format("%d", this.tier), 0, 16);
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
