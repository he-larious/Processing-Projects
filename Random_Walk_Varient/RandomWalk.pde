abstract class RandomWalk {
  int stepSize;
  float stepScale;
  int factor;
  boolean isColor;
  boolean isStroke;
  boolean isConstrained;
  PVector position;
  PVector min;  // Min bound for position vector
  PVector max;  // Max bound for position vector
  HashMap<PVector, Integer> freq;

  RandomWalk() {
    // Initialize with UI variables
    stepSize = (int) stepSizeSlider.getValue();
    stepScale = stepScaleSlider.getValue();
    isColor = colorToggle.getState();
    isStroke = strokeToggle.getState();
    isConstrained = constrainToggle.getState();

    // Start at center of display screen
    position = new PVector((width + 200) / 2, height / 2);
    
    // Constrain within display screen (don't draw over UI rectangle)
    min = new PVector(200 + stepSize, stepSize);
    max = new PVector(width - stepSize, height - stepSize);
    
    freq = new HashMap<PVector, Integer>();
    
    // Update stroke for new walk
    if (isStroke) {
      stroke(0);
    }
    else {
      noStroke();
    }
  }

  void updateFreq(PVector pos, Integer count) {
    if (count == null) {
      freq.put(pos, 1);
    }
    else {
      freq.put(pos, count + 1);
    }
  }

  void updateColor(PVector pos) {
    if (isColor) {
      if (freq.get(pos) < 4) {
        fill(160, 126, 84);
      } 
      else if (freq.get(pos) < 7) {
        fill(143, 170, 64);
      } 
      else if (freq.get(pos) < 10) {
        fill(135);
      } 
      else {
        int newColor = freq.get(pos) * 20;
        constrain(newColor, 0, 255);
        fill(newColor);
      }
    } 
    else {
      fill(167, 100, 200);
    }
  }

  abstract void Update();
  abstract void Draw();
}
