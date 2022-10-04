import controlP5.*;

ControlP5 cp5;
Honeycomb honeycomb;

PVector honeycombContainerDimensions;
PVector guiContainerDimensions;

void setup() {
  size(1000, 700);
  cp5 = new ControlP5(this);
  honeycombContainerDimensions = new PVector(width, height * 0.8);
  guiContainerDimensions = new PVector(width, honeycombContainerDimensions.y);

  var stateLayout = loadJSONArray("states_layout.json");
  honeycomb = new Honeycomb(width * 0.8, stateLayout);

  cp5.addSlider("setCurrFillLevel")
    .setValue(0.0)
    .setPosition(0.0, guiContainerDimensions.y)
    .setSize(200, 40)
    .setRange(0.0, 1.0);
}

void draw() {
  background(255);
  push();
  {
    var honeycombDimensions = honeycomb.getGridDimensions();
    centerWithinBounds(honeycombContainerDimensions, honeycombDimensions);
    honeycomb.draw();
  }
  pop();
}

void setCurrFillLevel(float level) {
  if (honeycomb != null) {
    honeycomb.getCellWithLabel("NY").setFillLevel(level);
    honeycomb.getCellWithLabel("CA").setFillLevel(level);
    honeycomb.getCellWithLabel("FL").setFillLevel(level);
    honeycomb.getCellWithLabel("OK").setFillLevel(level);
    honeycomb.getCellWithLabel("SD").setFillLevel(level);
    honeycomb.getCellWithLabel("ME").setFillLevel(level);
    honeycomb.getCellWithLabel("DC").setFillLevel(level);
  }
}

/**
 * Translates the drawing context such that an item with dimensions `itemBounds`
 * will be vertically and horizontally centred within the given `bounds`.
 */
void centerWithinBounds(PVector bounds, PVector itemDimensions) {
  translate((bounds.x - itemDimensions.x) / 2, (bounds.y - itemDimensions.y) / 2);
}
