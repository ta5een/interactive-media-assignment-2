void setup() {
  size(1000, 700);
  background(220);
  var stateLayout = loadJSONArray("states_layout.json");
  var honeycomb = new Honeycomb(width * 0.8, stateLayout);
  var honeycombBounds = honeycomb.getGridBounds();
  var topScreenPortion = new PVector(width, height * 0.8);
  centerWithinBounds(topScreenPortion, honeycombBounds);
  honeycomb.draw();
}

/**
 * Translates the drawing context such that an item with dimensions `itemBounds`
 * will be vertically and horizontally centred within the given `bounds`.
 */
void centerWithinBounds(PVector bounds, PVector itemBounds) {
  translate((bounds.x - itemBounds.x) / 2, (bounds.y - itemBounds.y) / 2);
}
