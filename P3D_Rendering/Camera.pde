class Camera {
  PVector camPos;
  PVector targetPos;
  ArrayList<PVector> targets;
  float radius;
  int curr;  // Current position in array list

  Camera() {
    camPos = new PVector(0, 0, 0);
    targetPos = new PVector(0, 0, 0);
    targets = new ArrayList<PVector>();
    radius = 160;
    curr = 0;
  }

  void Update() {
    // Map mouse position
    float phi = radians(map(mouseX, 0, width - 1, 0, 360));
    float theta = radians(map(mouseY, 0, height - 1, 0, 179));

    // Change camera position
    camPos.x = targetPos.x + radius * cos(phi) * sin(theta);
    camPos.y = targetPos.y + radius * cos(theta);
    camPos.z = targetPos.z + radius * sin(theta) * sin(phi);

    camera(camPos.x, camPos.y, camPos.z, 
           targetPos.x, targetPos.y, targetPos.z, 
           0, 1, 0);
  }

  void AddLookAtTarget(int x, int y, int z) {
    // Add a target to the array list
    PVector target = new PVector(x, y, z);
    targets.add(target);
  }

  void CycleTarget() {
    curr = (curr == targets.size() - 1) ? 0 : curr + 1;
    targetPos = targets.get(curr);
  }

  void Zoom(float num) {
    float factor = num * 10f;
    
    // Set camera radius between 30 and 250
    if (radius + factor >= 30 && radius + factor <=250) {
      radius += factor;
    }
  }
}
