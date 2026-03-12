class Flight {
  String origin;
  String dest;
  int distance;

  Flight(String origin, String dest, int distance) {
    this.origin = origin;
    this.dest = dest;
    this.distance = distance;
  }

  void display(float x, float y) {
    text(origin + "   " + dest + "   " + distance, x, y);
  }

  String toString() {
    return origin + "   " + dest + "   " + distance;
  }
}
