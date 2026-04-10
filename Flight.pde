class Flight {
  String flDate;
  String carrier;
  String origin;
  String dest;
  String depTime;
  String arrTime;
  int    cancelled;
  int    diverted;
  int    distance;

  Flight(TableRow row) {
    flDate    = row.getString("FL_DATE");
    carrier   = row.getString("MKT_CARRIER");
    origin    = row.getString("ORIGIN");
    dest      = row.getString("DEST");
    depTime   = row.getString("DEP_TIME");
    arrTime   = row.getString("ARR_TIME");
    cancelled = row.getInt("CANCELLED");
    diverted  = row.getInt("DIVERTED");
    distance  = row.getInt("DISTANCE");
  }

  boolean isCancelled() { return cancelled == 1; }
  boolean isDiverted()  { return diverted  == 1; }
  String  getOrigin()   { return origin; }
  String  getDest()     { return dest; }
  int     getDistance() { return distance; }
}
