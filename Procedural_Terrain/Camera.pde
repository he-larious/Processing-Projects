class Camera {
  PVector camPos;
  PVector targetPos;
  float radius;
  float phi;    // in radians
  float theta;  // in radians

  Camera() {
    camPos = new PVector(0, 0, 0);
    targetPos = new PVector(0, 0, 0);
    radius = 30;
    phi = radians(90);
    theta = radians(135);
  }

  void Update(float deltaX, float deltaY) {
    phi += deltaX;
    
    // Clamp theta from 0 to 179
    if (theta+ deltaY >= radians(0) && theta + deltaY <= radians(179)) {
      theta += deltaY;
    }
  }
  
  void CameraMatrix() {
    // Change camera position
    camPos.x = targetPos.x + radius * cos(phi) * sin(theta);
    camPos.y = targetPos.y + radius * cos(theta);
    camPos.z = targetPos.z + radius * sin(theta) * sin(phi);
    
    camera(camPos.x, camPos.y, camPos.z, 
           targetPos.x, targetPos.y, targetPos.z, 
           0, 1, 0);
  }

  void Zoom(float num) {
    // Set camera radius between 10 and 200
    if (radius + num >= 10 && radius + num <=200) {
      radius += num;
    }
  }
}
