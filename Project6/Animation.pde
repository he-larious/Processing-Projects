// Snapshot in time of some amount of data
class KeyFrame {
  // Where does this thing occur in the animation?
  public float time;
  
  // Because translation and vertex positions are the same thing, this can
  // be reused for either. An array of one is perfectly viable.
  public ArrayList<PVector> points = new ArrayList<PVector>();
  
  KeyFrame(float time) {
    this.time = time;
  }
  
  KeyFrame(float time, PVector pos) {
    this.time = time;
    points.add(pos);
  }
}

class Animation {
  ArrayList<KeyFrame> keyFrames = new ArrayList<KeyFrame>();
  
  // Animations start at zero, and end... here
  float GetDuration() {
    return keyFrames.get(keyFrames.size() - 1).time;
  }
  
  ArrayList<KeyFrame> GetKeyList() {
    return keyFrames;
  }
  
  void AddKeyFrame(KeyFrame keyFrame) {
    keyFrames.add(keyFrame);
  }
  
  // Return the offset of the prev and next key frames
  int[] FindFrames(float currTime) {
    int offsets[] = new int[2];
    
    // Edge case (no key frame at time 0)
    int prevOffset = keyFrames.size() - 1;
    int nextOffset = 0;
    
    for (int i = 0; i < keyFrames.size() - 1; i++) {
      if (currTime > keyFrames.get(i).time && currTime < keyFrames.get(i + 1).time) {
        prevOffset = i;
        nextOffset = i + 1;
        break;
      }
    }
    
    offsets[0] = prevOffset;
    offsets[1] = nextOffset;
    
    return offsets;
  }
}
