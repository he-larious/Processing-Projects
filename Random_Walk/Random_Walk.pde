import controlP5.*;

ControlP5 cp5;
Walker w;
Button start;
CheckBox toggle;
Slider iterations;
Slider stepCount;
boolean running = false;
boolean gradualOn = false;
boolean colorOn = false;
int iterCount = 0;

void setup() {
  // Set up window and background
  size(800, 800);
  background(140, 170, 209);

  cp5 = new ControlP5(this);

  // Draw UI
  GUI();
}

void GUI() {
  // Create start button
  start = cp5.addButton("START")
    .setPosition(25, 25)
    .setSize(100, 30);

  // Create toggle buttons
  toggle = cp5.addCheckBox("TOGGLE")
    .setPosition(145, 25)
    .setSize(30, 30)
    .addItem("COLOR", 0)
    .addItem("GRADUAL", 1);

  // Create sliders
  iterations = cp5.addSlider("ITERATIONS")
    .setPosition(270, 25)
    .setRange(1000, 500000)
    .setSize(300, 30);
  stepCount = cp5.addSlider("STEP COUNT")
    .setPosition(270, 56)
    .setRange(1, 1000)
    .setSize(300, 30);

  // Organize UI text
  start.getCaptionLabel().setSize(18);
  toggle.getItem(0).getCaptionLabel().setSize(18);
  toggle.getItem(1).getCaptionLabel().setSize(18);
  iterations.getCaptionLabel().setSize(18);
  iterations.getValueLabel().setSize(18);
  stepCount.getCaptionLabel().setSize(18);
  stepCount.getValueLabel().setSize(18);
}

void draw() {
  // Check state of check boxes
  colorOn = toggle.getState("COLOR") ? true : false;
  gradualOn = toggle.getState("GRADUAL") ? true : false;
  
  // Set default stroke as black
  stroke(0);

  if (running) {

    // If gradual box is checked, display number of steps at a time
    if (gradualOn) {
      for (int i = 0; i < stepCount.getValue(); i++) {

        // Break after total number of iterations is performed
        if (iterCount++ > iterations.getValue()) {
          break;
        }

        // If color box is checked, color the steps based on current iteration
        if (colorOn) {
          int currColor = (int) map(iterCount, 0, iterations.getValue(), 0, 255);
          stroke(currColor);
        }

        w.step();
        w.display();
      }
    }
    // If gradual box isn't checked, display all iterations at once
    else {
      while (iterCount++ < iterations.getValue()) {
        if (colorOn) {
          int currColor = (int) map(iterCount, 0, iterations.getValue(), 0, 255);
          stroke(currColor);
        }
        w.step();
        w.display();
      }
    }
  }
}

void START() {
  // Instantiate new class every time start button is pressed
  w = new Walker();

  // Clear background of previous random walk
  background(140, 170, 209);

  // Reset variables
  running = true;
  iterCount = 0;
}
