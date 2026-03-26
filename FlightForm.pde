class FlightForm {
  Table table;

  float x, y, w, h;
  float rowHeight = 32;
  float colWidth = 140;
  float headerHeight = 36;
  float scrollSize = 16;

  float scrollX = 0;
  float scrollY = 0;

  boolean draggingH = false;
  boolean draggingV = false;

  float hKnobX, hKnobW;
  float vKnobY, vKnobH;

  FlightForm(String filename, float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;

    table = loadTable(filename, "header");
  }

  void display() {
    updateKnobs();

    fill(255);
    stroke(180);
    rect(x, y, w, h, 8);

    float viewW = w - scrollSize;
    float viewH = h - scrollSize;

    pushMatrix();
    clip((int)x, (int)y, (int)viewW, (int)viewH);

    fill(250);
    noStroke();
    rect(x, y, viewW, viewH);

    drawHeader();
    drawRows();

    noClip();
    popMatrix();

    drawScrollBars();
  }

  void drawHeader() {
    String[] headers = table.getColumnTitles();

    fill(60, 120, 200);
    stroke(220);
    rect(x, y, totalTableWidth(), headerHeight);

    for (int c = 0; c < headers.length; c++) {
      float cellX = x + c * colWidth - scrollX;

      fill(60, 120, 200);
      stroke(220);
      rect(cellX, y, colWidth, headerHeight);

      fill(255);
      textAlign(CENTER, CENTER);
      textSize(14);
      text(headers[c], cellX + colWidth/2, y + headerHeight/2);
    }
  }

  void drawRows() {
    String[] headers = table.getColumnTitles();

    for (int r = 0; r < table.getRowCount(); r++) {
      TableRow row = table.getRow(r);
      float rowY = y + headerHeight + r * rowHeight - scrollY;

      if (rowY + rowHeight < y || rowY > y + h - scrollSize) continue;

      for (int c = 0; c < headers.length; c++) {
        float cellX = x + c * colWidth - scrollX;

        if (r % 2 == 0) fill(245);
        else fill(230);

        stroke(200);
        rect(cellX, rowY, colWidth, rowHeight);

        fill(30);
        textAlign(CENTER, CENTER);
        textSize(13);
        text(row.getString(headers[c]), cellX + colWidth/2, rowY + rowHeight/2);
      }
    }
  }

  void drawScrollBars() {
    float viewW = w - scrollSize;
    float viewH = h - scrollSize;

    fill(220);
    noStroke();
    rect(x, y + viewH, viewW, scrollSize);

    fill(120);
    rect(hKnobX, y + viewH, hKnobW, scrollSize, 6);

    fill(220);
    rect(x + viewW, y, scrollSize, viewH);

    fill(120);
    rect(x + viewW, vKnobY, scrollSize, vKnobH, 6);

    fill(200);
    rect(x + viewW, y + viewH, scrollSize, scrollSize);
  }

  void updateKnobs() {
    float viewW = w - scrollSize;
    float viewH = h - scrollSize;

    float contentW = totalTableWidth();
    float contentH = totalTableHeight();

    float maxScrollX = max(0, contentW - viewW);
    float maxScrollY = max(0, contentH - viewH);

    scrollX = constrain(scrollX, 0, maxScrollX);
    scrollY = constrain(scrollY, 0, maxScrollY);

    if (contentW <= viewW) {
      hKnobX = x;
      hKnobW = viewW;
    } else {
      hKnobW = max(40, viewW * (viewW / contentW));
      hKnobX = x + (scrollX / maxScrollX) * (viewW - hKnobW);
    }

    if (contentH <= viewH) {
      vKnobY = y;
      vKnobH = viewH;
    } else {
      vKnobH = max(40, viewH * (viewH / contentH));
      vKnobY = y + (scrollY / maxScrollY) * (viewH - vKnobH);
    }
  }

  float totalTableWidth() {
    return table.getColumnCount() * colWidth;
  }

  float totalTableHeight() {
    return headerHeight + table.getRowCount() * rowHeight;
  }

  void mousePressed() {
    float viewW = w - scrollSize;
    float viewH = h - scrollSize;

    if (mouseX >= hKnobX && mouseX <= hKnobX + hKnobW &&
        mouseY >= y + viewH && mouseY <= y + viewH + scrollSize) {
      draggingH = true;
    }

    if (mouseX >= x + viewW && mouseX <= x + viewW + scrollSize &&
        mouseY >= vKnobY && mouseY <= vKnobY + vKnobH) {
      draggingV = true;
    }
  }

  void mouseDragged() {
    float viewW = w - scrollSize;
    float viewH = h - scrollSize;

    float contentW = totalTableWidth();
    float contentH = totalTableHeight();

    float maxScrollX = max(0, contentW - viewW);
    float maxScrollY = max(0, contentH - viewH);

    if (draggingH && contentW > viewW) {
      float barRange = viewW - hKnobW;
      float newKnobX = constrain(mouseX - hKnobW/2, x, x + barRange);
      scrollX = map(newKnobX, x, x + barRange, 0, maxScrollX);
    }

    if (draggingV && contentH > viewH) {
      float barRange = viewH - vKnobH;
      float newKnobY = constrain(mouseY - vKnobH/2, y, y + barRange);
      scrollY = map(newKnobY, y, y + barRange, 0, maxScrollY);
    }
  }

  void mouseReleased() {
    draggingH = false;
    draggingV = false;
  }
}
