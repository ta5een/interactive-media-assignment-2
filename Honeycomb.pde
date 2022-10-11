import java.util.Map;

public class Honeycomb implements HoneycombCellDimensionsCalculator {
  private final Map<String, HoneycombCell> cellsIndex;
  private final float desiredWidth;

  private int columnCount = 0;
  private int rowCount = 0;

  public Honeycomb(float desiredWidth, JSONArray cellLayout) {
    this.desiredWidth = desiredWidth;
    this.cellsIndex = new HashMap();

    for (int i = 0; i < cellLayout.size(); i++) {
      // Parse an entry with "state" and "position" fields
      var entry = cellLayout.getJSONObject(i);
      var label = entry.getString("state");
      var posX = entry.getJSONArray("position").getInt(0);
      var posY = entry.getJSONArray("position").getInt(1);

      // Add this new honeycomb cell to the list
      this.cellsIndex.put(label, new HoneycombCell(label, new PVector(posX, posY)));

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
    return this.cellsIndex.get(label);
  }

  /**
   * Calculates the width of each honeycomb cell, taking into consideration the
   * desired width that was passed to the constructor.
   */
  public float getCellWidth() {
    var originalCellWidth = this.desiredWidth / this.columnCount;
    var originalGridWidth = this.desiredWidth + (originalCellWidth / 2);
    var scale = this.desiredWidth / originalGridWidth;
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
    var cellExtent = this.getCellExtent();
    var gridHeight = ((cellExtent * 1.5) * this.rowCount) + (cellExtent * 0.5);
    return new Dimensions(this.desiredWidth, gridHeight);
  }

  public void draw() {
    push();
    translate(this.getCellWidth() / 2.0, this.getCellExtent());
    for (var cell : this.cellsIndex.values()) {
      cell.draw(this);
    }
    pop();
  }
}
