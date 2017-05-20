void gamePlaying(int i) {
  drawSkeleton(userID[i]);
  drawPosition();
  checkSwap();
  unlock();
  if (checkComplete()) {
    gameComplete();
  }
}

void gamePlayingLastLevel(int i) {
  drawSkeleton(userID[i]);
  drawPositionLastLevel();
  checkFoundHead();
  checkFoundElbow();
  checkSwap();
  unlock();
  if (checkComplete()) {
    gameComplete();
  }
}

void gameComplete() {
  player.rewind(); 
  player.play();
  int temptime = millis();
  while (millis () - temptime < 2000)
    ;
    
  if(currentScene == 4) {
    currentScene = 1;
    currentLevel = 1;
  } else {
    currentScene++;
    currentLevel++;
  }
  setLevel();
  setFound();
}

void gameNext() {
  imageMode(CENTER);
  image(imageBody[0], bodyPosition[0].x, bodyPosition[0].y, partSize, partSize);
}

void checkFoundHead() {
  if (!foundHead && showHead) {
    if (imageOrder[0] == -1) {
      double distanceA = sqrt(pow(bodyPosition[0].x-headX, 2) + pow(bodyPosition[0].y-headY, 2));
      if (distanceA < 100) {
        imageOrder[0] = 4;
        showHead = false;
        foundHead = true;
      }
    }
    if (imageOrder[3] == -1) {
      double distanceB = sqrt(pow(bodyPosition[3].x-headX, 2) + pow(bodyPosition[3].y-headY, 2));
      if (distanceB < 100) {
        imageOrder[3] = 4;
        showHead = false;
        foundHead = true;
      }
    }
  }
}

void checkFoundElbow() {
  if (!foundElbow && showElbow) {
    if (imageOrder[0] == -1) {
      double distanceA = sqrt(pow(bodyPosition[0].x-elbowX, 2) + pow(bodyPosition[0].y-elbowY, 2));
      if (distanceA < 100) {
        imageOrder[0] = 5;
        showElbow = false;
        foundElbow = true;
      }
    }
    if (imageOrder[3] == -1) {
      double distanceB = sqrt(pow(bodyPosition[3].x-elbowX, 2) + pow(bodyPosition[3].y-elbowY, 2));
      if (distanceB < 100) {
        imageOrder[3] = 5;
        showElbow = false;
        foundElbow = true;
      }
    }
  }
}

/*---------------------------------------------------------------
 If any two of body parts touch each other, then swap these two parts on the screen
 ----------------------------------------------------------------*/
void checkSwap() {
  for (int i = 0; i < bodyPart[currentLevel]; i++) {
    if (locked[i])
      continue;
    if (imageOrder[i] == -1)
      continue;
    for (int j = 0; j < i; j++) {
      if (locked[j])
        continue;
      if (imageOrder[j] == -1)
        continue;
      float x = bodyPosition[i].x - bodyPosition[j].x;
      float y = bodyPosition[i].y - bodyPosition[j].y;
      double distance = sqrt(pow(x, 2) + pow(y, 2));
      if (distance < 60 ) {
        int temp = imageOrder[i];
        imageOrder[i] = imageOrder[j];
        imageOrder[j] = temp;
        locked[i] = locked[j] = true;
      }
    }
  }
}

void unlock() {
  for (int i = 0; i < bodyPart[currentLevel]; i++) {
    if (!locked[i])
      continue;

    locked[i] = false;
    for (int j = 0; j < bodyPart[currentLevel] && j != i; j++) {
      float x = bodyPosition[i].x - bodyPosition[j].x;
      float y = bodyPosition[i].y - bodyPosition[j].y;
      double distance = sqrt(pow(x, 2) + pow(y, 2));
      if (distance < 100)
        locked[i] = true;
    }
  }
}

/*---------------------------------------------------------------
 If all images are in order, then this level is completed
 ----------------------------------------------------------------*/
boolean checkComplete() {
  for (int i = 0; i < bodyPart[currentLevel]; i++)
    if (locked[i] || imageOrder[i] != i)
      return false;

  return true;
}

void setFound() {
  if (currentScene == 4) {
    foundHead = false;
    foundElbow = false;
  } else {
    foundHead = true;
    foundElbow = true;
  }
}
