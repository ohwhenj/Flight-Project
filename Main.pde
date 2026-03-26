// Week 3 - Owen - Integrated heatmap + query search into graphs page of sketch produced by Roy

StateHeatMap heatMap;
StateQueryChart stateChart;

int screen = 0;

Button flightsBtn;
Button graphBtn;
Button SearchBtn;
Button backBtn;

Button heatMapBtn;
Button stateQueryBtn;


Background plane;
FlightForm flightForm;

void setup() {
  size(1000, 650);
  
  heatMap = new StateHeatMap("usa-wikipedia.svg", "flights2k.csv", -250, -110);

  flightsBtn = new Button(425, 150, 200, 50, "Flights");
  graphBtn   = new Button(425, 250, 200, 50, "Graphs");
  SearchBtn   = new Button(425, 350, 200, 50, "Search");
  backBtn    = new Button(20, 20, 100, 40, "Back");
  heatMapBtn = new Button(40, 150, 220, 60, "Heat Map");
  stateQueryBtn = new Button(40, 250, 220, 60, "State Query Chart");

  plane = new Background();

  flightForm = new FlightForm("flights2k.csv", 120, 120, 760, 420);
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
    drawSearch();
  }

    else if (screen == 4){
    drawHeatMapPage();
  }
  else if (screen == 5) {
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
  SearchBtn.display();
}

void drawFlights() {

  fill(20);
  textAlign(CENTER, CENTER);
  textSize(28);
  text("Flight Form", width/2, 60);

  backBtn.display();
  flightForm.display();
}

void drawGraphs() {

  fill(20);
  textAlign(CENTER, CENTER);
  textSize(28);
  text("Graphs Page", width/2, height/2);

  
  fill(40);
  textAlign(CENTER, CENTER);
  textSize(24);
  text("Traffic Visualisations", 150, 100);
  
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

void drawSearch() {

  fill(20);
  textAlign(CENTER, CENTER);
  textSize(28);
  text("Search", width/2, height/2);

  backBtn.display();
}

void mousePressed() {
  if (screen == 0) {
    if (flightsBtn.isClicked()) screen = 1;
    if (graphBtn.isClicked()) screen = 2;
    if (SearchBtn.isClicked()) screen = 3;
  }

    else if (screen == 2) {
    if (heatMapBtn.isClicked()) screen = 4;
    if (stateQueryBtn.isClicked()) screen = 5;
    if (backBtn.isClicked()) screen = 0;
  }
   else if (screen == 4) {
    heatMap.mousePressed();

    if (backBtn.isClicked()) {
      screen = 2;
    }
   }
     else if (screen == 5) {
    if (backBtn.isClicked()) screen = 2;
  }
  if (screen == 1 || screen == 3) {

    if (backBtn.isClicked()) screen = 0;
  }

  if (screen == 1) {
    flightForm.mousePressed();
  }
}

void mouseDragged() {
  if (screen == 1) {
    flightForm.mouseDragged();
  }
}

void mouseReleased() {
  if (screen == 1) {
    flightForm.mouseReleased();
  }
}

void keyPressed() {
  if (screen == 1) {
    if (keyCode == LEFT)  flightForm.scrollX -= 20;
    if (keyCode == RIGHT) flightForm.scrollX += 20;
    if (keyCode == UP)    flightForm.scrollY -= 20;
    if (keyCode == DOWN)  flightForm.scrollY += 20;
  }
    else if (screen == 5) {
    stateChart.keyPressed();
  }

}

void mouseWheel(processing.event.MouseEvent event) {
  float e = event.getCount();

  if (screen == 1) {
    if (keyPressed && keyCode == SHIFT) {
      flightForm.scrollX += e * 20; 
    } else {
      flightForm.scrollY += e * 20; 
    }
  }
}
