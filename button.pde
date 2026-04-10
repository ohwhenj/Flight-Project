// create by Roy
class Button {
  int x, y, w, h;
  String label;

  int baseColor;
  int hoverColor;

  // how buttons created
  Button(int x, int y, int w, int h, String label) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;

    baseColor = color(50, 100, 200);
    hoverColor = color(100, 150, 255);
  }

  //create the different colour displaying
  void display() {
    noStroke();
    if (isHovered()) {
      fill(hoverColor);
    } else {
      fill(baseColor);
    }

    rect(x, y, w, h, 10);

    // to add the text for each button
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(18);
    text(label, x + w/2, y + h/2);
  }

  
  boolean isHovered() {
    return mouseX > x && mouseX < x+w &&
           mouseY > y && mouseY < y+h;
  }

  boolean isClicked() {
    return isHovered();
  }
}
