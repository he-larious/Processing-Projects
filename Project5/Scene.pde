class Scene {
  int shapeCount;
  Mesh[] meshes;

  int lightCount;
  Light[] lights;

  color backgroundCol;

  // Test file
  Mesh test;
  Light testLight;

  Scene(String file) {
    LoadSceneFile(file);
  }

  void LoadSceneFile(String file) {
    BufferedReader reader = createReader("scenes/" + file);

    try {
      // Get background color
      String line = reader.readLine();
      String values[] = line.split(",");
      backgroundCol = color(Integer.parseInt(values[0]), Integer.parseInt(values[1]), Integer.parseInt(values[2]));

      // Get number of meshes
      shapeCount = Integer.parseInt(reader.readLine());
      meshes = new Mesh[shapeCount];

      // For each mesh...
      for (int i = 0; i < shapeCount; i++) {
        meshes[i] = new Mesh();
        line = reader.readLine();
        values = line.split(",");

        // Get mesh name
        meshes[i].LoadMesh(values[0]);

        // x, y, z position
        float x = Float.parseFloat(values[1]);
        float y = Float.parseFloat(values[2]);
        float z = Float.parseFloat(values[3]);
        meshes[i].SetPosition(new PVector(x, y, z));

        // Mesh color
        int r = Integer.parseInt(values[4]);
        int g = Integer.parseInt(values[5]);
        int b = Integer.parseInt(values[6]);
        meshes[i].SetColor(color(r, g, b));
      }

      // Get number of lights
      lightCount = Integer.parseInt(reader.readLine());
      lights = new Light[lightCount];

      // For each light...
      for (int i = 0; i < lightCount; i++) {
        lights[i] = new Light();
        line = reader.readLine();
        values = line.split(",");

        // x, y, z position
        int x = Integer.parseInt(values[0]);
        int y = Integer.parseInt(values[1]);
        int z = Integer.parseInt(values[2]);
        lights[i].SetPosition(new PVector(x, y, z));

        // Light color
        int r = Integer.parseInt(values[3]);
        int g = Integer.parseInt(values[4]);
        int b = Integer.parseInt(values[5]);
        lights[i].SetColor(color(r, g, b));
      }
    }
    catch (IOException e) {
      e.printStackTrace();
    }
  }

  void DrawScene() {
    background(red(backgroundCol), green(backgroundCol), blue(backgroundCol));

    // Set up lights
    for (int i = 0; i < lightCount; i++) {
      lights[i].DrawLight();
    }

    // Draw each object
    for (int i = 0; i < shapeCount; i++) {
      meshes[i].DrawMesh();
    }
  }

  void LoadTestFile() {
    BufferedReader reader = createReader("scenes/testfile.txt");
    test = new Mesh();
    testLight = new Light();

    try {
      // Test file - first line
      String line = reader.readLine();
      String values[] = line.split(",");

      // Load model");
      test.LoadMesh(values[0]);

      // Load model position
      int x = Integer.parseInt(values[1]);
      int y = Integer.parseInt(values[2]);
      int z = Integer.parseInt(values[3]);
      test.SetPosition(new PVector(x, y, z));

      // Load model color
      int r = Integer.parseInt(values[4]);
      int g = Integer.parseInt(values[5]);
      int b = Integer.parseInt(values[6]);
      test.SetColor(color(r, g, b));

      // Second line
      line = reader.readLine();
      values = line.split(",");

      // Load light position
      int xL = Integer.parseInt(values[0]);
      int yL = Integer.parseInt(values[1]);
      int zL = Integer.parseInt(values[2]);
      testLight.SetPosition(new PVector(xL, yL, zL));

      // Load light color
      int rL = Integer.parseInt(values[3]);
      int gL = Integer.parseInt(values[4]);
      int bL = Integer.parseInt(values[5]);
      testLight.SetColor(color(rL, gL, bL));
    }
    catch (IOException e) {
      e.printStackTrace();
    }
  }

  void DrawTestFile() {
    background(0);

    testLight.DrawLight();
    test.DrawMesh();
  }

  int GetShapeCount() {
    return shapeCount;
  }

  int GetLightCount() {
    return lightCount;
  }
}
