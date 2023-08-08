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
  
    fill(cardColor);
    if (isSelected) {
      stroke(markerColor);
      strokeWeight(strokeThickness);
    } else {
      noStroke();
    }
    rect(xpos, ypos, cardSize, cardSize);
    strokeWeight(1);
  }
}
