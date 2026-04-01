StateHeatMap heatMap;
StateQueryChart stateChart;

int screen = 0;
Table table;
ArrayList<Flight> flights;
BarChart barChart;
Button flightsBtn;
Button graphBtn;
Button backBtn;

Button barChartBtn;
Button barChart2Btn;
Button barChart3Btn;

Button heatMapBtn;
Button stateQueryBtn;

Background plane;
FlightForm flightForm;

void setup() {
  size(1000, 650);
  
  flights = new ArrayList<Flight>();
  loadData();
  barChart = new BarChart(flights);
  
  heatMap = new StateHeatMap("usa-wikipedia.svg", "flights2k.csv", -250, -110);

  flightsBtn = new Button(425, 250, 200, 50, "Flight Boards");
  graphBtn = new Button(425, 400, 200, 50, "Graphs");
  backBtn = new Button(20, 20, 100, 40, "Back");
  
  barChartBtn = new Button(50, 70, 150, 50, "Bar Chart");
  barChart2Btn = new Button(240, 70, 150, 50, "Bar Chart");
  barChart3Btn = new Button(430, 70, 150, 50, "Bar Chart");
  heatMapBtn = new Button(620, 70, 150, 50, "Heat Map");
  stateQueryBtn = new Button(800, 70, 180, 50, "State Query Chart");

  plane = new Background();

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
  else if (screen == 5) {
    drawBarChartPage();
  }
  else if (screen == 6) {
    drawBarChartPage2();
  }
  else if (screen == 7) {
    drawBarChartPage3();
  }
}

void drawMenu() {
  textAlign(CENTER, CENTER);
  textSize(32);
  fill(0);
  text("SkyFly Menu", 520, 80);

  flightsBtn.display();
  graphBtn.display();
}

void drawFlights() {
  backBtn.display();
  flightForm.display(); 
}

void drawGraphs() {
  textAlign(CENTER, CENTER);
  textSize(24);
  fill(40);
  text("Traffic Visualisations", 495, 50);
  
  barChartBtn.display();
  barChart2Btn.display();
  barChart3Btn.display();
  heatMapBtn.display();
  stateQueryBtn.display();
  backBtn.display();
}

void drawBarChartPage() {
  barChart.display();
  backBtn.display();
}

void drawBarChartPage2() {
  backBtn.display();
}

void drawBarChartPage3() {
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

void loadData() {
  table = loadTable("flights2k.csv", "header");
  for (TableRow row : table.rows()) {
    flights.add(new Flight(row));
  }
}

void mousePressed() {
  if (screen == 0) {
    if (flightsBtn.isClicked()) screen = 1;
    if (graphBtn.isClicked()) screen = 2;
  }

  else if (screen == 2) {

  if (barChartBtn.isClicked()) screen = 5;
  if (barChart2Btn.isClicked()) screen = 6;
  if (barChart3Btn.isClicked()) screen = 7;

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
  
  else if (screen == 5 || screen == 6 || screen == 7) {
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

///for Searching bar
void mouseWheel(processing.event.MouseEvent event) {
  if (screen == 1) {
    flightForm.mouseWheel(event.getCount());
  }
}
