import controlP5.*;

static final PVector ORIGIN = new PVector();

ControlP5 cp5;
Honeycomb honeycomb;
Slider slider;

Bounds honeycombContainerBounds;
Bounds footerContainerBounds;

void setup() {
  size(1000, 700);
  cp5 = new ControlP5(this);

  var honeycombContainerDim = new Dimensions(width, height * 0.85);
  honeycombContainerBounds = new Bounds(ORIGIN, honeycombContainerDim);

  var footerContainerTopLeftPos = PVector.add(ORIGIN, new PVector(0.0, honeycombContainerBounds.dim.h));
  var footerContainerDim = new Dimensions(width, height - honeycombContainerBounds.dim.h);
  footerContainerBounds = new Bounds(footerContainerTopLeftPos, footerContainerDim);

  var stateLayout = loadJSONArray("states_layout.json");
  honeycomb = new Honeycomb(width * 0.8, stateLayout);

  var sliderDim = new Dimensions(footerContainerDim.w * 0.7, 30.0);
  var sliderPos = footerContainerBounds.calculateTranslationToCenter(sliderDim);
  slider = cp5.addSlider("setCurrFillLevel")
    .setValue(0.0)
    .setPosition(sliderPos.x, sliderPos.y)
    .setSize(int(sliderDim.w), int(sliderDim.h))
    .setRange(0.0, 1.0);
}

void draw() {
  background(255);
  push();
  {
    var honeycombDim = honeycomb.getGridDimensions();
    centerWithin(honeycombContainerBounds, honeycombDim);
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
 * Translates the drawing context such that an item with dimensions `itemDim`
 * will be vertically and horizontally centred within the given `bounds`.
 */
void centerWithin(Bounds bounds, Dimensions itemDim) {
  PVector translation = bounds.calculateTranslationToCenter(itemDim);
  translate(translation.x, translation.y);
}
