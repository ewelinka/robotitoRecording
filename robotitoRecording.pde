import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;
AudioOutput out;

Robotito robotito;

color cardColor, yellow, blue, green, red, white, markerColor, violet;
int cardSize;
boolean puttingCards, stopRobot;
int offsetSensing;
int strokeThickness, strokeColor;

ColorCard selectedCard;
int ignoredId;
ArrayList<ColorCard> allCards;

void setup() {
  size(800, 800);
  ellipseMode(CENTER);
  smooth();
  robotito = new Robotito(width/2, height/2);
  noStroke();
  background(255);
  rectMode(CENTER);
  imageMode(CENTER);

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
  allCards = new ArrayList<ColorCard>();
  initWithCards();
  
  // musical part
  minim = new Minim(this);
  // use the getLineOut method of the Minim object to get an AudioOutput object
  out = minim.getLineOut();
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
    ColorCard currentCard = allCards.get(i);
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
    robotito.updatePositionDragged(mouseX, mouseY);
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
  background(255);
  stroke(0);
  strokeWeight(1);
  for (int i=initPixel; i<= maxPixel; i=i+cardSize+40) {
    line(initPixel, i, maxPixel, i);
  }
  for (int i=initPixel; i<= maxPixel; i=i+cardSize+40) {
    line(i, initPixel, i, maxPixel);
  }
}
void displayCards() {
  for (Card currentCard : allCards) {
    currentCard.addToBackground();
  }
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
  if (get(x, y) != green) {
    allCards.add(new ColorCard(x, y, cardSize, green));
  }
  x = x + cardSize + 10;
  if (get(x, y) != red) {
    allCards.add(new ColorCard(x, y, cardSize, red));
  }
  x = x + cardSize + 10;
  if (get(x, y) != yellow) {
    allCards.add(new ColorCard(x, y, cardSize, yellow));
  }
  x = x + cardSize + 10;
  if (get(x, y) != blue) {
    allCards.add(new ColorCard(x, y, cardSize, blue));
  }
  x = x + cardSize + 10;
  if (get(x, y) != violet) {
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
