Robotito robotito;
PGraphics back;
color cardColor, yellow, blue, green, red, white, markerColor, violet;
int cardSize;
boolean puttingCards, stopRobot;
int offsetSensing;
int strokeThickness, strokeColor;

Card selectedCard;
int ignoredId;
ArrayList<Card> allCards;

void setup() {
  size(800, 800);
  ellipseMode(CENTER);
  smooth();
  robotito = new Robotito(width/2, height/2);
  back = createGraphics(width, height);
  back.beginDraw();
  back.noStroke();
  back.background(255);
  back.rectMode(CENTER);
  back.imageMode(CENTER);
  back.endDraw();

  yellow = #FAF021;
  blue = #2175FA;
  red = #FA0F2B;
  green = #02E01A;
  white = #FFFFFF;
  markerColor = #000000;
  violet = #A20FFF;

  cardColor = green;
  cardSize = 100;
  puttingCards = true;
  stopRobot = false;
  offsetSensing = cardSize/2;
  ignoredId = -1;
  strokeThickness = 4;
  strokeColor = 185;
  allCards = new ArrayList<Card>();
  initWithCards();
}

void draw() {
  drawMat();
  displayCards();
  if (!stopRobot) {
    robotito.update();
  }
  robotito.drawRobotitoAndLights();
  checkIfNewCardNeeded();
}

void mousePressed() {
  boolean foundOne = false;
  if (dist(robotito.xpos, robotito.ypos, mouseX, mouseY) < robotito.size/2)
  {
    robotito.setIsSelected(true);
    foundOne = true;
  }else{
    robotito.setIsSelected(false);
  }
  
  for (int i = allCards.size()-1; i >= 0; i--) {
    Card currentCard = allCards.get(i);
    if (currentCard.isPointInside(mouseX, mouseY) && !foundOne) {
      selectedCard =  currentCard;
      currentCard.setIsSelected(true);
      foundOne = true;
    } else {
      currentCard.setIsSelected(false);
    }
  }
}
void mouseDragged() {
  for (Card currentCard : allCards) {
    if (currentCard.isPointInside(mouseX, mouseY) && currentCard.isSelected) {
      currentCard.updatePosition(mouseX, mouseY);
    }
  }
  if ((dist(robotito.xpos, robotito.ypos, mouseX, mouseY) < robotito.size/2) && robotito.isSelected)
  {
    robotito.updatePosition(mouseX, mouseY);
  }
}
void keyPressed() {
  if (key == 'p' || key == 'P') {
    puttingCards = !puttingCards;
  } else if (key == 's' || key == 'S') {
    stopRobot = !stopRobot;
  } else if (key == 'd' || key == 'D') {
    deleteSelectedCard();
  } else if (key == CODED) {
    if (keyCode == DOWN) {
      if (puttingCards) {
        addCard(mouseX, mouseY);
      }
    }
  } else {
    if (key == 'b' || key == 'B') {
      cardColor = blue; // azul
    } else if (key == 'r' || key == 'R') {
      cardColor = red; // rojo
    } else if (key == 'g' || key == 'G') {
      cardColor = green; // verde
    } else if (key == 'y' || key == 'Y') {
      cardColor = yellow; // amarillo
    } else if (key == 'v' || key == 'V') {
      cardColor = violet;
    }
  }
}

void addCard(int x, int y) {
  allCards.add(new ColorCard(x, y, cardSize, cardColor));
}

void drawMat() {
  int initPixel = 60;
  int maxPixel = initPixel + (cardSize+40)*4 ;
  back.beginDraw();
  back.background(255);
  for (int i=initPixel; i<= maxPixel; i=i+cardSize+40) {
    back.stroke(0);
    back.strokeWeight(1);
    back.line(initPixel, i, maxPixel, i);
  }
  for (int i=initPixel; i<= maxPixel; i=i+cardSize+40) {
    back.line(i, initPixel, i, maxPixel);
  }
  back.endDraw();
}
void displayCards() {
  for (Card currentCard : allCards) {
    currentCard.addToBackground();
  }
  image(back, 0, 0);
}

void deleteSelectedCard() {
  allCards.remove(selectedCard);
}
void initWithCards() {
  int x = 0 + cardSize/2 + 10;
  int y = height - cardSize/2 -10;
  allCards.add(new ColorCard(x, y, cardSize, green, 1));
  x = x + cardSize + 10;
  allCards.add(new ColorCard(x, y, cardSize, red, 2));
  x = x + cardSize + 10;
  allCards.add(new ColorCard(x, y, cardSize, yellow, 3));
  x = x + cardSize + 10;
  allCards.add(new ColorCard(x, y, cardSize, blue, 4));
  x = x + cardSize + 10;
  allCards.add(new ColorCard(x, y, cardSize, violet, 5));
}

void checkIfNewCardNeeded() {
  int x = 0 + cardSize/2 + 10;
  int y = height - cardSize/2 -10;
  if (back.get(x, y) != green) {
    allCards.add(new ColorCard(x, y, cardSize, green));
  }
  x = x + cardSize + 10;
  if (back.get(x, y) != red) {
    allCards.add(new ColorCard(x, y, cardSize, red));
  }
  x = x + cardSize + 10;
  if (back.get(x, y) != yellow) {
    allCards.add(new ColorCard(x, y, cardSize, yellow));
  }
  x = x + cardSize + 10;
  if (back.get(x, y) != blue) {
    allCards.add(new ColorCard(x, y, cardSize, blue));
  }
  x = x + cardSize + 10;
  if (back.get(x, y) != violet) {
    allCards.add(new ColorCard(x, y, cardSize, violet));
  }
}

String colorToName(int colorNow) {
  String toReturn = "";
  switch(colorNow) {
  case -16588774:
    toReturn = "green";
    break;
  case -1:
    toReturn = "white";
    break;
  case -331743:
    toReturn = "yellow";
    break;
  case -389333:
    toReturn = "red";
    break;
  case -14584326:
    toReturn = "blue";
    break;
  case -16777216:
    toReturn = "marker";
    break;
  }
  return toReturn;
}
