// Conor is responsible for Flight form code 
///The FlightForm have Search bar
class FlightForm {
  //stores and reads flight data
  ArrayList<String[]> flights = new ArrayList<String[]>();

// current form settings
  boolean showDep = true;
  String query = "";
  boolean searchActive = false;
  int scrollRow = 0;
  final int ROWS = 12;

  // search bar and table layout
  final int BTN_Y = 30, BTN_H = 40, BTN_W = 180;
  int depBtnX, arrBtnX;

  final int SY = 90, SH = 35;
  final int TX = 40, TY = 150, TW = width - 80;
  final int RH = 35;

  int[] COL;

// colours used 
  final int BG = color(0);
  final int WHITE = color(255);
  final int GREY = color(150);
  final int GREEN = color(0, 210, 85);
  final int ORANGE = color(255, 138, 0);
  final int RED = color(255, 55, 55);

 // load flight form data
  FlightForm(String filename) {

    depBtnX = width/2 - BTN_W - 10;
    arrBtnX = width/2 + 10;

    COL = new int[]{TX+20, TX+120, TX+220, TX+320, TX+520, TX+650, TX+770};
    loadCSV(filename);
  }

  //split csv file to different fields
  String[] parseCSVLine(String line) {
    ArrayList<String> fields = new ArrayList<String>();
    boolean inQuotes = false;
    String current = "";

    for (int i = 0; i < line.length(); i++) {
      char ch = line.charAt(i);

      if (ch == '"') {
        inQuotes = !inQuotes;
      } 
      else if (ch == ',' && !inQuotes) {
        fields.add(current.trim());
        current = "";
      } 
      else {
        current += ch;
      }
    }

    fields.add(current.trim());
    return fields.toArray(new String[0]);
  }

  // load csv file and build flight records
  void loadCSV(String filename) {
    String[] lines = loadStrings(filename);
    if (lines == null) return;

    for (int i = 1; i < lines.length; i++) {

      String[] c = parseCSVLine(lines[i]); // ✅ FIXED

      if (c.length < 16) continue;

      int cancelled = 0;
      try {
        cancelled = Integer.parseInt(trim(c[15]));
      } catch (Exception e) {}

      flights.add(new String[]{
        trim(c[1]) + trim(c[2]),
        trim(c[3]), city(trim(c[4])),
        trim(c[7]), city(trim(c[8])),
        fmt(trim(c[11])), fmt(trim(c[12])),
        fmt(trim(c[13])), fmt(trim(c[14])),
        st(trim(c[12]), trim(c[11]), cancelled),
        st(trim(c[14]), trim(c[13]), cancelled)
      });
    }
  }

  String city(String s) {
    int i = s.indexOf(',');
    return i > 0 ? s.substring(0, i) : s;
  }

  String fmt(String raw) {
    if (raw == null || raw.equals("")) return "--:--";

    try {
      int t = Integer.parseInt(raw);
      return nf(t/100,2) + ":" + nf(t%100,2);
    } catch (Exception e) {
      return "--:--";
    }
  }

  // work out flight status from scheduled and actual time
  String st(String actual, String sched, int cancelled) {

    if (cancelled == 1) return "CANCELLED";
    if (actual == null || actual.equals("")) return "---";
    if (sched == null || sched.equals("")) return "---";

    try {
      int a = Integer.parseInt(actual);
      int s = Integer.parseInt(sched);

      int diff = a - s;

      if (diff < -500) diff += 2400;
      if (diff > 500) diff -= 2400;

      return diff > 15 ? "DELAYED" : "ON TIME";

    } catch (Exception e) {
      return "---";
    }
  }

// filter flights using search bar input
ArrayList<String[]> filtered() {
  ArrayList<String[]> out = new ArrayList<String[]>();

  String q = query.toLowerCase().trim();

  for (String[] f : flights) {

    if (q.equals("")) {
      out.add(f);
      continue;
    }

    if (showDep) {
      if (f[1].toLowerCase().contains(q) ||
          f[2].toLowerCase().contains(q)) {
        out.add(f);
      }
    } else {
      if (f[3].toLowerCase().contains(q) ||
          f[4].toLowerCase().contains(q)) {
        out.add(f);
      }
    }
  }

  return out;
}

// draw full flight form page
  void display() {

  ArrayList<String[]> data = filtered();

  drawToggle();
  drawSearch();
  drawTable(data);
}

  //the different two buttons
  void drawToggle() {
    textAlign(CENTER, CENTER);

    fill(showDep ? WHITE : BG);
    rect(depBtnX, BTN_Y, BTN_W, BTN_H);
    fill(showDep ? BG : WHITE);
    text("DEPARTURES", depBtnX + BTN_W/2, BTN_Y + BTN_H/2);

    fill(!showDep ? WHITE : BG);
    rect(arrBtnX, BTN_Y, BTN_W, BTN_H);
    fill(!showDep ? BG : WHITE);
    text("ARRIVALS", arrBtnX + BTN_W/2, BTN_Y + BTN_H/2);
  }

  void drawSearch() {
  stroke(WHITE);     
  fill(BG);         
  rect(TX, SY, TW, SH);

  fill(WHITE);  
  textAlign(LEFT, CENTER);
  text("SEARCH: " + query, TX + 10, SY + SH/2);
}
 // create the table
  void drawTable(ArrayList<String[]> data) {

    String[] headers = { "FLIGHT", "FROM", "TO", "CITY", "SCHED", "ACTUAL", "STATUS" };

    fill(WHITE);
    for (int i = 0; i < headers.length; i++) {
      text(headers[i], COL[i], TY - 10);
    }

    int start = scrollRow;
    int end = min(start + ROWS, data.size());

    for (int i = start; i < end; i++) {
      String[] f = data.get(i);
      int y = TY + (i - start) * RH;

      fill(i % 2 == 0 ? 20 : 0);
      rect(TX, y, TW, RH);

      fill(WHITE);
      text(f[0], COL[0], y + 20);
      text(f[1], COL[1], y + 20);
      text(f[3], COL[2], y + 20);
      text(f[4], COL[3], y + 20);
      text(f[5], COL[4], y + 20);
      text(f[6], COL[5], y + 20);

      if (f[9].equals("ON TIME")) fill(GREEN);
      else if (f[9].equals("DELAYED")) fill(ORANGE);
      else fill(RED);

      text(f[9], COL[6], y + 20);
    }
  }

  void mousePressed() {

    if (mouseY >= BTN_Y && mouseY <= BTN_Y + BTN_H) {
      if (mouseX >= depBtnX && mouseX <= depBtnX + BTN_W) showDep = true;
      if (mouseX >= arrBtnX && mouseX <= arrBtnX + BTN_W) showDep = false;
    }

    searchActive = mouseY >= SY && mouseY <= SY + SH;
  }

  void mouseWheel(float e) {
    ArrayList<String[]> data = filtered();

    scrollRow += (e > 0 ? 1 : -1);
    scrollRow = constrain(scrollRow, 0, max(0, data.size() - ROWS));
  }

// type into search bar when active
  void keyPressed() {
    if (!searchActive) return;

    if (key == BACKSPACE && query.length() > 0)
      query = query.substring(0, query.length()-1);
    else if (key >= 32 && key <= 126)
      query += key;
  }

  void mouseDragged() {}
  void mouseReleased() {}
}
