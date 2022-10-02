Honeycomb honeycomb;

void setup() {
  size(1000, 700);
  var stateLayout = loadJSONArray("states_layout.json");
  honeycomb = new Honeycomb(width * 0.8, stateLayout);
}

void draw() {
  background(255);

  var honeycombDimensions = honeycomb.getGridDimensions();
  var topScreenPortion = new PVector(width, height * 0.8);
  centerWithinBounds(topScreenPortion, honeycombDimensions);
  honeycomb.draw();

  var honeycombTopLeft = new PVector(screenX(0f, 0f), screenY(0f, 0f));
  var honeycombBounds = new Bounds(honeycombTopLeft, honeycombDimensions);
  honeycomb.setListenToMouseEvents(honeycombBounds.isOverlapped(new PVector(mouseX, mouseY)));
}

/**
 * Translates the drawing context such that an item with dimensions `itemBounds`
 * will be vertically and horizontally centred within the given `bounds`.
 */
void centerWithinBounds(PVector bounds, PVector itemDimensions) {
  translate((bounds.x - itemDimensions.x) / 2, (bounds.y - itemDimensions.y) / 2);
}
