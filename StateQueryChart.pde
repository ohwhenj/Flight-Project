class StateQueryChart {
  // stores CSV flight data
  Table table;

  // what user is currently typing
  String stateInput = "";
  // state code after enter is pressed
  String activeState = "";

  // calculated results for selected state
  int departures = 0;
  int arrivals = 0;
  int difference = 0;

  // whether results should be shown
  boolean hasSearched = false;
  // whether input is valid
  boolean invalidInput = false;

  // input box position & size
  float inputX = 350;
  float inputY = 120;
  float inputW = 300;
  float inputH = 50;

  // load CSV file
  StateQueryChart(String filename) {
    table = loadTable(filename, "header");
  }

  // draw full query page
  void display() {
    background(10, 22, 40);
    fill(255);
    rect(100, 50, 810, 560);
    drawTitle();
    drawInputBox();
    drawInstructions();

    if (invalidInput) {
      drawInvalidMessage();
    }

    if (hasSearched) {
      drawResults();
      drawBarChart();
    }
  }

  // draw page title
  void drawTitle() {
    fill(20);
    textAlign(CENTER, CENTER);
    textSize(28);
    text("State Flight Query", width/2, 80);
  }

  // draw state input box
  void drawInputBox() {
    fill(255);
    stroke(120);
    strokeWeight(2);
    rect(inputX, inputY, inputW, inputH, 8);

    fill(0);
    textAlign(LEFT, CENTER);
    textSize(24);
    text(stateInput, inputX + 20, inputY + inputH/2);

    fill(80);
    textSize(16);
    text("Enter state abbreviation:", inputX, inputY - 15);
  }

  // draw user instructions
  void drawInstructions() {
    fill(70);
    textAlign(CENTER, CENTER);
    textSize(16);
    text("Type a 2-letter state code (example: CA, TX, NY) and press ENTER", width/2, 195);
  }

// draw invalid input message
  void drawInvalidMessage() {
    fill(200, 50, 50);
    textAlign(CENTER, CENTER);
    textSize(16);
    text("Please enter a valid 2-letter state code.", width/2, 225);
  }

  // draw results numbers
  void drawResults() {
    fill(20);
    textAlign(LEFT, CENTER);
    textSize(20);
    text("State: " + activeState, 120, 220);
    text("Departures: " + departures, 120, 255);
    text("Arrivals: " + arrivals, 120, 290);
    text("Difference: " + difference, 120, 325);
  }

  // draw comparison bar chart
  void drawBarChart() {
    int chartX = 120;
    int chartY = 390;
    int maxBarWidth = 650;
    int barHeight = 45;
    int gap = 35;

  // scale bars using largest value
    int maxValue = max(max(departures, arrivals), abs(difference));
    if (maxValue == 0) {
      maxValue = 1;
    }

    fill(30);
    textAlign(LEFT, CENTER);
    textSize(18);

    text("Departures", chartX, chartY - 15);
    text("Arrivals", chartX, chartY + barHeight + gap - 15);
    text("Difference", chartX, chartY + 2 * (barHeight + gap) - 15);

    // departures bar
    float depWidth = map(departures, 0, maxValue, 0, maxBarWidth);
    fill(70, 130, 220);
    noStroke();
    rect(chartX, chartY, depWidth, barHeight, 8);

    fill(255);
    textAlign(CENTER, CENTER);
    text(departures, chartX + depWidth/2, chartY + barHeight/2);


    // arrivals bar
    float arrWidth = map(arrivals, 0, maxValue, 0, maxBarWidth);
    fill(100, 180, 120);
    rect(chartX, chartY + barHeight + gap, arrWidth, barHeight, 8);

    fill(255);
    text(arrivals, chartX + arrWidth/2, chartY + barHeight + gap + barHeight/2);

    // difference bar
    float diffWidth = map(abs(difference), 0, maxValue, 0, maxBarWidth);

    if (difference > 0) {
      fill(220, 80, 80);
    } 
    else if (difference < 0) {
      fill(80, 120, 220);
    } 
    else {
      fill(150);
    }

    rect(chartX, chartY + 2 * (barHeight + gap), diffWidth, barHeight, 8);

    fill(255);
    text(difference, chartX + diffWidth/2, chartY + 2 * (barHeight + gap) + barHeight/2);
  }

  // handle keyboard input
  void keyPressed() {
    if (key == ENTER || key == RETURN) {
      runQuery();
    }
    else if (key == BACKSPACE) {
      if (stateInput.length() > 0) {
        stateInput = stateInput.substring(0, stateInput.length() - 1);
      }
    }
    else if (key != CODED) {
      if (stateInput.length() < 2 && Character.isLetter(key)) {
        stateInput += Character.toUpperCase(key);
      }
    }
  }

  // calculate results for selected state
  void runQuery() {
    String queryState = trim(stateInput).toUpperCase();

    if (queryState.length() != 2) {
      hasSearched = false;
      invalidInput = true;
      return;
    }

    invalidInput = false;
    activeState = queryState;
    departures = 0;
    arrivals = 0;

    // count departures and arrivals
    for (TableRow row : table.rows()) {
      String originState = row.getString("ORIGIN_STATE_ABR");
      String destState = row.getString("DEST_STATE_ABR");

      if (originState != null && originState.equalsIgnoreCase(activeState)) {
        departures++;
      }

      if (destState != null && destState.equalsIgnoreCase(activeState)) {
        arrivals++;
      }
    }

    // compute net difference
    difference = departures - arrivals;
    hasSearched = true;
  }
}
