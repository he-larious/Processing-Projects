import controlP5.*;

ControlP5 cp5;

Camera camera;
PShape hexFan;
PShape ngonFan;
PShape cube;
PShape regMon;
PShape wireMon;
int radius = 10;

void setup() {
  size(1600, 1000, P3D);
  cp5 = new ControlP5(this);
  camera = new Camera();

  // Set projection matrix
  perspective(radians(50.0f), width / (float) height, 0.1, 1000);

  // Use middle of screen as origin
  translate(width / 2, height / 2, 0);

  // Add look at targets to camera
  camera.AddLookAtTarget(0, 0, 0);
  camera.AddLookAtTarget(75, 0, 0);
  camera.AddLookAtTarget(-100, 0, 0);
  camera.AddLookAtTarget(-50, 0, 0);

  // Create shapes
  hexFanShape();
  ngonFanShape();
  cubeShape(1);
  
  // Create monsters
  regularMonster();
  wireMonster();
}

void draw() {
  background(150);
  grid();

  // Draw fans
  pushMatrix();
    translate(-50, -radius, 0);     // Fans should be located above the xz plane
    
    // Draw hex fan
    pushMatrix();
      translate(radius + 2, 0, 0);
      shape(hexFan);
    popMatrix();
    
    // Draw ngon fan
    pushMatrix();
      translate(-radius - 2, 0, 0);
      shape(ngonFan);
    popMatrix();
  popMatrix();
  
  // Draw cubes
  pushMatrix();
    translate(-100, 0, 0);
    
    // Draw middle cube
    pushMatrix();
      scale(5, 5, 5);
      shape(cube);
    popMatrix();
    
    // Draw left cube
    pushMatrix();
      translate(-10, 0, 0);
      shape(cube);
    popMatrix();
    
    // Draw right cube
    pushMatrix();
      translate(10, 0, 0);
      scale(10, 20, 10);
      shape(cube);
    popMatrix();
  popMatrix();
  
  // Draw monsters
  pushMatrix();
    scale(0.5);
    rotate(PI);      // Flip upside down to orient monster correctly
    shape(regMon);
  popMatrix();
  
  pushMatrix();
    translate(75, 0, 0);
    rotate(PI);
    shape(wireMon);
  popMatrix();

  // Update camera
  camera.Update();
}

void keyPressed() {
  // ASCII value of space
  if (key == 32) {
    camera.CycleTarget();
  }
}

void mouseWheel(MouseEvent event) {
  // Send a mouse wheel count to zoom the camera
  camera.Zoom(event.getCount());
}

void grid() {
  colorMode(RGB, 255);
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

void hexFanShape() {
  colorMode(HSB, 360, 100, 100);
  
  hexFan = createShape();
  hexFan.beginShape(TRIANGLE_FAN);

  for (float angle = 0; angle <= 360; angle += 60) {
    float x = cos(radians(angle)) * radius;
    float y = sin(radians(angle)) * radius;

    hexFan.fill(angle, 100, 100);
    hexFan.vertex(x, y);
  }

  hexFan.endShape();
}

void ngonFanShape() {
  colorMode(HSB, 360, 100, 100);
  
  ngonFan = createShape();
  ngonFan.beginShape(TRIANGLE_FAN);

  for (float angle = 0; angle <= 360; angle += 18) {
    float x = cos(radians(angle)) * radius;
    float y = sin(radians(angle)) * radius;
    
    ngonFan.fill(angle, 100, 100);
    ngonFan.vertex(x, y);
  }

  ngonFan.endShape();
}

void cubeShape(float size) {
  float s = size * 0.5f;
  colorMode(RGB, 255);
  
  cube = createShape();
  cube.beginShape(TRIANGLE);
  cube.noStroke();
  
  // Front face - triangle 1
  cube.fill(255, 255, 0);
  cube.vertex(-s, -s, s);
  cube.vertex(-s, s, s);
  cube.vertex(s, s, s);
  
  // Front face - triangle 2
  cube.fill(0, 255, 0);
  cube.vertex(-s, -s, s);
  cube.vertex(s, -s, s);
  cube.vertex(s, s, s);
  
  // Left face - triangle 1
  cube.fill(255, 0, 0);
  cube.vertex(-s, -s, s);
  cube.vertex(-s, -s, -s);
  cube.vertex(-s, s, s);
  
  // Left face - triangle 2
  cube.fill(0, 0, 255);
  cube.vertex(-s, -s, -s);
  cube.vertex(-s, s, -s);
  cube.vertex(-s, s, s);
  
  // Right face - triangle 1
  cube.fill(255, 0, 128);
  cube.vertex(s, s, -s);
  cube.vertex(s, -s, s);
  cube.vertex(s, s, s);
  
  // Right face - triangle 2
  cube.fill(128, 255, 0);
  cube.vertex(s, -s, -s);
  cube.vertex(s, -s, s);
  cube.vertex(s, s, -s);
  
  // Back face - triangle 1
  cube.fill(255, 128, 0);
  cube.vertex(s, s, -s);
  cube.vertex(s, -s, -s);
  cube.vertex(-s, -s, -s);
  
  // Back face - triangle 2
  cube.fill(0, 128, 255);
  cube.vertex(s, s, -s);
  cube.vertex(-s, s, -s);
  cube.vertex(-s, -s, -s);
  
  // Top face - triangle 1
  cube.fill(255, 0, 255);
  cube.vertex(-s, -s, s);
  cube.vertex(s, -s, s);
  cube.vertex(-s, -s, -s);
  
  // Top face - triangle 2
  cube.fill(0, 255, 255);
  cube.vertex(s, -s, -s);
  cube.vertex(s, -s, s);
  cube.vertex(-s, -s, -s);
  
  // Bottom face - triangle 1
  cube.fill(128, 0, 255);
  cube.vertex(s, s, -s);
  cube.vertex(-s, s, -s);
  cube.vertex(s, s, s);
  
  // Bottom face - triangle 2
  cube.fill(0, 255, 128);
  cube.vertex(-s, s, s);
  cube.vertex(-s, s, -s);
  cube.vertex(s, s, s);
  
  cube.endShape();
}

void regularMonster() {
  regMon = loadShape("monster.obj");
  regMon.setFill(color(255, 255, 0));
}

void wireMonster() {
  wireMon = loadShape("monster.obj");
  wireMon.setFill(color(0, 0, 0, 0));
  wireMon.setStroke(true);
  wireMon.setStroke(color(0));
  wireMon.setStrokeWeight(2.0f);
}
