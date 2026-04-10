
class LeaderBoard{
Table table;

String mode       = "delay";
int    hoveredRow = -1;
int    SHOW_ROWS  = 10;

int btn1X = 160,  btn1Y = 70, btnW = 140, btnH = 30;
int btn2X = 370, btn2Y = 70;

String[] delayAirports, cancelAirports;
String[] delayCities,   cancelCities;
float[]  delayVals,     cancelVals;

LeaderBoard() {
loadData();
}

void display() {
  background(10, 22, 40);

  String[] airports = mode.equals("delay") ? delayAirports : cancelAirports;
  String[] cities   = mode.equals("delay") ? delayCities   : cancelCities;
  float[]  vals     = mode.equals("delay") ? delayVals      : cancelVals;
  float    maxVal   = vals[0];
  color    barColor = mode.equals("delay") ? color(226, 75, 74) : color(239, 159, 39);
  String   sub      = mode.equals("delay") ? "Avg departure delay in minutes" : "Cancellation rate (%)";
  String   unit     = mode.equals("delay") ? " min" : "%";


  fill(255);
  textSize(22);
  textAlign(LEFT);
  text("Most Unreliable Airports", 170, 40);

  fill(120);
  textSize(13);
  text(sub, 170, 58);


  drawButton(btn1X, btn1Y, btnW, btnH, "Most delayed",   mode.equals("delay"));
  drawButton(btn2X, btn2Y, btnW, btnH, "Most cancelled", mode.equals("cancelled"));


  stroke(60);
  strokeWeight(0.5);
  line(20, 112, width - 20, 112);
  noStroke();

  int BAR_X     = 280;
  int BAR_MAX_W = 480;

  for (int i = 0; i < SHOW_ROWS; i++) {
    int     y         = 124 + i * 44;
    boolean isHovered = (i == hoveredRow);

    // Hover highlight
    if (isHovered) {
      fill(45);
      noStroke();
      rect(8, y - 2, width - 16, 39, 4);
    }

    // Rank
    if (i < 3) fill(239, 159, 39);
    else        fill(100);
    textSize(13);
    textAlign(RIGHT);
    text(i + 1, 32, y + 20);

    // Airport code
    fill(255);
    textSize(15);
    textAlign(LEFT);
    text(airports[i], 42, y + 20);

    // City name
    fill(136);
    textSize(12);
    text(cities[i], 100, y + 20);

    // Bar
    float bw = (vals[i] / maxVal) * BAR_MAX_W;
    fill(red(barColor), green(barColor), blue(barColor), isHovered ? 255 : 180);
    noStroke();
    rect(BAR_X, y + 6, bw, 20, 3);

    // Value label
    fill(isHovered ? 255 : 170);
    textSize(13);
    textAlign(LEFT);
    text(nf(vals[i], 0, 1) + unit, BAR_X + bw + 8, y + 20);
  }
}

void drawButton(int x, int y, int w, int h, String label, boolean active) {
  boolean over = mouseX >= x && mouseX <= x + w &&
                 mouseY >= y && mouseY <= y + h;

  if (active)    fill(200, 200, 200);
  else if (over) fill(55);
  else           fill(40);

  stroke(80);
  strokeWeight(1);
  rect(x, y, w, h, 5);
  noStroke();

  if (active) fill(20);
  else        fill(over ? 220 : 160);

  textSize(12);
  textAlign(CENTER, CENTER);
  text(label, x + w / 2, y + h / 2);
  textAlign(LEFT);
}

void mousePressed() {
  if (mouseX >= btn1X && mouseX <= btn1X + btnW &&
      mouseY >= btn1Y && mouseY <= btn1Y + btnH) {
    mode = "delay";
  }
  else if (mouseX >= btn2X && mouseX <= btn2X + btnW &&
      mouseY >= btn2Y && mouseY <= btn2Y + btnH) {
    mode = "cancelled";
  }
}

void mouseMoved() {
  hoveredRow = -1;
  for (int i = 0; i < SHOW_ROWS; i++) {
    int y = 124 + i * 44;
    if (mouseY >= y - 2 && mouseY <= y + 37) {
      hoveredRow = i;
      break;
    }
  }
}

void mouseExited() {
  hoveredRow = -1;
}


void loadData() {
  table = loadTable("flights2k.csv", "header");

  StringList codes      = new StringList();
  StringList cityNames  = new StringList();
  FloatList  totalDelay = new FloatList();
  IntList    flightCount= new IntList();
  IntList    cancelCount= new IntList();
  IntList    totalCount = new IntList();

  for (TableRow row : table.rows()) {
    String code      = row.getString("ORIGIN");
    String city      = row.getString("ORIGIN_CITY_NAME");
    int    cancelled = row.getInt("CANCELLED");
    float  crsTime   = row.getFloat("CRS_DEP_TIME");
    float  depTime   = row.getFloat("DEP_TIME");

    int idx = codes.index(code);
    if (idx == -1) {
      codes.append(code);
      cityNames.append(city);
      totalDelay.append(0);
      flightCount.append(0);
      cancelCount.append(0);
      totalCount.append(0);
      idx = codes.size() - 1;
    }

    totalCount.set(idx, totalCount.get(idx) + 1);

    if (cancelled == 1) {
      cancelCount.set(idx, cancelCount.get(idx) + 1);
    } else {
      if (!Float.isNaN(depTime) && depTime > 0) {
        float sched  = hhmm(crsTime);
        float actual = hhmm(depTime);
        float delay  = actual - sched;
        if (delay < -200) delay += 1440;
        totalDelay.set(idx, totalDelay.get(idx) + delay);
        flightCount.set(idx, flightCount.get(idx) + 1);
      }
    }
  }

  int n = codes.size();
  float[]  avgDelay   = new float[n];
  float[]  cancelRate = new float[n];
  String[] allCodes   = new String[n];
  String[] allCities  = new String[n];

  for (int i = 0; i < n; i++) {
    allCodes[i]   = codes.get(i);
    allCities[i]  = cityNames.get(i);
    avgDelay[i]   = flightCount.get(i) > 0 ? totalDelay.get(i) / flightCount.get(i) : 0;
    cancelRate[i] = totalCount.get(i)  > 0 ? (float) cancelCount.get(i) / totalCount.get(i) * 100 : 0;
  }

  int[] delayOrder  = sortDescending(avgDelay);
  int[] cancelOrder = sortDescending(cancelRate);

  delayAirports  = new String[SHOW_ROWS];
  delayCities    = new String[SHOW_ROWS];
  delayVals      = new float[SHOW_ROWS];
  cancelAirports = new String[SHOW_ROWS];
  cancelCities   = new String[SHOW_ROWS];
  cancelVals     = new float[SHOW_ROWS];

  for (int i = 0; i < SHOW_ROWS; i++) {
    delayAirports[i]  = allCodes[delayOrder[i]];
    delayCities[i]    = allCities[delayOrder[i]];
    delayVals[i]      = avgDelay[delayOrder[i]];
    cancelAirports[i] = allCodes[cancelOrder[i]];
    cancelCities[i]   = allCities[cancelOrder[i]];
    cancelVals[i]     = cancelRate[cancelOrder[i]];
  }
}

float hhmm(float t) {
  int ti = (int) t;
  return (ti / 100) * 60 + (ti % 100);
}

int[] sortDescending(float[] arr) {
  int n = arr.length;
  int[] idx = new int[n];
  for (int i = 0; i < n; i++) idx[i] = i;
  for (int i = 0; i < n - 1; i++) {
    for (int j = 0; j < n - i - 1; j++) {
      if (arr[idx[j]] < arr[idx[j+1]]) {
        int tmp = idx[j]; idx[j] = idx[j+1]; idx[j+1] = tmp;
      }
    }
  }
  return idx;
}
}
