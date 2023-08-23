// VertexAnimation Project - Student Version
import java.io.*;
import java.util.*;

/*========== Monsters ==========*/
Animation monsterAnim;
ShapeInterpolator monsterForward = new ShapeInterpolator();
ShapeInterpolator monsterReverse = new ShapeInterpolator();
ShapeInterpolator monsterSnap = new ShapeInterpolator();

/*========== Sphere ==========*/
Animation sphereAnim; // Load from file
Animation spherePos; // Create manually
ShapeInterpolator sphereForward = new ShapeInterpolator();
PositionInterpolator spherePosition = new PositionInterpolator();

/*========== Cubes ==========*/
Animation cubePos;
ArrayList<PositionInterpolator> cubes = new ArrayList<PositionInterpolator>();

Camera camera;

void setup() {
  pixelDensity(2);
  size(1200, 800, P3D);
  
  perspective(radians(90), width / (float) height, 0.1, 1000);
  camera = new Camera();

  /*====== Load Animations ======*/
  monsterAnim = ReadAnimationFromFile("monster.txt");
  sphereAnim = ReadAnimationFromFile("sphere.txt");

  monsterForward.SetAnimation(monsterAnim);
  monsterReverse.SetAnimation(monsterAnim);
  monsterSnap.SetAnimation(monsterAnim);
  monsterSnap.SetFrameSnapping(true);

  sphereForward.SetAnimation(sphereAnim);

  /*====== Create Animations For Cubes ======*/
  cubePos = new Animation();
  cubePos.AddKeyFrame(new KeyFrame(0.5f, new PVector(0, 0, 0)));
  cubePos.AddKeyFrame(new KeyFrame(1.0f, new PVector(0, 0, -100)));
  cubePos.AddKeyFrame(new KeyFrame(1.5f, new PVector(0, 0, 0)));
  cubePos.AddKeyFrame(new KeyFrame(2.0f, new PVector(0, 0, 100)));
  
  // When initializing animations, to offset them you can "initialize" them by 
  // calling Update() with a time value update. Each is 0.1 seconds ahead of
  // the previous one
  for (int i = 0; i < 11; i++) {
    PositionInterpolator perp = new PositionInterpolator();
    perp.SetAnimation(cubePos);
    
    // For every odd cube, don't interpolate
    if (i % 2 == 1) {
      perp.SetFrameSnapping(true);
    }
    
    perp.Update(i * 0.1f);
    cubes.add(perp);
  }

  /*====== Create Animations For Spheroid ======*/
  spherePos = new Animation();
  spherePos.AddKeyFrame(new KeyFrame(1.0f, new PVector(-100, 0, 100)));
  spherePos.AddKeyFrame(new KeyFrame(2.0f, new PVector(-100, 0, -100)));
  spherePos.AddKeyFrame(new KeyFrame(3.0f, new PVector(100, 0, -100)));
  spherePos.AddKeyFrame(new KeyFrame(4.0f, new PVector(100, 0, 100)));
  spherePosition.SetAnimation(spherePos);
}

void draw() {
  lights();
  background(0);

  float playbackSpeed = 0.005f;

  // Implement your own camera
  camera.CameraMatrix();
  
  DrawGrid();

  /*====== Draw Forward Monster ======*/
  pushMatrix();
    translate(-40, 0, 0);
    monsterForward.fillColor = color(128, 200, 54);
    monsterForward.Update(playbackSpeed);
    shape(monsterForward.currentShape);
  popMatrix();

  /*====== Draw Reverse Monster ======*/
  pushMatrix();
    translate(40, 0, 0);
    monsterReverse.fillColor = color(220, 80, 45);
    monsterReverse.Update(-playbackSpeed);
    shape(monsterReverse.currentShape);
  popMatrix();

  /*====== Draw Snapped Monster ======*/
  pushMatrix();
    translate(0, 0, -60);
    monsterSnap.fillColor = color(160, 120, 85);
    monsterSnap.Update(playbackSpeed);
    shape(monsterSnap.currentShape);
  popMatrix();

  /*====== Draw Spheroid ======*/
  spherePosition.Update(playbackSpeed);
  sphereForward.fillColor = color(39, 110, 190);
  sphereForward.Update(playbackSpeed);
  PVector pos = spherePosition.currentPosition;
  pushMatrix();
    translate(pos.x, pos.y, pos.z);
    shape(sphereForward.currentShape);
  popMatrix();

  /*====== Update and draw cubes ======*/
  noStroke();
  int xOffset = -100;
  
  // For each interpolator, update/draw
  for (int i = 0; i < cubes.size(); i++) {
    PositionInterpolator currPerp = cubes.get(i);
    currPerp.Update(playbackSpeed);
    PVector currPos = currPerp.currentPosition;
    
    if (i % 2 == 0) {
      fill(255, 0, 0);   // Red cube
    }
    else {
      fill(255, 255, 0);  // Yellow cube
    }
    
    pushMatrix();
      translate(currPos.x + xOffset, currPos.y, currPos.z);
      box(10.0f);
    popMatrix();
    
    xOffset += 20;
  }
}

void mouseDragged() {
  float deltaX = (mouseX - pmouseX) * 0.01f;
  float deltaY = (mouseY - pmouseY) * 0.01f;
  camera.Update(deltaX, deltaY);
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  camera.Zoom(e * 10.0f);
}

// Create and return an animation object
Animation ReadAnimationFromFile(String fileName) {
  Animation animation = new Animation();

  //The BufferedReader class will let you read in the file data
  try {
    BufferedReader reader = createReader(fileName);
    
    // Get number of key frames in animation
    String line = reader.readLine();
    int numKeys = Integer.parseInt(line);
    
    // Get number of data points for each frame in animation
    line = reader.readLine();
    int numData = Integer.parseInt(line);
    
    for (int i = 0; i < numKeys; i++) {
      // Get time for current key frame
      line = reader.readLine();
      float time = Float.parseFloat(line);
      
      KeyFrame keyFrame = new KeyFrame(time);
      
      for (int j = 0; j < numData; j++) {
        // Get position of a vertex of the mesh at current time
        line = reader.readLine();
        String values[] = line.split(" ");
        float x = Float.parseFloat(values[0]);
        float y = Float.parseFloat(values[1]);
        float z = Float.parseFloat(values[2]);
        
        // Create new key frame and add to animation
        keyFrame.points.add(new PVector(x, y, z));
        animation.AddKeyFrame(keyFrame);
      }
    }
    
  }
  catch (FileNotFoundException ex) {
    println("File not found: " + fileName);
  }
  catch (IOException ex) {
    ex.printStackTrace();
  }

  return animation;
}

void DrawGrid() {
  // Dimensions: 200x200 (-100 to +100 on X and Z)
  stroke(255);
  strokeWeight(2);

  for (int i = -100; i <= 100; i += 10) {
    if (i == 0) {
      continue;
    }

    // Draw grid lines parallel to x-axis
    line(-100, 0, i, 100, 0, i);

    // Draw grid lines prallel to z-axis
    line(i, 0, -100, i, 0, 100);
  }

  // Draw x-axis and color red
  stroke(255, 0, 0);
  line(-100, 0, 0, 100, 0, 0);

  // Draw z-axis and color blue
  stroke(0, 0, 255);
  line(0, 0, -100, 0, 0, 100);
}
