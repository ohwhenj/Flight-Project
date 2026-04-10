// Owen - responsible for boarding gate wall and gatepanel helper class

class GatePanel {
  // panel position and size
  float x, y, w, h;

  // gate/state info
  String gateLabel;
  String stateCode;

  // flight values for this state
  int departures;
  int arrivals;
  int net;

  // set up one gate panel with its data
  GatePanel(float x, float y, float w, float h,
            String gateLabel, String stateCode,
            int departures, int arrivals) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.gateLabel = gateLabel;
    this.stateCode = stateCode;
    this.departures = departures;
    this.arrivals = arrivals;
    this.net = departures - arrivals;
  }

// draw one panel
void display(boolean selected) {
// check hover using scroll-adjusted mouse position
boolean hovered = isMouseOver(scrollY);
  
  // card border changes if selected
  stroke(selected ? color(120, 170, 255) : color(70, 85, 105));
  strokeWeight(selected ? 2.5 : 1);

  // slight colour change on hover
  if (hovered) {
    fill(28, 34, 44);
  } else {
    fill(22, 26, 34);
  }

  rect(x, y, w, h, 12);

  // gate label
  fill(170);
  textAlign(LEFT, TOP);
  textSize(12);
  text(gateLabel, x + 12, y + 10);

  // state code
  fill(245);
  textSize(20);
  text(stateCode, x + 12, y + 34);

  // small status pill instead of full top strip
  String statusText;
  int statusColor;

  if (net > 0) {
    statusText = "OUTBOUND";
    statusColor = color(220, 80, 80);
  } else if (net < 0) {
    statusText = "INBOUND";
    statusColor = color(80, 120, 220);
  } else {
    statusText = "BALANCED";
    statusColor = color(140);
  }

  // draw status pill
  noStroke();
  fill(statusColor);
  rect(x + w - 96, y + 10, 84, 20, 10);

  fill(255);
  textAlign(CENTER, CENTER);
  textSize(10);
  text(statusText, x + w - 54, y + 20);

  // draw state stats
  textAlign(LEFT, TOP);

  fill(70, 130, 220);
  textSize(12);
  text("DEP  " + departures, x + 12, y + 76);

  fill(100, 180, 120);
  text("ARR  " + arrivals, x + 12, y + 98);

  if (net > 0) {
    fill(220, 80, 80);
  } else if (net < 0) {
    fill(80, 120, 220);
  } else {
    fill(170);
  }
  text("NET  " + net, x + 12, y + 120);
}

  // check if mouse is over this panel, accounting for scroll
  boolean isMouseOver(float scrollY) {
  float adjustedMouseY = mouseY - scrollY;

  return mouseX >= x && mouseX <= x + w &&
         adjustedMouseY >= y && adjustedMouseY <= y + h;
}
}
