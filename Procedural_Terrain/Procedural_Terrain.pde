import controlP5.*;

ControlP5 cp5;

Slider rowSlider;
Slider colSlider;
Slider gridSlider;
Button generateBtn;
Textfield fileText;
Toggle strokeToggle;
Toggle colorToggle;
Toggle blendToggle;
Slider heightSlider;
Slider snowSlider;

Camera camera;
Terrain terrain;
boolean start = false;

void setup() {
  size(1200, 800, P3D);
  background(0);

  cp5 = new ControlP5(this);
  camera = new Camera();
  GUI();
}

void GUI() {
  rowSlider = cp5.addSlider("rows", 1, 100)
                 .setPosition(10, 25)
                 .setSize(100, 10)
                 .setDecimalPrecision(0);
                 
  colSlider = cp5.addSlider("columns", 1, 100)
                 .setPosition(10, 50)
                 .setSize(100, 10)
                 .setDecimalPrecision(0);
  
  gridSlider = cp5.addSlider("terrain size", 20, 50)
                     .setPosition(10, 75)
                     .setSize(100, 10);
  
  generateBtn = cp5.addButton("generate")
                   .setPosition(10, 100)
                   .setSize(75, 20);
  
  fileText = cp5.addTextfield("load from file")
                .setPosition(10, 130)
                .setValue("terrain0");
                
  strokeToggle = cp5.addToggle("stroke").setPosition(250, 25);
  
  colorToggle = cp5.addToggle("color").setPosition(300, 25);
  
  blendToggle = cp5.addToggle("blend").setPosition(350, 25);
  
  heightSlider = cp5.addSlider("height modifier", -5.0f, 5.0f)
                    .setPosition(250, 75)
                    .setSize(100, 10)
                    .setValue(1.0f);
  
  snowSlider = cp5.addSlider("snow threshold", 1.0f, 5.0f)
                  .setPosition(250, 100)
                  .setSize(100, 10);
}

void mouseDragged() {
  if (cp5.isMouseOver()) {
    return;
  }
  
  float deltaX = (mouseX - pmouseX) * 0.01f;
  float deltaY = (mouseY - pmouseY) * 0.01f;
  camera.Update(deltaX, deltaY);
}

void mouseWheel(MouseEvent event) {
  camera.Zoom(event.getCount() * 4f);
}

void draw() {
  background(0);
  
  // Set camera matrices for 3D rendering
  perspective(radians(90), width / (float) height, 0.1, 1000);
  camera.CameraMatrix();
  
  if (start) {
    terrain.Draw();
  }
  
  // Reset to 2D for UI
  perspective();
  camera();
}

void generate() {
  terrain = new Terrain();
  start = true;
}
