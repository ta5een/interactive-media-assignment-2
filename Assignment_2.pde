import controlP5.*;

// The top-left corner of the window
static final PVector ORIGIN = new PVector();
static final int NUMBER_OF_STATES = 51;
static final int NTH_FRAME_TO_UPDATE = 10;

static final color BACKGROUND_COLOR = #ffffff;
private final color CELL_EMPTY_COLOR = #ffde8c;
private final color CELL_STROKE_COLOR = #ffffff;
private final int CELL_STROKE_WEIGHT = 4;

ControlP5 cp5;
Legend legend;
Honeycomb hc;
Slider slider;

Bounds hcContainerBounds;
Bounds footerContainerBounds;

Table covidDataTable;
int covidDataRowCount = 0;
int covidDataIndex = 0;

boolean shouldPlay = true;

void setup() {
  size(1050, 700);
  legend = new Legend();
  cp5 = new ControlP5(this);

  Dimensions hcContainerDim = new Dimensions(width, height * 0.9);
  hcContainerBounds = new Bounds(ORIGIN, hcContainerDim);

  PVector footerContainerTopLeftPos = PVector.add(ORIGIN, new PVector(0.0, hcContainerBounds.dim.h));
  Dimensions footerContainerDim = new Dimensions(width, height - hcContainerBounds.dim.h);
  footerContainerBounds = new Bounds(footerContainerTopLeftPos, footerContainerDim);

  covidDataTable = loadTable("covid_data.csv", "header");
  covidDataRowCount = covidDataTable.getRowCount();

  JSONArray stateLayout = loadJSONArray("states_layout.json");
  hc = new Honeycomb(width * 0.8, stateLayout);

  Dimensions sliderDim = new Dimensions(footerContainerDim.w * 0.7, 30.0);
  PVector sliderPos = footerContainerBounds.calculateTranslationToCenter(sliderDim);
  slider = cp5.addSlider("setCovidDataIndex")
    .setValue(0)
    .setPosition(sliderPos.x, sliderPos.y)
    .setSize(int(sliderDim.w), int(sliderDim.h))
    .setRange(0, covidDataRowCount);

  Dimensions playToggleDim = new Dimensions(sliderDim.h, sliderDim.h);
  PVector playTogglePos = PVector.sub(sliderPos, new PVector(playToggleDim.w * 1.5, 0.0));
  Toggle toggle = cp5.addToggle("shouldPlay")
    .setLabel("Play/Pause")
    .setPosition(playTogglePos.x, playTogglePos.y)
    .setSize(int(playToggleDim.w), int(playToggleDim.h));

  toggle.getCaptionLabel().setText("Play/Pause").setColor(color(0));
}

void draw() {
  background(BACKGROUND_COLOR);

  push();
  {
    translate(width * 0.5, 10);
    fill(0);
    textSize(24);
    rectMode(CENTER);
    textAlign(CENTER, TOP);
    text("COVID-19 Cases in the United States of America (2020-2022)", 0, 0);
  }
  pop();

  if (covidDataIndex >= covidDataRowCount) {
    covidDataIndex = 0;
  }

  if (covidDataIndex == 0 || frameCount % NTH_FRAME_TO_UPDATE == 0) {
    TableRow row = covidDataTable.getRow(covidDataIndex);
    for (int i = 1; i < NUMBER_OF_STATES; i++) {
      String state = row.getColumnTitle(i);
      int cases = row.getInt(i);
      hc.getCellWithLabel(state).setNumberOfCases(cases);
    }
    slider.setValue(covidDataIndex);
    if (shouldPlay) covidDataIndex++;
  }

  push();
  {
    Dimensions hcDim = hc.getGridDimensions();
    centerWithin(hcContainerBounds, hcDim);
    hc.draw();
  }
  pop();

  push();
  {
    translate(width - 180, height - 300);
    legend.draw();
  }
  pop();
}

void setCovidDataIndex(int newIndex) {
  covidDataIndex = newIndex;
}

/**
 * Translates the drawing context such that something with dimensions `itemDim`
 * will be vertically and horizontally centred within the given `bounds`.
 */
void centerWithin(Bounds bounds, Dimensions itemDim) {
  PVector translation = bounds.calculateTranslationToCenter(itemDim);
  translate(translation.x, translation.y);
}
