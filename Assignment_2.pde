import controlP5.*;
import java.text.DecimalFormat;

// The top-left corner of the window
static final PVector ORIGIN = new PVector();
static final int NTH_FRAME_TO_UPDATE = 30;

ControlP5 cp5;
Honeycomb hc;
Slider slider;

Bounds hcContainerBounds;
Bounds footerContainerBounds;

Table covidDataTable;
int covidDataRowCount = 0;
int covidDataIndex = 0;
int currentMaximum = 0;

boolean shouldPlay = true;

void setup() {
  size(1000, 700);
  cp5 = new ControlP5(this);

  Dimensions hcContainerDim = new Dimensions(width, height * 0.85);
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
  cp5.addToggle("shouldPlay")
    .setLabel("Play/Pause")
    .setPosition(playTogglePos.x, playTogglePos.y)
    .setSize(int(playToggleDim.w), int(playToggleDim.h));
}

void draw() {
  background(255);

  if (covidDataIndex >= covidDataRowCount) {
    covidDataIndex = 0;
  }

  if (covidDataIndex == 0 || frameCount % NTH_FRAME_TO_UPDATE == 0) {
    TableRow row = covidDataTable.getRow(covidDataIndex);
    String rowLabel = row.getString(0);
    boolean shouldIncreaseMaximum = (rowLabel.contains("January") || rowLabel.contains("July")) && rowLabel.contains("Fn 1");
    for (int i = 1; i < 51; i++) {
      String state = row.getColumnTitle(i);
      int cases = row.getInt(i);
      hc.getCellWithLabel(state).setNumberOfCases(cases);
      if (shouldIncreaseMaximum && cases > currentMaximum) {
        currentMaximum = cases;
      }
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
    textSize(20);
    fill(0);
    DecimalFormat formatter = new DecimalFormat("Maximum: #,###");
    text(formatter.format(currentMaximum), 10, 25);
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
