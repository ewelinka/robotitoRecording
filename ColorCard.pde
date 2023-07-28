class ColorCard extends Card {
  color cardColor;

  ColorCard(int x, int y, int cSize, color cColor) {
    super(x, y, cSize);
    cardColor = cColor;
  }
  ColorCard(int x, int y, int cSize, color cColor, int fixedId) {
    super(x, y, cSize, fixedId);
    cardColor = cColor;
  }

  void addToBackground() {
    back.beginDraw();
    back.fill(cardColor);
    if (isSelected) {
      back.stroke(markerColor);
      back.strokeWeight(strokeThickness);
    } else {
      back.noStroke();
    }
    back.rect(xpos, ypos, cardSize, cardSize);
    back.endDraw();
  }
}
