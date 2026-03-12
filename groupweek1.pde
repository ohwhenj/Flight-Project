import java.util.ArrayList;

Table table;
ArrayList<Flight> flights;

void setup() {
  size(1000, 800);
  background(255);

  flights = new ArrayList<Flight>();
  readData();

  for (Flight f : flights) {
    println(f);
  }

  textSize(16);
}

void draw() {
  background(255);
  fill(0);
  textSize(16);

  float y = 30;

  for (int i = 0; i < flights.size(); i++) {
    flights.get(i).display(20, y);
    y += 25;
  }
}

void readData() {
  table = loadTable("flights2k.csv", "header");

  for (TableRow row : table.rows()) {
    String origin = row.getString("ORIGIN");
    String dest = row.getString("DEST");
    int distance = row.getInt("DISTANCE");

    Flight f = new Flight(origin, dest, distance);
    flights.add(f);
  }
  
    println(flights.size());
}
