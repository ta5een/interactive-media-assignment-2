import controlP5.*;

static final PVector ORIGIN = new PVector();

ControlP5 cp5;
Honeycomb honeycomb;
Slider slider;

Bounds honeycombContainerBounds;
Bounds footerContainerBounds;

Table covidDataTable;
int covidDataRowCount = 0;
int covidDataIndex = 0;

int timeLast = 0;
int timeNow = 0;

void setup() {
  size(1000, 700);
  cp5 = new ControlP5(this);

  var honeycombContainerDim = new Dimensions(width, height * 0.85);
  honeycombContainerBounds = new Bounds(ORIGIN, honeycombContainerDim);

  var footerContainerTopLeftPos = PVector.add(ORIGIN, new PVector(0.0, honeycombContainerBounds.dim.h));
  var footerContainerDim = new Dimensions(width, height - honeycombContainerBounds.dim.h);
  footerContainerBounds = new Bounds(footerContainerTopLeftPos, footerContainerDim);

  covidDataTable = loadTable("covid_data.csv", "header");
  covidDataRowCount = covidDataTable.getRowCount();

  var stateLayout = loadJSONArray("states_layout.json");
  honeycomb = new Honeycomb(width * 0.8, stateLayout);

  var sliderDim = new Dimensions(footerContainerDim.w * 0.7, 30.0);
  var sliderPos = footerContainerBounds.calculateTranslationToCenter(sliderDim);
  slider = cp5.addSlider("setCovidDataIndex")
    .setValue(0)
    .setPosition(sliderPos.x, sliderPos.y)
    .setSize(int(sliderDim.w), int(sliderDim.h))
    .setRange(0, covidDataRowCount);

  timeLast = millis();
}


void draw() {
  timeNow = millis();

  if (covidDataIndex < covidDataRowCount) {
    if (covidDataIndex == 0 || timeNow > timeLast + 300) {
      TableRow row = covidDataTable.getRow(covidDataIndex);
      println(String.format("%d: AL has %d", covidDataIndex, row.getInt("AL")));
      slider.setValue(covidDataIndex);
      covidDataIndex++;
      timeLast = timeNow;
    }
  }

  background(255);
  push();
  {
    var honeycombDim = honeycomb.getGridDimensions();
    centerWithin(honeycombContainerBounds, honeycombDim);
    honeycomb.draw();
  }
  pop();
}

void setCovidDataIndex(int newIndex) {
  covidDataIndex = newIndex;
}

/**
 * Translates the drawing context such that an item with dimensions `itemDim`
 * will be vertically and horizontally centred within the given `bounds`.
 */
void centerWithin(Bounds bounds, Dimensions itemDim) {
  PVector translation = bounds.calculateTranslationToCenter(itemDim);
  translate(translation.x, translation.y);
}
