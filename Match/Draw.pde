/*---------------------------------------------------------------
 Draw all positions of main body parts
 ----------------------------------------------------------------*/
void drawPosition() {
  imageMode(CENTER);
  if(currentLevel == 1) {
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

void drawInstruction(String instruct) {
  if (millis() - countShow > 500 && countStarted) {
    countStarted = false;
    countHide = millis();
  } else if (millis() - countHide > 500 && !countStarted) {
    countStarted = true;
    countShow = millis();
  }
  
  if (countStarted) {
    textFont(font, 60);
    textAlign(CENTER);
    text(instruct, width/2, height/2);
  }
}
