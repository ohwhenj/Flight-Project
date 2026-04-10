/// Roy Zha - Main page UI
class Background {
  float x, y;
  float speed = 0;
  
  // where plane at
  Background() {
    x = 220;
    y = 250;
  }

  //how the plane drawn
  void drawPlane() {
    fill(200);
    noStroke();

    triangle(x, y, x+80, y-30, x+80, y-8);
    triangle(x+160, y, x+80, y-30, x+80, y-8);

    stroke(0, 0, 255);
    line(x, y, x+80, y-20);
    line(x+160, y, x+80, y-20);

    noStroke();
    fill(200);
    ellipse(x+80, y-40, 20, 35);
    rect(x+77.5, y-40, 5, 80);

    triangle(x+70, y-40, x+80, y-40, x+77.5, y+40);
    triangle(x+90, y-40, x+80, y-40, x+82.5, y+40);

    fill(0, 30, 225);
    triangle(x+65, y+37, x+80, y+36.5, x+80, y+25);
    triangle(x+95, y+37, x+80, y+36.5, x+80, y+25);

    stroke(0, 0, 255);
    line(x+80, y-40, x+80, y+40);
    noStroke();
  }

  //the road for airplane sliding
  void drawRunway() { 
    fill(0); 
    rect(200, 0, 200, 650); 
    fill(255); 

    for (int i = 20; i <= 650; i += 60) {
      rect(295, i, 10, 40);
    }
  }

  //the movement for the plane
  void movePlane() {
    speed += 0.05;
    y -= speed;

    if (y < -100) {
      speed = 0;
      y = height + 200;
    }
  }
}
