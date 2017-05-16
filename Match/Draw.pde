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
    if (imageOrder[i] == -1)
     continue;
    image(imageBody[imageOrder[i]], bodyPosition[i].x, bodyPosition[i].y, partSize, partSize);
  }
  if (!foundHead) {
    drawHead();
  }
  if (!foundElbow) {
    drawElbow();
  }
  redrawScene("Level 4");
}

void drawHead() {
  int interval = millis()%7000;
  headX = width/10;
  headY = height/10;
  float headSize = 0.5;
  
  if (interval >= 0 && interval <= 100) {
    showHead = true;
  }
  
  if (showHead) {
    if (interval >= 0 && interval <= 1500) {
      headX = map(interval, 0, 1500, width/8, width/5.3);
      headY = map(interval, 0, 1500, height/8, height/4.5);
      headSize = map(interval, 0, 1500, 0.5, 1);
    } else if (interval > 1500 && interval <= 2000) {
      headX = width/5.3;
      headY = height/4.5;
      headSize = 1;
    } else if (interval > 2000 && interval <= 3500) {
      headX = map(interval, 2000, 3500, width/5.3, width/8);
      headY = map(interval, 2000, 3500, height/4.5, height/8);
      headSize = map(interval, 2000, 3500, 1, 0.5);
    } else if (interval > 3500 && interval <= 5000) {
      headX = map(interval, 3500, 5000, width/8, width/5);
      headY = height/2;
      headSize = map(interval, 3500, 5000, 0.5, 1);
    } else if (interval > 5000 && interval <= 6000) {
      headX = map(interval, 5000, 6000, width/5, width/8);
      headY = height/2;
      headSize = map(interval, 5000, 6000, 1, 0.5);
    } else {
      showHead = false;
    }
  }
  
  pushMatrix();
  translate(headX, headY);
  scale(headSize);
  image(imageBody[4], 0, 0, partSize, partSize);
  popMatrix();
}

void drawElbow() {
  int interval = millis()%6000;
  elbowX = width*11/12;
  elbowY = height/2-height/80;
  if (interval >= 0 && interval <= 100) {
    showElbow = true;
  }
  
  if (showElbow) {
    if (interval >= 0 && interval <= 1500) {
      elbowX = map(interval, 0, 1500, width*11/12, width*10/12);
    } else if (interval > 1500 && interval <= 2000) {
      elbowX = width*10/12;
    } else if (interval > 2000 && interval <= 3000) {
      elbowX = map(interval, 2000, 3000, width*10/12, width*11/12);
    } else {
      showElbow = false;
    }
  }
  
  image(imageBody[5], elbowX, elbowY, partSize, partSize);
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
//    currentScene = 6;
//    currentLevel = 5;
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
