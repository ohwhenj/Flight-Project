StateHeatMap heatMap;
StateQueryChart stateChart;

int screen = 0;

Button flightsBtn;
Button graphBtn;
Button backBtn;

Button heatMapBtn;
Button stateQueryBtn;

Background plane;
FlightForm flightForm;

void setup() {
  size(1000, 650);

  heatMap = new StateHeatMap("usa-wikipedia.svg", "flights2k.csv", -250, -110);

  flightsBtn = new Button(425, 250, 200, 50, "Flight Boards");
  graphBtn   = new Button(425, 400, 200, 50, "Graphs");
  backBtn    = new Button(20, 20, 100, 40, "Back");

  heatMapBtn = new Button(390, 220, 220, 60, "Heat Map");
  stateQueryBtn = new Button(390, 320, 220, 60, "State Query Chart");

  plane = new Background();

  // ✅ ONLY ONE LINE NEEDED
  flightForm = new FlightForm("flights2k.csv");

  stateChart = new StateQueryChart("flights2k.csv");
}

void draw() {
  background(90, 160, 90);

  if (screen == 0) {
    plane.drawRunway();
    plane.drawPlane();
    plane.movePlane();
    drawMenu();
  } 
  else if (screen == 1) {
    drawFlights();
  } 
  else if (screen == 2) {
    drawGraphs();
  }
  else if (screen == 3){
    drawHeatMapPage();
  }
  else if (screen == 4) {
    drawStateQueryPage();
  }
}

void drawMenu() {
  textAlign(CENTER, CENTER);
  textSize(32);
  fill(0);
  text("SkyFly Menu", 525, 80);

  flightsBtn.display();
  graphBtn.display();
}

void drawFlights() {
  backBtn.display();
  flightForm.display(); // ✅ everything handled inside
}

void drawGraphs() {
  textAlign(CENTER, CENTER);
  textSize(24);
  fill(40);
  text("Traffic Visualisations", 525, 100);

  heatMapBtn.display();
  stateQueryBtn.display();
  backBtn.display();
}

void drawHeatMapPage() {
  heatMap.display();
  backBtn.display();
}

void drawStateQueryPage() {
  stateChart.display();
  backBtn.display();
}

// 🎮 INPUT FORWARDING

void mousePressed() {
  if (screen == 0) {
    if (flightsBtn.isClicked()) screen = 1;
    if (graphBtn.isClicked()) screen = 2;
  }

  else if (screen == 2) {
    if (heatMapBtn.isClicked()) screen = 3;
    if (stateQueryBtn.isClicked()) screen = 4;
    if (backBtn.isClicked()) screen = 0;
  }

  else if (screen == 3) {
    heatMap.mousePressed();
    if (backBtn.isClicked()) screen = 2;
  }

  else if (screen == 4) {
    if (backBtn.isClicked()) screen = 2;
  }

  if (screen == 1) {
    if (backBtn.isClicked()) screen = 0;
    flightForm.mousePressed();
  }
}

void mouseDragged() {
  if (screen == 1) flightForm.mouseDragged();
}

void mouseReleased() {
  if (screen == 1) flightForm.mouseReleased();
}

void keyPressed() {
  if (screen == 1) flightForm.keyPressed();
  else if (screen == 4) stateChart.keyPressed();
}

void mouseWheel(processing.event.MouseEvent event) {
  if (screen == 1) {
    flightForm.mouseWheel(event.getCount());
  }
}
