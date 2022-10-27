import controlP5.*;

// Class objects
ControlP5 cp5;
RandomWalk rwb;

// UI variables
Button startBtn;
DropdownList ddl;
Slider stepMaxSlider;
Slider stepRateSlider;
Slider stepSizeSlider;
Slider stepScaleSlider;
Toggle constrainToggle;
Toggle colorToggle;
Toggle strokeToggle;
Toggle randomToggle;
Textfield seedText;

// Other vairables
boolean isRunning = false;
int stepCount = 0;

void setup() {
  size(1200, 800);
  background(200);
  fill(100);
  rect(0, 0, 200, height);

  cp5 = new ControlP5(this);

  GUI();
}

void GUI() {
  startBtn = cp5.addButton("START")
    .setPosition(10, 10)
    .setSize(100, 30)
    .setColorBackground(color(0, 155, 0));

    ddl = cp5.addDropdownList("SQUARES")
    .setPosition(10, 45)
    .setSize(150, 150)
    .addItem("Squares", 0)
    .addItem("Hexagons", 1)
    .setItemHeight(35)
    .setBarHeight(35)
    .setOpen(false);

  stepMaxSlider = cp5.addSlider("MAXSTEP", 100, 50000)
    .setPosition(10, 200)
    .setSize(180, 25)
    .setDecimalPrecision(0);

  stepRateSlider = cp5.addSlider("STEPRATE", 1, 1000)
    .setPosition(10, 250)
    .setSize(180, 25)
    .setDecimalPrecision(0);

  stepSizeSlider = cp5.addSlider("STEPSIZE", 10, 30)
    .setPosition(10, 350)
    .setSize(80, 25)
    .setDecimalPrecision(0);

  stepScaleSlider = cp5.addSlider("STEPSCALE", 1.0f, 1.5f)
    .setPosition(10, 400)
    .setSize(80, 25);

  constrainToggle = cp5.addToggle("CONSTRAIN STEPS")
    .setPosition(10, 450)
    .setSize(25, 25);

  colorToggle = cp5.addToggle("SIMULATE TERRAIN")
    .setPosition(10, 500)
    .setSize(25, 25);

  strokeToggle = cp5.addToggle("USE STROKE")
    .setPosition(10, 550)
    .setSize(25, 25);

  randomToggle = cp5.addToggle("USE RANDOM SEED")
    .setPosition(10, 600)
    .setSize(25, 25);

  seedText = cp5.addTextfield("SEED VALUE")
    .setPosition(130, 600)
    .setSize(60, 25)
    .setInputFilter(ControlP5.INTEGER)
    .setValue("0");

  // Set UI text
  startBtn.getCaptionLabel().setSize(16);
  ddl.getCaptionLabel().setSize(12);
  
  stepMaxSlider.getCaptionLabel().setVisible(false);
  stepMaxSlider.getValueLabel().setSize(12);
  
  stepRateSlider.getCaptionLabel().setVisible(false);
  stepRateSlider.getValueLabel().setSize(12);
  
  stepSizeSlider.getCaptionLabel().setVisible(false);
  stepSizeSlider.getValueLabel().setSize(12);
  
  stepScaleSlider.getCaptionLabel().setVisible(false);
  stepScaleSlider.getValueLabel().setSize(12);
  
  cp5.addTextlabel("label 1")
      .setText("Maximum Steps")
      .setPosition(10, 188);
      
  cp5.addTextlabel("label 2")
      .setText("Step Rate")
      .setPosition(10, 238);
      
  cp5.addTextlabel("label 3")
      .setText("Step Size")
      .setPosition(10, 338);
      
  cp5.addTextlabel("label 4")
      .setText("Step Scale")
      .setPosition(10, 388);
      
  constrainToggle.getCaptionLabel().setSize(12);
  colorToggle.getCaptionLabel().setSize(12);
  strokeToggle.getCaptionLabel().setSize(12);
  randomToggle.getCaptionLabel().setSize(12);
  seedText.getCaptionLabel().setSize(12);
}

void draw() {
  if (isRunning) {
    for (int i = 0; i < stepRateSlider.getValue(); i++) {
      if (stepCount++ > stepMaxSlider.getValue()) {
        break;
      }   
      rwb.Draw();
      rwb.Update();
    }
  }
  
  // Rerender UI
  rectMode(CORNER);
  fill(100);
  rect(0, 0, 200, height);
}

void START() {
  // Instantiate appropriate class
  if (ddl.getValue() == 0) {
    rwb = new SquareWalk();
    background(200);
  }
  else if (ddl.getValue() == 1) {
    rwb = new HexagonWalk();
    background(169, 218, 255);
  }
  
  // Set seed if random is on
  if (randomToggle.getState()) {
    int seed = Integer.parseInt(seedText.getText());
    randomSeed(seed);
  }
  
  // Reset variables;
  isRunning = true;
  stepCount = 0;
}
