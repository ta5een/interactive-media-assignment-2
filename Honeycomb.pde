public class Honeycomb implements HoneycombCellDimensionsCalculator {
  private final ArrayList<HoneycombCell> cells;
  private final float desiredWidth;

  private int columnCount = 0;
  private int rowCount = 0;

  public Honeycomb(float desiredWidth, JSONArray cellLayout) {
    this.desiredWidth = desiredWidth;
    this.cells = new ArrayList();

    for (int i = 0; i < cellLayout.size(); i++) {
      // Parse an entry with "state" and "position" fields
      final var entry = cellLayout.getJSONObject(i);
      final var state = entry.getString("state");
      final var posX = entry.getJSONArray("position").getInt(0);
      final var posY = entry.getJSONArray("position").getInt(1);

      // Add this new honeycomb cell to the list
      this.cells.add(new HoneycombCell(state, new PVector(posX, posY)));

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

  /**
   * Calculates the width of each honeycomb cell, taking into consideration the
   * desired width that has been passed in the constructor.
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
    // If we split a hexagon into triangles like a pizza, we can use
    // trigonometry to calculate the two equal sides of the isosceles triangle,
    // which represents the extent.
    return (this.getCellWidth() / 2.0) / cos(radians(30));
  }

  /**
   * Returns a `PVector` with the x and y values set to the width and height
   * of the grid of honeycomb cells.
   */
  public PVector getGridBounds() {
    var cellExtent = this.getCellExtent();
    var gridHeight = ((cellExtent * 1.5) * this.rowCount) + (cellExtent * 0.5);
    return new PVector(this.desiredWidth, gridHeight);
  }

  public void draw() {
    push();
    translate(this.getCellWidth() / 2.0, this.getCellExtent());
    for (var cell : this.cells) {
      cell.draw(this);
    }
    pop();
  }
}
