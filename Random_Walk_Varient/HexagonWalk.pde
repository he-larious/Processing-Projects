class HexagonWalk extends RandomWalk {
  PVector hexPos;
  
  HexagonWalk() {
    factor = (int) (sqrt(3) * stepSize * stepScale);
    hexPos = CartesianToHex(position.x, position.y, stepSize, stepScale, position.x, position.y);
    freq.put(hexPos, 1);
  }

  void Update() {
    int choice = (int) random(1, 7);
    PVector prevPos = new PVector(position.x, position.y);
    
    if (choice == 1) {
      position.x += factor * cos(radians(30));
      position.y += factor * sin(radians(30));
    }
    else if (choice == 2) {
      position.x += factor * cos(radians(90));
      position.y += factor * sin(radians(90));
    }
    else if (choice == 3) {
      position.x += factor * cos(radians(150));
      position.y += factor * sin(radians(150));
    }
    else if (choice == 4) {
      position.x += factor * cos(radians(210));
      position.y += factor * sin(radians(210));
    }
    else if (choice == 5) {
      position.x += factor * cos(radians(270));
      position.y += factor * sin(radians(270));
    }
    else {
      position.x += factor * cos(radians(330));
      position.y += factor * sin(radians(330));
    }
    
    if (isConstrained) {
      if (position.x < min.x || position.x > max.x || position.y < min.y || position.y > max.y) {
        position.x = prevPos.x;
        position.y = prevPos.y;
      }
    }
    
    // Use hex coordinates for hashmap
    hexPos = CartesianToHex(position.x, position.y, stepSize, stepScale, (width + 200) / 2, height / 2);
    updateFreq(hexPos, freq.get(hexPos));
  }

  void Draw() {
    updateColor(hexPos);
    
    // Draw hexagon
    beginShape();
    for (int i = 0; i <= 360; i+= 60) {
      // Radius of hexagon is the stepSize
      float xPos = position.x + cos(radians(i)) * stepSize;
      float yPos = position.y + sin(radians(i)) * stepSize;

      vertex(xPos, yPos);
    }
    endShape();
  }

  // Convert a Cartesian X/Y coordinate to a hex coordinate
  // Inputs:
  //    x         -- The x-coordinate to be converted
  //    y         -- The y-coordinate to be converted
  //    hexRadius -- The radius of the hexagons
  //    stepScale -- The scale of a "step" between hexagons (1.0f should be the default, higher if there is any gap)
  //    xOrigin   -- The x "origin" of your coordinates, if you're starting from somewhere other than 0, 0
  //    yOrigin   -- The y "origin" of your coordinates, if you're starting from somewhere other than 0, 0
  //
  // Return: A PVector containing the x, y value of an equivalent hex
  PVector CartesianToHex(float xPos, float yPos, float hexRadius, float stepScale, float xOrigin, float yOrigin) {
    float startX = xPos - xOrigin;
    float startY = yPos - yOrigin;

    float col = (2.0/3.0f * startX) / (hexRadius * stepScale);
    float row = (-1.0f/3.0f * startX + 1/sqrt(3.0f) * startY) / (hexRadius * stepScale);

    /*===== Convert to Cube Coordinates =====*/
    float x = col;
    float z = row;
    float y = -x - z; // x + y + z = 0 in this system

    float roundX = round(x);
    float roundY = round(y);
    float roundZ = round(z);

    float xDiff = abs(roundX - x);
    float yDiff = abs(roundY - y);
    float zDiff = abs(roundZ - z);

    if (xDiff > yDiff && xDiff > zDiff)
      roundX = -roundY - roundZ;
    else if (yDiff > zDiff)
      roundY = -roundX - roundZ;
    else
      roundZ = -roundX - roundY;

    /*===== Convert Cube to Axial Coordinates =====*/
    PVector result = new PVector(roundX, roundZ);

    return result;
  }
}
