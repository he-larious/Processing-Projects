class Walker {
  int x;
  int y;

  Walker() {
    x = width / 2;
    y = height / 2;
  }

  void display() {
    point(x, y);
  }

  void step() {
    int choice = (int) random(4);

    if (choice == 0) {
      y--;  // move up
    }
    else if (choice == 1) {
      y++;  // move down
    }
    else if (choice == 2) {
      x--;  // move left
    }
    else {
      x++;  // move right
    }

    // Clamp values
    x = constrain(x, 0, width);
    y = constrain(y, 0, height);
  }
}
