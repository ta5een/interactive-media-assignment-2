private static final int MAX_CASES = 12_000_000;
private static final int MAX_TIERS = 6;

private static final int MAX_TIER_1 = 100_000;
private static final int MAX_TIER_2 = 500_000;
private static final int MAX_TIER_3 = 1_000_000;
private static final int MAX_TIER_4 = 3_000_000;
private static final int MAX_TIER_5 = 6_000_000;
private static final int MAX_TIER_6 = MAX_CASES;

public interface HoneycombCellDimensionsCalculator {
  public float getCellWidth();
  public float getCellExtent();
}

/**
 * Responsible for drawing the hexagonal cell representing a honeycomb.
 */
public class HoneycombCell {
  private final color EMPTY_COLOR = #faf0d4;
  private final color STROKE_COLOR = #FFB800;
  private final int STROKE_WEIGHT = 3;

  private final String label;
  private final PVector position;

  private int tier = 1;
  
  private float lerpAmount = 0.0;
  private float currTierProgress = 0.0;
  private float prevTierProgress = 0.0;
  private int currGreenColor = 0;
  private int prevGreenColor = 0;

  /**
   * Constructs a new `HoneycombCell` with the given label and its column and
   * row position in the grid.
   */
  public HoneycombCell(String label, PVector position) {
    this.label = label;
    this.position = position;
  }

  public void setNumberOfCases(int cases) {
    this.tier = this.getTierForCases(cases);
    this.lerpAmount = 0.0;
    this.prevTierProgress = this.currTierProgress;
    this.currTierProgress = float(cases) / float(this.getMaximumForTier(this.tier));
    this.prevGreenColor = this.currGreenColor;
    this.currGreenColor = floor(map(this.tier, 1, MAX_TIERS, 230, 80));
  }

  /**
   * Draws a `HoneycombCell` with an object that extends
   * `HoneycombCellDimensionsCalculator` to calculate its dimensions.
   */
  public void draw(HoneycombCellDimensionsCalculator dimensionsCalculator) {
    push();
    {
      if (this.lerpAmount < 1.0) {
        this.lerpAmount += 0.2;
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
        translate(-(halfCellWidth + STROKE_WEIGHT), -(cellExtent + STROKE_WEIGHT));

        // Define the dimensions of the PGraphics to draw the background and
        // fill shapes
        Dimensions pgDim =
          new Dimensions(cellWidth, cellExtent * 2)
          .add(STROKE_WEIGHT * 2, STROKE_WEIGHT * 2);

        int greenColor = floor(lerp(this.prevGreenColor, this.currGreenColor, this.lerpAmount));
        color fillColor = color(255, greenColor, 161);

        PGraphics cellPG = createGraphics(int(pgDim.w), int(pgDim.h));
        cellPG.beginDraw();
        cellPG.fill(fillColor);
        cellPG.stroke(STROKE_COLOR);
        cellPG.strokeWeight(STROKE_WEIGHT);
        cellPG.translate((cellWidth / 2) + STROKE_WEIGHT, cellExtent + STROKE_WEIGHT);
        this.drawPolygon(6, cellExtent, cellPG);
        cellPG.endDraw();
        image(cellPG, 0, 0);

        float progress = lerp(this.prevTierProgress, this.currTierProgress, this.lerpAmount);
        float emptyLevel = 1.0 - (progress % 1);
        int emptyPGHeight = int(pgDim.h * emptyLevel);

        if (emptyPGHeight > 0) {
          PGraphics emptyPG = createGraphics(int(pgDim.w), emptyPGHeight);
          emptyPG.beginDraw();
          emptyPG.fill(EMPTY_COLOR);
          //emptyPG.fill(emptyColor);
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

        textSize(12);
        text(String.format("%d", this.tier), 0, 16);
      }
      pop();
    }
    pop();
  }

  private int getTierForCases(int cases) {
    if (cases >= 0 && cases < MAX_TIER_1) {
      return 1;
    } else if (cases >= MAX_TIER_1 && cases < MAX_TIER_2) {
      return 2;
    } else if (cases >= MAX_TIER_2 && cases < MAX_TIER_3) {
      return 3;
    } else if (cases >= MAX_TIER_3 && cases < MAX_TIER_4) {
      return 4;
    } else if (cases >= MAX_TIER_4 && cases < MAX_TIER_5) {
      return 5;
    } else {
      return 6;
    }
  }

  private int getMaximumForTier(int tier) {
    switch (tier) {
    case 1:
      return MAX_TIER_1;
    case 2:
      return MAX_TIER_2;
    case 3:
      return MAX_TIER_3;
    case 4:
      return MAX_TIER_4;
    case 5:
      return MAX_TIER_5;
    default:
      return MAX_TIER_6;
    }
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
