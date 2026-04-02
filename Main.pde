StateHeatMap heatMap;
StateQueryChart stateChart;

int screen = 0;
Table table;
ArrayList<Flight> flights;
PImage airplane;
BarChart barChart;
LeaderBoard leaderBoard;
Button flightsBtn;
Button graphBtn;
Button backBtn;

Button barChartBtn;
Button barChart2Btn;

Button heatMapBtn;
Button stateQueryBtn;

BoardingGateWall boardingGateWall;
Button boardingGateBtn;


Background plane;
FlightForm flightForm;

//setup for the game
void setup() {
  size(1000, 650);
  airplane = loadImage("airplane.png");
  flights = new ArrayList<Flight>();
  loadData();
  barChart = new BarChart(flights);
  leaderBoard = new LeaderBoard();
  
  heatMap = new StateHeatMap("usa-wikipedia.svg", "flights2k.csv", -250, -110);


  flightsBtn = new Button(425, 250, 180, 45, "Flight Boards");
  graphBtn = new Button(425, 400, 180, 45, "Graphs");
  backBtn = new Button(20, 20, 100, 40, "Back");
  
  barChartBtn = new Button(40, 90, 150, 50, "Bar Chart");
  barChart2Btn = new Button(220, 90, 150, 50, "Leader board");
  heatMapBtn = new Button(610, 90, 150, 50, "Heat Map");
  stateQueryBtn = new Button(790, 90, 180, 50, "State Query Chart");
  boardingGateBtn = new Button(400, 90, 180, 50, "Boarding Gate Wall");

  plane = new Background();

  flightForm = new FlightForm("flights2k.csv");
  boardingGateWall = new BoardingGateWall("flights2k.csv");
  stateChart = new StateQueryChart("flights2k.csv");
}

//draw different things
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
  drawBoardingGatePage();
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

void drawBoardingGatePage() {
  boardingGateWall.display();
  backBtn.display();
}

void drawGraphs() {
  textAlign(CENTER, CENTER);
  textSize(24);
  fill(40);
  text("Traffic Visualisations", 495, 45);
  image(airplane, 180, 200);
  
  barChartBtn.display();
  barChart2Btn.display();
  heatMapBtn.display();
  stateQueryBtn.display();
  backBtn.display();
  boardingGateBtn.display();
}

void drawBarChartPage() {
  barChart.display();
  backBtn.display();
}

void drawBarChartPage2() {
  leaderBoard.display();
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

//load data from csv file
void loadData() {
  table = loadTable("flights2k.csv", "header");
  for (TableRow row : table.rows()) {
    flights.add(new Flight(row));
  }
}

//make sure can click the buttons
void mousePressed() {
  if (screen == 0) {
    if (flightsBtn.isClicked()) screen = 1;
    if (graphBtn.isClicked()) screen = 2;
  }

  else if (screen == 2) {

  if (barChartBtn.isClicked()) screen = 5;
  if (barChart2Btn.isClicked()) screen = 6;
  if (heatMapBtn.isClicked()) screen = 3;
  if (stateQueryBtn.isClicked()) screen = 4;
  if (boardingGateBtn.isClicked()) screen = 7;

  if (backBtn.isClicked()) screen = 0;
}

  else if (screen == 3) {
    heatMap.mousePressed();
    if (backBtn.isClicked()) screen = 2;
  }

  else if (screen == 4 || screen == 5 || screen == 6 || screen == 7) {
    if (backBtn.isClicked()) screen = 2;
  }

  if (screen == 1) {
    if (backBtn.isClicked()) screen = 0;
    flightForm.mousePressed();
  }
  else if (screen == 7) {
  drawBoardingGatePage();
}
}

//make form can scroll down
void mouseDragged() {
  if (screen == 1) flightForm.mouseDragged();
}

// make form won't autometic scroll up
void mouseReleased() {
  if (screen == 1) flightForm.mouseReleased();
}

//for texting
void keyPressed() {
  if (screen == 1) flightForm.keyPressed();
  else if (screen == 4) stateChart.keyPressed();
}

//for Searching bar
void mouseWheel(processing.event.MouseEvent event) {
  float e = event.getCount();
  if (screen == 1) {
    flightForm.mouseWheel(event.getCount());
  }
  else if (screen == 7) {
  boardingGateWall.mouseWheel(e);
}
}
