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
  checkSwap();
  unlock();
  if (checkComplete()) {
    gameComplete();
  }
}

void gameOver() {
  isTimeout = false;
  isPlayingAnim = true;
  currentOpacity = 0;
  startOpacity = millis();
  currentScene = 7;
}

void gameOverLastLevel() {
  gameOver();
}

void gameComplete() {
  currentLevel++;
  player.rewind(); 
  player.play();
  int temptime = millis();
  while (millis () - temptime < 2000)
    ;
  hasStarted = false;
  bComplete = true;
}

void gameNext() {
  imageMode(CENTER);
  image(imageBody[0], bodyPosition[0].x, bodyPosition[0].y, partSize, partSize);
}

/*---------------------------------------------------------------
 If any two of body parts touch each other, then swap these two parts on the screen
 ----------------------------------------------------------------*/
void checkSwap() {
  for (int i = 0; i < bodyPart[currentLevel]; i++) {
    if (locked[i])
      continue;
    if (i == 0 && !foundHead) {
      continue;
    }
    if (i == 3 && !foundElbow) {
      continue;
    }
    for (int j = 0; j < i; j++) {
      if (locked[j])
        continue;
      if (j == 0 && !foundHead) {
        continue;
      }
      if (j == 3 && !foundElbow) {
        continue;
      }
      float x = bodyPosition[i].x - bodyPosition[j].x;
      float y = bodyPosition[i].y - bodyPosition[j].y;
      double distance = sqrt(pow(x, 2) + pow(y, 2));
      if (distance < 50 ) {
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
  if (currentScene == 6) {
    foundHead = false;
    foundElbow = false;
  } else {
    foundHead = true;
    foundElbow = true;
  }
}
