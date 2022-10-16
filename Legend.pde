import java.text.DecimalFormat;

public class Legend {
  private static final int MAX_CASES = 12_000_000;
  private static final int MAX_TIERS = 6;

  private static final int MAX_TIER_1 = 100_000;
  private static final int MAX_TIER_2 = 500_000;
  private static final int MAX_TIER_3 = 1_000_000;
  private static final int MAX_TIER_4 = 3_000_000;
  private static final int MAX_TIER_5 = 6_000_000;
  private static final int MAX_TIER_6 = MAX_CASES;

  public final int CELL_RED_VALUE;
  public final int CELL_GREEN_VALUE;
  public final int CELL_BLUE_VALUE;

  DecimalFormat formatter;

  public Legend() {
    CELL_RED_VALUE = floor(red(CELL_EMPTY_COLOR));
    CELL_GREEN_VALUE = floor(green(CELL_EMPTY_COLOR));
    CELL_BLUE_VALUE = floor(blue(CELL_EMPTY_COLOR));
    formatter = new DecimalFormat("#,###");
  }

  public int getTierForCases(int cases) {
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

  public int getMaximumForTier(int tier) {
    switch (tier) {
    case 0:
      return 0;
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

  public int getGreenValueForTier(int tier) {
    return floor(map(tier, 1, MAX_TIERS, legend.CELL_GREEN_VALUE * 0.9, legend.CELL_GREEN_VALUE * 0.5));
  }

  public void draw() {
    for (int tier = 1; tier < MAX_TIERS + 1; tier++) {
      push();
      {
        textSize(12);
        translate(0, 24 * (tier - 1));

        push();
        {
          noStroke();
          fill(legend.CELL_RED_VALUE, this.getGreenValueForTier(tier), legend.CELL_BLUE_VALUE);
          rect(0, 0, 20, 20);
        }
        pop();

        push();
        {
          fill(0);
          translate(0, 2);

          push();
          {
            translate(8, 0);
            textAlign(CENTER, TOP);
            text(String.format("%d", tier), 0, 0);
          }
          pop();

          push();
          {
            translate(25, 0);
            textAlign(LEFT, TOP);
            text(String.format("%s - %s", formatter.format(this.getMaximumForTier(tier - 1)), formatter.format(this.getMaximumForTier(tier))), 0, 0);
          }
          pop();
        }
        pop();
      }
      pop();
    }
  }
}
