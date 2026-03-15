class RangeSlider extends Widget {
    float handleW;
    float handleH;

    color trackColor;
    color selectedTrackColor;
    color handleColor;
    color textColor;

    PFont sliderFont;

    float startValue;
    float endValue;

    boolean draggingStart;
    boolean draggingEnd;

    RangeSlider(
        float x, float y, float w, float h,
        String idLabel,
        float gapX, float gapY,
        float handleW, float handleH,
        color trackColor,
        color selectedTrackColor,
        color handleColor,
        color textColor,
        PFont sliderFont
    ) {
        super(x, y, w, h, idLabel);
        this.handleW = handleW;
        this.handleH = handleH;
        this.trackColor = trackColor;
        this.selectedTrackColor = selectedTrackColor;
        this.handleColor = handleColor;
        this.textColor = textColor;
        this.sliderFont = sliderFont;

        startValue = 0.0;
        endValue = 1.0;
        draggingStart = false;
        draggingEnd = false;
    }

    void draw() {
        float trackY = y + h/2 - 4;
        float trackH = 8;

        float startX = getStartHandleX();
        float endX = getEndHandleX();

        fill(textColor);
        textFont(sliderFont);
        textAlign(LEFT, CENTER);
        text("Visible: " + int(startValue * 100) + "% - " + int(endValue * 100) + "%", x, y - 12);

        fill(trackColor);
        rect(x, trackY, w, trackH, 5);

        fill(selectedTrackColor);
        rect(startX + handleW/2, trackY, (endX - startX), trackH, 5);

        fill(handleColor);
        rect(startX, y + h/2 - handleH/2, handleW, handleH, 6);
        rect(endX, y + h/2 - handleH/2, handleW, handleH, 6);
    }

    float getStartHandleX() {
        return x + startValue * (w - handleW);
    }

    float getEndHandleX() {
        return x + endValue * (w - handleW);
    }

    boolean overStartHandle() {
        float hx = getStartHandleX();
        float hy = y + h/2 - handleH/2;
        return mouseX >= hx && mouseX <= hx + handleW &&
               mouseY >= hy && mouseY <= hy + handleH;
    }

    boolean overEndHandle() {
        float hx = getEndHandleX();
        float hy = y + h/2 - handleH/2;
        return mouseX >= hx && mouseX <= hx + handleW &&
               mouseY >= hy && mouseY <= hy + handleH;
    }

    void press() {
        if (overStartHandle()) {
            draggingStart = true;
        } else if (overEndHandle()) {
            draggingEnd = true;
        }
    }

    void release() {
        draggingStart = false;
        draggingEnd = false;
    }

    boolean isDragging() {
        return draggingStart || draggingEnd;
    }

    void drag() {
        float raw = (mouseX - x) / (w - handleW);
        raw = constrain(raw, 0, 1);

        if (draggingStart) {
            startValue = min(raw, endValue - 0.01);
            startValue = constrain(startValue, 0, 1);
        }

        if (draggingEnd) {
            endValue = max(raw, startValue + 0.01);
            endValue = constrain(endValue, 0, 1);
        }
    }

    int getStartIndex(int totalSize) {
        if (totalSize <= 0) return 0;
        return constrain(floor(startValue * totalSize), 0, max(totalSize - 1, 0));
    }

    int getEndIndexExclusive(int totalSize) {
        if (totalSize <= 0) return 0;
        int endIndex = ceil(endValue * totalSize);
        endIndex = constrain(endIndex, 1, totalSize);
        return max(endIndex, getStartIndex(totalSize) + 1);
    }
}
