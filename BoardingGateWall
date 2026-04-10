import java.util.HashMap;
import java.util.ArrayList;

// scroll values for moving through all state panels
float scrollY = 0;
float minScrollY = 0;
float maxScrollY = 0;

class BoardingGateWall {
  // flight data and gate panels
  Table table;
  ArrayList<GatePanel> panels;

  // all state codes found in CSV
ArrayList<String> statesToShow;

  // currently selected state
  String selectedState = "CA";

  // load CSV and build panel data
BoardingGateWall(String filename) {
  table = loadTable(filename, "header");
  panels = new ArrayList<GatePanel>();

  buildStateList();
  buildPanels();

  if (statesToShow.size() > 0) {
    selectedState = statesToShow.get(0);
  }
}

// build one panel per state
void buildPanels() {
  panels.clear();

  int cols = 4;
float panelW = 200;
float panelH = 140;
float gapX = 20;
float gapY = 18;
float startX = 52;
float startY = 82;

  for (int i = 0; i < statesToShow.size(); i++) {
    String state = statesToShow.get(i);

    int dep = countDepartures(state);
    int arr = countArrivals(state);

    int col = i % cols;
    int row = i / cols;

    float x = startX + col * (panelW + gapX);
    float y = startY + row * (panelH + gapY);

    String gateLabel = "G" + (i + 1);

    panels.add(new GatePanel(x, y, panelW, panelH, gateLabel, state, dep, arr));
  }

  // work out scroll limits based on content height
  int rows = (int)ceil(statesToShow.size() / 4.0);
float contentBottom = 100 + rows * (150 + 18);
float visibleBottom = 560;

minScrollY = min(0, visibleBottom - contentBottom);
maxScrollY = 0;
}

  // count departures from a given state
  int countDepartures(String state) {
    int count = 0;

    for (TableRow row : table.rows()) {
      String originState = row.getString("ORIGIN_STATE_ABR");
      if (originState != null && trim(originState).equalsIgnoreCase(state)) {
        count++;
      }
    }

    return count;
  }

  // count arrivals into a given state
  int countArrivals(String state) {
    int count = 0;

    for (TableRow row : table.rows()) {
      String destState = row.getString("DEST_STATE_ABR");
      if (destState != null && trim(destState).equalsIgnoreCase(state)) {
        count++;
      }
    }

    return count;
  }

  // find the most common origin airport for the selected state
  String getTopOriginAirport(String state) {
    HashMap<String, Integer> airportCounts = new HashMap<String, Integer>();

    for (TableRow row : table.rows()) {
      String originState = row.getString("ORIGIN_STATE_ABR");
      if (originState != null && trim(originState).equalsIgnoreCase(state)) {
        String airport = trim(row.getString("ORIGIN"));
        if (airportCounts.containsKey(airport)) {
          airportCounts.put(airport, airportCounts.get(airport) + 1);
        } else {
          airportCounts.put(airport, 1);
        }
      }
    }

    String topAirport = "---";
    int maxCount = 0;

    for (String airport : airportCounts.keySet()) {
      int count = airportCounts.get(airport);
      if (count > maxCount) {
        maxCount = count;
        topAirport = airport;
      }
    }

    return topAirport;
  }

// draw full boarding gate wall page
void display() {
  background(10, 22, 40);

  drawTitle();
  drawPanels();
  drawBottomBar();
}

// draw page title
void drawTitle() {
  fill(245);
  textAlign(CENTER, CENTER);

  textSize(30);
  text("Boarding Gate Wall", width / 2, 30);

  fill(180);
  textSize(14);
  text("Click a gate to inspect state traffic", width / 2, 62);
}

// draw all gate panels with veritcal scrolling
void drawPanels() {
  pushMatrix();
  translate(0, scrollY);

  for (GatePanel panel : panels) {
    boolean selected = panel.stateCode.equals(selectedState);
    panel.display(selected);
  }

  popMatrix();
}

// draw fixed info bar at the bottom
void drawBottomBar() {
  int dep = countDepartures(selectedState);
  int arr = countArrivals(selectedState);
  int net = dep - arr;
  String topAirport = getTopOriginAirport(selectedState);

  noStroke();
  fill(18, 30, 48);
  rect(0, height - 54, width, 54);

  fill(255);
  textAlign(LEFT, CENTER);
  textSize(14);

  text("Selected: " + selectedState, 24, height - 27);
  text("Departures: " + dep, 170, height - 27);
  text("Arrivals: " + arr, 330, height - 27);
  text("Net: " + net, 460, height - 27);
  text("Top Origin Airport: " + topAirport, 570, height - 27);
}

// handle clicking on a panel
void mousePressed() {
  float adjustedMouseY = mouseY - scrollY;   

  for (GatePanel panel : panels) {
    if (mouseX >= panel.x && mouseX <= panel.x + panel.w &&
        adjustedMouseY >= panel.y && adjustedMouseY <= panel.y + panel.h) {

      selectedState = panel.stateCode;
    }
  }
}

// build list of unique states from the CSV
void buildStateList() {
  statesToShow = new ArrayList<String>();

  for (TableRow row : table.rows()) {
    String originState = trim(row.getString("ORIGIN_STATE_ABR"));
    String destState = trim(row.getString("DEST_STATE_ABR"));

    if (originState != null && originState.length() > 0 && !statesToShow.contains(originState)) {
      statesToShow.add(originState);
    }

    if (destState != null && destState.length() > 0 && !statesToShow.contains(destState)) {
      statesToShow.add(destState);
    }
  }

  // sort alphabetically
  statesToShow.sort(null);
}

// scroll panel grid with mouse wheel
void mouseWheel(float amount) {
  scrollY -= amount * 20;

  if (scrollY < minScrollY) scrollY = minScrollY;
  if (scrollY > maxScrollY) scrollY = maxScrollY;
}

}
