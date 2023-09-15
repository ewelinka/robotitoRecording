class Robotito {
  int ypos, xpos, speed, size, directionX, directionY, ledSize, activeDirection;
  color colorRobotito, lastColor;
  float ledDistance;
  boolean recording, reproducing, isSelected, showRecordingLights;
  ArrayList<ColorDuration> recordingList;
  int reproductionStart, reproductionIndex;
  int frameOffset;
  ColorDuration actionToReproduce;
  Robotito (int x, int y) {
    xpos = x;
    ypos = y;
    speed = 1;
    size = 100;
    ledSize= 5;
    ledDistance = size*0.52/2-ledSize/2;
    directionX = directionY = activeDirection = 0;
    colorRobotito = #FCB603;
    lastColor = white;
    recording = false;
    reproducing = false;
    frameOffset = 0;
    isSelected = false;
    recordingList = new ArrayList<ColorDuration>();
    showRecordingLights = false;
  }
  void update() {
    xpos += speed*directionX;
    ypos += speed*directionY;
    if ((ypos > height) || (ypos < 0)) {
      directionY = 0;
    }
    if ((xpos > width) || (xpos < 0)) {
      directionX = 0;
    }
    if (reproducing) { // reproduce recorded
      // reproductionStart, reproductionIndex
      if (millis() - reproductionStart > actionToReproduce.duration) {
        //next action!
        if (reproductionIndex < recordingList.size()-1) {
          startActionReproduction(reproductionIndex+1);
        } else {
          reproducing = false;
          ignoredId = -1; // reset ignored ids at the end of reproduction to enable next violet
        }
      }
    } else { // sense and act
      // calculate offset necesary to change direction in the middle of the card depending direction
      int offsetX = directionX*offsetSensing*-1;
      int offsetY = directionY*offsetSensing*-1;
      // boolean awayFromCards = true; // will be used to undo ignoredId and allow to repeat violet
      for (ColorCard currentCard : allCards) {
        if (currentCard.isPointInside(xpos+offsetX, ypos+offsetY)) {
          //  awayFromCards = false;
          if (currentCard.id != ignoredId) {
            processColorAndId(currentCard.cardColor, currentCard.id);
          }
        }
      }
    }
  }
  void drawRobotitoAndLights() {
    drawRobotito();
    translate(xpos, ypos);
    draw4lights();
    drawDirectionLights();
  }

  void updatePosition(int x, int y) {
    xpos = x;
    ypos = y;
  }
  void drawRobotito() {
    fill(colorRobotito);
    stroke(strokeColor);
    circle(xpos, ypos, size);
    fill(255);
    noStroke();
    circle(xpos, ypos, size*0.62);
    fill(200);
    circle(xpos, ypos, size*0.52);
    fill(255);
    circle(xpos, ypos, size*0.42);
  }
  void draw4lights() {
    // 4 lights
    stroke(strokeColor);
    // green light
    pushMatrix();
    translate(0, -ledDistance);
    fill(green);
    circle(0, 0, ledSize);
    popMatrix();
    // red light
    pushMatrix();
    rotate(radians(180));
    translate(0, -ledDistance);
    fill(red);
    circle(0, 0, ledSize);
    popMatrix();
    //yellow
    pushMatrix();
    rotate(radians(90));
    translate(0, -ledDistance);
    fill(yellow);
    circle(0, 0, ledSize);
    popMatrix();
    //blue
    pushMatrix();
    rotate(radians(270));
    translate(0, -ledDistance);
    fill(blue);
    circle(0, 0, ledSize);
    popMatrix();
  }
  void drawDirectionLights() {
    switch(activeDirection) {
    case 1: // green
      drawArc(0, green);
      break;
    case 2: // yellow
      drawArc(90, yellow);
      break;
    case 3: // red
      drawArc(180, red);
      break;
    case 4: // blue
      drawArc(270, blue);
      break;
    }
  }

  void drawArc(int rotation, color ledArcColor) {
    pushMatrix();
    rotate(radians(rotation) + radians(360/24));
    translate(0, -ledDistance);
    fill(ledArcColor);
    stroke(strokeColor);
    circle(0, 0, ledSize);
    popMatrix();
    pushMatrix();
    rotate(radians(rotation)+radians(360/24)*2);
    translate(0, -ledDistance);
    fill(ledArcColor);
    circle(0, 0, ledSize);
    popMatrix();
    // left
    pushMatrix();
    rotate(radians(rotation)-radians(360/24));
    translate(0, -ledDistance);
    fill(ledArcColor);
    circle(0, 0, ledSize);
    popMatrix();
    pushMatrix();
    rotate(radians(rotation)-radians(360/24)*2);
    translate(0, -ledDistance);
    fill(ledArcColor);
    circle(0, 0, ledSize);
    popMatrix();
    if (recording) {
      if ((frameCount - frameOffset)%45 == 0) {
        showRecordingLights = !showRecordingLights;
      }
      if (showRecordingLights) {
        pushMatrix();
        rotate(radians(rotation)+radians(360/24)*3);
        translate(0, -ledDistance);
        fill(violet);
        circle(0, 0, ledSize);
        popMatrix();
        pushMatrix();
        rotate(radians(rotation)-radians(360/24)*3);
        translate(0, -ledDistance);
        fill(violet);
        circle(0, 0, ledSize);
        popMatrix();
      }
    } else if (reproducing) {
      pushMatrix();
      rotate(radians(rotation)+radians(360/24)*3);
      translate(0, -ledDistance);
      fill(violet);
      circle(0, 0, ledSize);
      popMatrix();
      pushMatrix();
      rotate(radians(rotation)-radians(360/24)*3);
      translate(0, -ledDistance);
      fill(violet);
      circle(0, 0, ledSize);
      popMatrix();
    } else if (!recording && !recordingList.isEmpty()) { // not recording but with some actiones stored
      // lights that indicate that we recorded something
      // draw4violet();
    }
  }

  void draw4violet() {
    stroke(strokeColor);
    for (int i = 0; i<4; i++) {
      pushMatrix();
      rotate(radians(90*i)+ radians(360/24)*3);
      translate(0, -ledDistance);
      fill(violet);
      circle(0, 0, ledSize);
      popMatrix();
    }
  }


  void processColorAndId(color currentColor, int id) {
    if (currentColor == green || currentColor == yellow || currentColor == red || currentColor == blue || currentColor == violet) {
      print(frameRate);
      if (currentColor == violet) { // 3 options: start to record, finish to record, use the function
        if (!recording && recordingList.isEmpty()) { // we should start to record!
          recording  = true;
          playRecordingStart();
          // registr the active color and start to count
          int currentTimestamp = millis();
          recordingList.add(new ColorDuration(lastColor, currentTimestamp));
          println("START RECORDING ");
        } else if (recording) {// finish to record, update last color duration
          recording = false;
          record(white, true); //last!
          playRecordingStop();
          println("RECORDING READY");
        } else { // recording is false but the list is not empty!
          //use the power!!
          println("USE THE POWER");
          reproducing = true;
          frameOffset = frameCount - floor(frameCount/100)*100;
          startActionReproduction(0);
        }
      } else {
        if (recording) { // record current color
          record(currentColor, false);
        }
        if (currentColor == green) {
          directionY = -1;
          directionX = 0;
          activeDirection = 1;
        } else if (currentColor == yellow) {
          directionY = 0;
          directionX = 1;
          activeDirection = 2;
        } else if (currentColor == red) {
          directionY = 1;
          directionX = 0;
          activeDirection = 3;
        } else if (currentColor == blue) {
          directionY = 0;
          directionX = -1;
          activeDirection = 4;
        }
      }
      ignoredId = id;
      lastColor = currentColor; // we need it be able to record the first action
    }
  }

  void processColorAndIdFromRecorded(color currentColor) {
    println(" PROCESSING RECORDED " +colorToName(currentColor)+" duration "+actionToReproduce.duration);
    if (currentColor == green) {
      directionY = -1;
      directionX = 0;
      activeDirection = 1;
    } else if (currentColor == yellow) {
      directionY = 0;
      directionX = 1;
      activeDirection = 2;
    } else if (currentColor == red) {
      directionY = 1;
      directionX = 0;
      activeDirection = 3;
    } else if (currentColor == blue) {
      directionY = 0;
      directionX = -1;
      activeDirection = 4;
    }
  }
  void record(color current, boolean isLast) {
    int currentTimestamp = millis();
    ColorDuration toUpdate = recordingList.get(recordingList.size()-1);
    toUpdate.setDuration(currentTimestamp - toUpdate.getDuration());
    println(colorToName(toUpdate.col)+"  "+ toUpdate.getDuration());
    ;
    if (!isLast) {
      recordingList.add(new ColorDuration(current, currentTimestamp));
    }
  }

  void startActionReproduction(int index) {
    reproductionIndex = index;
    reproductionStart = millis();
    actionToReproduce = recordingList.get(reproductionIndex);
    processColorAndIdFromRecorded(actionToReproduce.col);
  }

  void setIsSelected(boolean is) {
    isSelected = is;
  }

  void playRecordingStart() {
    out.playNote(0, 0.1, 200);
    out.playNote(0.1, 0.1, 300);
    out.playNote(0.2, 0.1, 500);
    out.playNote(0.3, 0.1, 800);
  }
  void playRecordingStop() {
    out.playNote(0, 0.1, 800);
    out.playNote(0.1, 0.1, 500);
    out.playNote(0.2, 0.1, 300);
    out.playNote(0.3, 0.1, 200);
  }
}
