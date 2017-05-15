/*---------------------------------------------------------------
 Draw all positions of main body parts
 ----------------------------------------------------------------*/
void drawPosition() {
  imageMode(CENTER);
  if(currentLevel < 3) {
    image(imageBody[4], bodyPosition[4].x, bodyPosition[4].y, partSize, partSize);
  }
  
  for (int i = 0; i < bodyPart[currentLevel]; i++) {
    image(imageBody[imageOrder[i]], bodyPosition[i].x, bodyPosition[i].y, partSize, partSize);
  }
}

void drawPositionLastLevel() {
  imageMode(CENTER);
  for (int i = 0; i < bodyPart[currentLevel]; i++) {
    if (i != 0 && i != 3) {
      image(imageBody[imageOrder[i]], bodyPosition[i].x, bodyPosition[i].y, partSize, partSize);
    }
  }
  drawHead();
  drawElbow();
}

void drawHead() {
  image(imageBody[4], 100, 100, partSize, partSize);
}

void drawElbow() {
  image(imageBody[5], 600, height/2, partSize, partSize);
}

void drawShutter() {
  PImage img = loadImage("cheese.png");
  double distance = sqrt(pow(mouseX - width/2, 2) + pow(mouseY - (height*7/8-30), 2));
  
  if (distance < btnWidth/2) {
    img = loadImage("cheese_hover.png");
    if (mousePressed) {
      //take head screenshot
      saveHeadShot();
      bContinue = true;
    }
  } 
  
  if (bContinue) {
    bContinue = false;
    // for game
    currentScene++;
    // for testing
    currentScene = 6;
    currentLevel = 5;
    setLevel();
  }
  
  imageMode(CENTER);
  image(img, width/2, height*7/8-30, btnWidth, btnHeight);
}

void drawButton() {
  // continue button
  PImage img = loadImage("next.png");
  double distance = sqrt(pow(bodyPosition[0].x-(width-400), 2) + pow(bodyPosition[0].y-(height-300), 2));
  if (distance < 100) {
    img = loadImage("next_hover.png");
    bContinue = true;
  } else if (bContinue) {
    bContinue = false;
    currentScene++;
    setLevel();
    setFound();
  }
  imageMode(CENTER);
  image(img, width-400, height-300, btnWidth, btnHeight);
}

void drawRestart() {
  PImage img = loadImage("restart.png");
  imageMode(CENTER);
  image(img, width-400, height-300, btnWidth, btnHeight);
  
  double distance = sqrt(pow(bodyPosition[0].x-(width-400), 2) + pow(bodyPosition[0].y-(height-300), 2));
  if (distance < 100) {
    img = loadImage("restart_hover.png");
    image(img, width-400, height-300, btnWidth, btnHeight);
    bContinue = true;
  } else if (bContinue) {
    bContinue = false;
    if(currentScene == 6 && bComplete) {
      currentScene = 1;
      currentLevel = 1;
    } else {
      currentScene = currentLevel + 1;
      setLevel();
    }
    setFound();
  }
}

void drawCountdown() {
  int currentTime = millis() - startTime;
  int currentDuration = levelDuration[currentLevel] * 1000;
  if(currentTime < currentDuration) {
    int currentProgress = (int)map(currentTime, 0, currentDuration, 0, width/2);
    pushStyle();
    fill(255);
    rect(width/4, 50, width/2, 10);
    fill(0);
    rect(width/4, 50, currentProgress, 10);
    popStyle();
  } else {
    isTimeout = true;
    hasStarted = false;
  }
}
