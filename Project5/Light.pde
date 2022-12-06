class Light {
  PVector pos;
  color col;
  
  void SetPosition(PVector position) {
    pos = position;
  }
  
  void SetColor(color newColor) {
    col = newColor;
  }
  
  void DrawLight() {
    pointLight(red(col), green(col), blue(col), pos.x, pos.y, pos.z);
  }
}
