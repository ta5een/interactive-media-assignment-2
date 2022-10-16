import java.util.Map;

/**
 * Responsible for drawing a grid of hexagonal cells in a honeycomb pattern.
 */
public class Honeycomb implements HoneycombCellDimensionsCalculator {
  private final Map<String, HoneycombCell> cells;
  private final float desiredWidth;

  private int columnCount = 0;
  private int rowCount = 0;

  public Honeycomb(float desiredWidth, JSONArray cellLayout) {
    this.desiredWidth = desiredWidth;
    this.cells = new HashMap();

    for (int i = 0; i < cellLayout.size(); i++) {
      // Parse an entry with "state" and "position" fields
      JSONObject entry = cellLayout.getJSONObject(i);
      String label = entry.getString("state");
      int posX = entry.getJSONArray("position").getInt(0);
      int posY = entry.getJSONArray("position").getInt(1);

      // Add this new honeycomb cell to the list
      this.cells.put(label, new HoneycombCell(label, new PVector(posX, posY)));

      // Update the total column count from the maximum column index
      if (posX > this.columnCount - 1) {
        this.columnCount = int(posX + 1);
      }

      // Update the total row count from the maximum row index
      if (posY > this.rowCount) {
        this.rowCount = int(posY + 1);
      }
    }
  }

  public HoneycombCell getCellWithLabel(String label) {
    return this.cells.get(label);
  }

  /**
   * Calculates the width of each honeycomb cell, taking into consideration the
   * desired width that was passed to the constructor.
   */
  public float getCellWidth() {
    float originalCellWidth = this.desiredWidth / this.columnCount;
    float originalGridWidth = this.desiredWidth + (originalCellWidth / 2);
    float scale = this.desiredWidth / originalGridWidth;
    return originalCellWidth * scale;
  }

  /**
   * Calculates the distance between the center of a honeycomb cell and one of
   * its corners. The height of a honeycomb cell is equal to double the extent.
   */
  public float getCellExtent() {
    // If we split a hexagon into 6 triangles like a pizza, we can use
    // trigonometry to calculate the two equal sides of each isosceles triangle,
    // both of which represent the polygon's extent.
    return (this.getCellWidth() / 2.0) / cos(PI / 6);
  }

  /**
   * Returns the dimensions of the grid of honeycomb cells.
   */
  public Dimensions getGridDimensions() {
    float cellExtent = this.getCellExtent();
    float gridHeight = ((cellExtent * 1.5) * this.rowCount) + (cellExtent * 0.5);
    return new Dimensions(this.desiredWidth, gridHeight);
  }

  /**
   * Draws the `Honeycomb` with its cells arranged in a honeycomb pattern.
   */
  public void draw() {
    push();
    translate(this.getCellWidth() / 2.0, this.getCellExtent());
    for (HoneycombCell cell : this.cells.values()) {
      cell.draw(this);
    }
    pop();
  }
}
