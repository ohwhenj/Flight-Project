class BarChart {
  ArrayList<Flight> flights;

  float marginLeft   = 80;
  float marginRight  = 40;
  float marginTop    = 60;
  float marginBottom = 80;

  String[] labels;
  int[]    values;
  color[]  barColors;

  BarChart(ArrayList<Flight> flights) {
    this.flights = flights;
    processData();
  }

  void processData() {
    java.util.HashMap<String, Integer> counts =
      new java.util.HashMap<String, Integer>();

    for (Flight f : flights) {
      String rawDate  = f.flDate;
      String datePart = rawDate;
      if (rawDate.contains(" ")) {
        datePart = rawDate.split(" ")[0];
      }
      if (counts.containsKey(datePart)) {
        counts.put(datePart, counts.get(datePart) + 1);
      } else {
        counts.put(datePart, 1);
      }
    }

    int n  = counts.size();
    labels = new String[n];
    values = new int[n];

    int i = 0;
    for (java.util.Map.Entry<String, Integer> entry : counts.entrySet()) {
      labels[i] = entry.getKey();
      values[i] = entry.getValue();
      i++;
    }

    // Sort alphabetically
    for (int a = 0; a < n - 1; a++) {
      for (int b = 0; b < n - a - 1; b++) {
        if (labels[b].compareTo(labels[b + 1]) > 0) {
          String tempLbl = labels[b];
          labels[b]      = labels[b + 1];
          labels[b + 1]  = tempLbl;
          int tempVal    = values[b];
          values[b]      = values[b + 1];
          values[b + 1]  = tempVal;
        }
      }
    }

    color[] palette = {
      color(70, 130, 180),
      color(255, 127, 80),
      color(60, 179, 113),
      color(255, 215, 0),
      color(186, 85, 211),
      color(255, 99, 71)
    };
    barColors = new color[n];
    for (int j = 0; j < n; j++) {
      barColors[j] = palette[j % palette.length];
    }
  }

  void display() {
    int   n      = labels.length;
    float chartW = width  - marginLeft - marginRight;
    float chartH = height - marginTop  - marginBottom;

    int maxVal = 0;
    for (int v : values) if (v > maxVal) maxVal = v;

    // Title
    fill(30);
    textSize(20);
    textAlign(CENTER, TOP);
    text("Number of Flights per Day", width / 2, 15);

    // Y axis label
    pushMatrix();
    translate(15, height / 2);
    rotate(-HALF_PI);
    textSize(13);
    textAlign(CENTER, CENTER);
    text("Number of Flights", 0, 0);
    popMatrix();

    // Gridlines
    for (int g = 0; g <= 5; g++) {
      float yVal = (float) g / 5 * maxVal;
      float yPos = marginTop + chartH - (yVal / maxVal * chartH);
      stroke(200);
      strokeWeight(1);
      line(marginLeft, yPos, marginLeft + chartW, yPos);
      fill(80);
      textSize(11);
      textAlign(RIGHT, CENTER);
      text(int(yVal), marginLeft - 8, yPos);
    }

    // Bars
    float barW = (chartW / n) * 0.7;
    float gap  = (chartW / n) * 0.3;

    for (int i = 0; i < n; i++) {
      float barH = (float) values[i] / maxVal * chartH;
      float xPos = marginLeft + i * (chartW / n) + gap / 2;
      float yPos = marginTop + chartH - barH;

      fill(barColors[i]);
      noStroke();
      rect(xPos, yPos, barW, barH, 4, 4, 0, 0);

      fill(30);
      textSize(11);
      textAlign(CENTER, BOTTOM);
      text(values[i], xPos + barW / 2, yPos - 3);

      pushMatrix();
      translate(xPos + barW / 2, marginTop + chartH + 10);
      rotate(QUARTER_PI);
      textSize(11);
      textAlign(LEFT, CENTER);
      fill(30);
      text(labels[i], 0, 0);
      popMatrix();
    }

    // Axes
    stroke(50);
    strokeWeight(2);
    line(marginLeft, marginTop, marginLeft, marginTop + chartH);
    line(marginLeft, marginTop + chartH, marginLeft + chartW, marginTop + chartH);
  }
}
