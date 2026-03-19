Table table;
ArrayList<Flight> flights;
BarChart barChart;

void setup() {
  size(900, 600);
  flights = new ArrayList<Flight>();
  loadData();
  barChart = new BarChart(flights);
}

void draw() {
  background(255);
  barChart.display();
}

void loadData() {
  table = loadTable("flights2k.csv", "header");
  for (TableRow row : table.rows()) {
    flights.add(new Flight(row));
  }
}
