void setup() {
  size(900, 700);
  background(220);
  var stateLayout = loadJSONArray("states_layout.json");
  var honeycomb = new Honeycomb(width * 0.8, stateLayout);
  var honeycombBounds = honeycomb.getGridBounds();
  var topScreenPortion = new PVector(width, height * 0.8);
  centerWithinBounds(topScreenPortion, honeycombBounds);
  honeycomb.draw();
}

void centerWithinBounds(PVector bounds, PVector itemBounds) {
  translate((bounds.x - itemBounds.x) / 2, (bounds.y - itemBounds.y) / 2);
}
