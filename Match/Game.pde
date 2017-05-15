void gamePlaying(int i) {
  drawSkeleton(userID[i]);
  drawPosition();
  checkSwap();
  unlock();
  if (checkComplete()) {
    currentLevel++;
    player.rewind(); 
    player.play();
    int temptime = millis();
    while (millis () - temptime < 2000)
      ;
    hasStarted = false;
    bComplete = true;
  }
}

void gameOver() {
  isTimeout = false;
  isPlayingAnim = true;
  currentOpacity = 0;
  startOpacity = millis();
  currentScene = 7;
}

void gameNext() {
  imageMode(CENTER);
  image(imageBody[0], bodyPosition[0].x, bodyPosition[0].y, partSize, partSize);
}
