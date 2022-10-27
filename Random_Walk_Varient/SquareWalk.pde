class SquareWalk extends RandomWalk {
  SquareWalk() {
    factor = (int) (stepSize * stepScale);
    freq.put(position, 1);
  }

  void Update() {
    int choice = (int) random(1, 5);
    PVector prevPos = new PVector(position.x, position.y);

    if (choice == 1) {  // move left
      position.x -= factor;
    }
    else if (choice == 2) {  // move right
      position.x += factor;
    }
    else if (choice == 3) {  // move up
      position.y -= factor;
    }
    else {  // move down
      position.y += factor;
    }
    
    // Constrain if neeeded
    if (isConstrained) {
      if (position.x < min.x || position.x > max.x || position.y < min.y || position.y > max.y) {
        position.x = prevPos.x;
        position.y = prevPos.y;
      }
    }
    
    // Update frequency of position in map
    updateFreq(position, freq.get(position));
  }

  void Draw() {
    updateColor(position);
    
    // Draw shape
    rectMode(CENTER);
    rect(position.x, position.y, stepSize, stepSize);
  }
}
