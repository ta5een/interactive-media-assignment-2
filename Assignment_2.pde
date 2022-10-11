import controlP5.*;

static final PVector ORIGIN = new PVector();

ControlP5 cp5;
Honeycomb honeycomb;

Dimensions honeycombContainerDim;
PVector guiContainerPos;

void setup() {
  size(1000, 700);
  cp5 = new ControlP5(this);
  honeycombContainerDim = new Dimensions(width, height * 0.8);
  guiContainerPos = PVector.add(ORIGIN, new PVector(0, honeycombContainerDim.h));

  var stateLayout = loadJSONArray("states_layout.json");
  honeycomb = new Honeycomb(width * 0.8, stateLayout);

  cp5.addSlider("setCurrFillLevel")
    .setValue(0.0)
    .setPosition(0.0, guiContainerPos.y)
    .setSize(200, 40)
    .setRange(0.0, 1.0);
}

void draw() {
  background(255);
  push();
  {
    var honeycombDim = honeycomb.getGridDimensions();
    centerWithin(new Bounds(ORIGIN, honeycombContainerDim), honeycombDim);
    honeycomb.draw();
  }
  pop();
}

void setCurrFillLevel(float level) {
  if (honeycomb != null) {
    honeycomb.getCellWithLabel("TX").setFillLevel(level);
    honeycomb.getCellWithLabel("CA").setFillLevel(level);
    honeycomb.getCellWithLabel("FL").setFillLevel(level);
    honeycomb.getCellWithLabel("OK").setFillLevel(level);
    honeycomb.getCellWithLabel("SD").setFillLevel(level);
    honeycomb.getCellWithLabel("ME").setFillLevel(level);
    honeycomb.getCellWithLabel("DC").setFillLevel(level);
  }
}

/**
 * Translates the drawing context such that an item with dimensions `itemDims`
 * will be vertically and horizontally centred within the given `bounds`.
 */
void centerWithin(Bounds bounds, Dimensions itemDim) {
  float translateX = bounds.pos.x + ((bounds.dim.w - itemDim.w) / 2.0);
  float translateY = bounds.pos.y + ((bounds.dim.h - itemDim.h) / 2.0);
  translate(translateX, translateY);
}
