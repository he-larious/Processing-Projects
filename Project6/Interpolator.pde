abstract class Interpolator {
  Animation animation;
  
  // Where we at in the animation?
  float currentTime = 0;
  
  // To interpolate, or not to interpolate... that is the question
  boolean snapping = false;
  
  void SetAnimation(Animation anim) {
    animation = anim;
  }
  
  void SetFrameSnapping(boolean snap) {
    snapping = snap;
  }
  
  void UpdateTime(float time) {
    // Update the current time
    currentTime += time;
    
    // Check to see if the time is out of bounds (0 / Animation_Duration)
    // If so, adjust by an appropriate amount to loop correctly
    if (currentTime < 0) {
      currentTime = animation.GetDuration();
    }
    else if (currentTime > animation.GetDuration()) {
      currentTime = 0;
    }
  }
  
  // Implement this in derived classes
  // Each of those should call UpdateTime() and pass the time parameter
  // Call that function FIRST to ensure proper synching of animations
  abstract void Update(float time);
}

class ShapeInterpolator extends Interpolator {
  // The result of the data calculations - either snapping or interpolating
  PShape currentShape;
  
  // Changing mesh colors
  color fillColor;
  
  PShape GetShape() {
    return currentShape;
  }
  
  void Update(float time) {
    // Create a new PShape by interpolating between two existing key frames
    // using linear interpolation
    UpdateTime(time);
    
    // Determine prev and next key frame
    int[] offsets = animation.FindFrames(currentTime);
    KeyFrame prev = animation.GetKeyList().get(offsets[0]);
    KeyFrame next = animation.GetKeyList().get(offsets[1]);
    
    // Determine ratio of current time to prev/next times
    float ratio = (currentTime - prev.time) / (next.time - prev.time);
    if (ratio > 1) {
      // Edge case (no key frame at time 0)
      ratio = currentTime / next.time;
    }
    
    // Interpolate and determine current data set and update current shape
    currentShape = createShape();
    currentShape.beginShape(TRIANGLES);
    currentShape.noStroke();
    
    for (int i = 0; i < prev.points.size(); i++) {
      PVector prevPos = prev.points.get(i);
      PVector nextPos = next.points.get(i);
      
      float x = lerp(prevPos.x, nextPos.x, ratio);
      float y = lerp(prevPos.y, nextPos.y, ratio);
      float z = lerp(prevPos.z, nextPos.z, ratio);
      
      currentShape.fill(fillColor);
      
      if (snapping) {
        currentShape.vertex(nextPos.x, nextPos.y, nextPos.z);
      }
      else {
        currentShape.vertex(x, y, z);
      }
    }
    
    currentShape.endShape();
  }
}

class PositionInterpolator extends Interpolator {
  PVector currentPosition;
  
  void Update(float time) {
    // The same type of process as the ShapeInterpolator class... except
    // this only operates on a single point
    UpdateTime(time);
    
    // Determine prev and next key frame
    int[] offsets = animation.FindFrames(currentTime);
    KeyFrame prev = animation.GetKeyList().get(offsets[0]);
    KeyFrame next = animation.GetKeyList().get(offsets[1]);
    
    // Determine ratio of current time to prev/next times
    float ratio = (currentTime - prev.time) / (next.time - prev.time);
    if (ratio > 1) {
      // Edge case (no key frame at time 0)
      ratio = currentTime / next.time;
    }
    
    // Interpolate and determine current data set
    PVector prevPos = prev.points.get(0);
    PVector nextPos = next.points.get(0);
    
    float x = lerp(prevPos.x, nextPos.x, ratio);
    float y = lerp(prevPos.y, nextPos.y, ratio);
    float z = lerp(prevPos.z, nextPos.z, ratio);
    
    // Update current position
    currentPosition = snapping ? nextPos : new PVector(x, y, z);
  }
}
