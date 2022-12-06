class Terrain {
  ArrayList<PVector> vertices;
  ArrayList<Integer> indices;

  int rows;
  int cols;
  float gridSize;
  float heightMod;

  PImage heightImage;
  float snowThresh;
  color snow;
  color rock;
  color grass;
  color dirt;
  color water;

  Terrain() {
    vertices = new ArrayList<PVector>();
    indices = new ArrayList<Integer>();

    rows = (int) rowSlider.getValue();
    cols = (int) colSlider.getValue();
    gridSize = gridSlider.getValue();

    // Initialize colors
    snow = color(255, 255, 255);
    rock = color(135, 135, 135);
    grass = color(143, 170, 64);
    dirt = color(160, 126, 84);
    water = color(0, 75, 200);

    // Set up grid
    Grid();

    // Set up height map if an image is loaded
    if (!fileText.getText().equals("")) {
      heightImage = loadImage(fileText.getText() + ".png");
      HeightMap();
    }
  }

  void Grid() {
    float rowSpace = gridSize / rows;
    float colSpace = gridSize / cols;
    float halfGrid = gridSize / 2;

    // Generate vertex positions
    float xPos = -halfGrid;
    float zPos = -halfGrid;

    for (int i = 0; i <= rows; i++) {
      xPos = -halfGrid;
      for (int j = 0; j <= cols; j++) {
        vertices.add(new PVector(xPos, 0, zPos));
        xPos += rowSpace;
      }
      zPos += colSpace;
    }

    // Generate triangle indices
    int numVertRow = cols + 1;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        int startIndex = row * numVertRow + col;

        // First triangle of current quad
        indices.add(startIndex);
        indices.add(startIndex + 1);
        indices.add(startIndex + numVertRow);

        // Second triangle of current quad
        indices.add(startIndex + 1);
        indices.add(startIndex + numVertRow + 1);
        indices.add(startIndex + numVertRow);
      }
    }
  }

  void HeightMap() {
    for (int i = 0; i <= rows; i++) {
      for (int j = 0; j <= cols; j++) {
        // There's one more vertices row/column than polygon row/column
        int xIndex = (int) map(j, 0, cols + 1, 0, heightImage.width);
        int yIndex = (int) map(i, 0, rows + 1, 0, heightImage.height);
        color heightColor = heightImage.get(xIndex, yIndex);

        // Gray scale image -> RGB values are all the same
        float yHeight = map(red(heightColor), 0, 255, 0, 1.0f);

        int vertIndex = i * (cols + 1) + j;
        vertices.get(vertIndex).y = -yHeight;  // Processing has inverted y-axis
      }
    }
  }

  void Draw() {
    if (strokeToggle.getState()) {
      stroke(0);
    }
    else {
      noStroke();
    }

    fill(255);
    
    heightMod = heightSlider.getValue();
    snowThresh = snowSlider.getValue();

    beginShape(TRIANGLES);

    for (int i = 0; i < indices.size(); i++) {
      // Get current vertex index and look it up in the vertices list
      int vertIndex = indices.get(i);
      PVector vert = vertices.get(vertIndex);
      
      // Map color and blend if needed
      boolean colorOn = colorToggle.getState();
      boolean blendOn = blendToggle.getState();
      
      if (colorOn) {
        float relHeight = abs(vert.y) * heightMod / snowThresh;
        
        if (relHeight > 0.8f) {
          if (blendOn) {
            float ratio = (relHeight - 0.8f) / 0.2f;
            color blendColor = lerpColor(rock, snow, ratio);
            fill(blendColor);
          }
          else {
            fill(snow);
          }
        }
        else if (relHeight > 0.4f && relHeight <= 0.8f) {
          if (blendOn) {
            float ratio = (relHeight - 0.4f) / 0.4f;
            color blendColor = lerpColor(grass, rock, ratio);
            fill(blendColor);
          }
          else {
            fill(rock);
          }
        }
        else if (relHeight > 0.2f && relHeight <= 0.4f) {
          if (blendOn) {
            float ratio = (relHeight - 0.2f) / 0.2f;
            color blendColor = lerpColor(dirt, grass, ratio);
            fill(blendColor);
          }
          else {
            fill(grass);
          }
        }
        else {
          if (blendOn) {
            float ratio = relHeight / 0.2f;
            color blendColor = lerpColor(water, dirt, ratio);
            fill(blendColor);
          }
          else {
            fill(water);
          }
        }
      }

      // Draw vertex
      vertex(vert.x, vert.y * heightMod, vert.z);
    }

    endShape();
  }
}
