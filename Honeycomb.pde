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
      var entry = cellLayout.getJSONObject(i);
      var state = entry.getString("state");
      var posX = entry.getJSONArray("position").getInt(0);
      var posY = entry.getJSONArray("position").getInt(1);

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

  public float getCellWidth() {
    var originalCellWidth = this.desiredWidth / this.columnCount;
    var originalGridWidth = this.desiredWidth + (originalCellWidth / 2);
    var scale = this.desiredWidth / originalGridWidth;
    return originalCellWidth * scale;
  }

  public float getCellExtent() {
    return (this.getCellWidth() / 2.0) / cos(radians(30)); 
  }
  
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
