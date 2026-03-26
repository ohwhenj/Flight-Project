import java.util.HashMap;

class StateHeatMap {
  PShape usa;
  Table table;

  HashMap<String, Integer> stateValues;

  Button trafficBtn;
  Button departuresBtn;
  Button arrivalsBtn;
  Button differenceBtn;
  Button stateQueryBtn;

  int mode = 0;   // 0 = traffic, 1 = departures, 2 = arrivals, 3 = difference

  float mapX;
  float mapY;

  StateHeatMap(String svgFile, String csvFile, float mapX, float mapY) {
    this.mapX = mapX;
    this.mapY = mapY;

    usa = loadShape(svgFile);
    table = loadTable(csvFile, "header");

    stateValues = new HashMap<String, Integer>();

    trafficBtn    = new Button(200, 20, 140, 40, "Traffic");
    departuresBtn = new Button(400, 20, 140, 40, "Departures");
    arrivalsBtn   = new Button(600, 20, 140, 40, "Arrivals");
    differenceBtn = new Button(800, 20, 140, 40, "Difference");
    stateQueryBtn = new Button(390, 280, 220, 60, "State Query Chart");

    buildStateMap();
  }

  void display() {
    background(255);

    drawButtons();
    drawTitle();

    usa.disableStyle();
    fill(210);
    stroke(255);
    strokeWeight(1);
    shape(usa, mapX, mapY);

    drawHeatMap();
  }

  void mousePressed() {
    if (trafficBtn.isClicked()) {
      println("traffic");
      mode = 0;
      buildStateMap();
    }

    if (departuresBtn.isClicked()) {
      mode = 1;
      buildStateMap();
    }

    if (arrivalsBtn.isClicked()) {
      mode = 2;
      buildStateMap();
    }

    if (differenceBtn.isClicked()) {
      mode = 3;
      buildStateMap();
    }
  }

  void drawButtons() {
    trafficBtn.display();
    departuresBtn.display();
    arrivalsBtn.display();
    differenceBtn.display();

    noFill();
    stroke(0);
    strokeWeight(2);

    if (mode == 0) {
      rect(200, 20, 140, 40, 10);
    } 
    else if (mode == 1) {
      rect(400, 20, 140, 40, 10);
    } 
    else if (mode == 2) {
      rect(600, 20, 140, 40, 10);
    } 
    else if (mode == 3) {
      rect(800, 20, 140, 40, 10);
    }
  }

  void drawTitle() {
    fill(0);
    textAlign(LEFT, CENTER);
    textSize(20);

    if (mode == 0) {
      //text("State Heat Map: Total Traffic", 20, 80);
    } 
    else if (mode == 1) {
      //text("State Heat Map: Departures", 20, 80);
    } 
    else if (mode == 2) {
      //text("State Heat Map: Arrivals", 20, 80);
    } 
    else if (mode == 3) {
      //text("State Heat Map: Departures - Arrivals", 20, 80);
    }
  }

  void buildStateMap() {
    stateValues.clear();

    for (TableRow row : table.rows()) {
      String originState = row.getString("ORIGIN_STATE_ABR");
      String destState   = row.getString("DEST_STATE_ABR");

      if (mode == 0) {
        addValue(originState, 1);
        addValue(destState, 1);
      } 
      else if (mode == 1) {
        addValue(originState, 1);
      } 
      else if (mode == 2) {
        addValue(destState, 1);
      } 
      else if (mode == 3) {
        addValue(originState, 1);
        addValue(destState, -1);
      }
    }
  }

  void addValue(String stateCode, int amount) {
    if (stateCode == null || stateCode.equals("")) {
      return;
    }

    if (stateValues.containsKey(stateCode)) {
      stateValues.put(stateCode, stateValues.get(stateCode) + amount);
    } 
    else {
      stateValues.put(stateCode, amount);
    }
  }

  void drawHeatMap() {
    if (mode == 3) {
      drawDifferenceMap();
    } 
    else {
      drawNormalMap();
    }
  }

  void drawNormalMap() {
    int maxValue = getMaxValue();

    for (String code : stateValues.keySet()) {
      PShape state = usa.getChild(code);

      if (state != null) {
        int value = stateValues.get(code);

        float amt = map(value, 0, maxValue, 220, 0);

        state.disableStyle();
        fill(255, amt, amt);
        stroke(255);
        strokeWeight(1);
        shape(state, mapX, mapY);
      }
    }
  }

  void drawDifferenceMap() {
    int maxAbs = getMaxAbsValue();

    for (String code : stateValues.keySet()) {
      PShape state = usa.getChild(code);

      if (state != null) {
        int value = stateValues.get(code);

        state.disableStyle();
        stroke(255);
        strokeWeight(1);

        if (value > 0) {
          float amt = map(value, 0, maxAbs, 180, 0);
          fill(255, amt, amt);
        } 
        else if (value < 0) {
          float amt = map(abs(value), 0, maxAbs, 180, 0);
          fill(amt, amt, 255);
        } 
        else {
          fill(235);
        }

        shape(state, mapX, mapY);
      }
    }
  }

  int getMaxValue() {
    int maxValue = 0;

    for (String code : stateValues.keySet()) {
      int value = stateValues.get(code);
      if (value > maxValue) {
        maxValue = value;
      }
    }

    return maxValue;
  }

  int getMaxAbsValue() {
    int maxAbs = 0;

    for (String code : stateValues.keySet()) {
      int value = abs(stateValues.get(code));
      if (value > maxAbs) {
        maxAbs = value;
      }
    }

    return maxAbs;
  }
}
