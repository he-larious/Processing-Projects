class Mesh {
  PShape mesh;
  PVector pos;
  color col;
  
  void LoadMesh(String name) {
    mesh = loadShape("models/" + name + ".obj");
  }
  
  void SetPosition(PVector position) {
    pos = position;
  }
  
  void SetColor(color newColor) {
    col = newColor;
  }
  
  void DrawMesh() {
    pushMatrix();
      translate(pos.x, pos.y, pos.z);
      mesh.setFill(true);
      mesh.setFill(col);
      shape(mesh);
    popMatrix();
  }
}
