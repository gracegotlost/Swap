void drawFirstScene() {
  // bg
  PImage img = loadImage("profile_bg.png");
  imageMode(CORNER);
  image(img, 0, 0, width, height);

  // video frame
  imageMode(CENTER);
  image(kinectOpenNI.rgbImage(), width/2, height/2-40);
  filter(GRAY);
  
  // cover
  int offset = 50;
  pushStyle();
  fill(255);
  stroke(255);
  strokeWeight(0);
  rect(width/2 - kinectOpenNI.depthWidth()/2, height/2 - kinectOpenNI.depthHeight()/2 - offset, (kinectOpenNI.depthWidth() - kinectOpenNI.depthHeight())/2, kinectOpenNI.depthHeight() + 2*offset);
  rect(width/2 + kinectOpenNI.depthHeight()/2, height/2 - kinectOpenNI.depthHeight()/2 - offset, (kinectOpenNI.depthWidth() - kinectOpenNI.depthHeight())/2, kinectOpenNI.depthHeight() + 2*offset);
  fill(0, 0);
  stroke(0);
  strokeWeight(8);
  rectMode(CENTER);
  rect(width/2, height/2-40, kinectOpenNI.depthHeight(), kinectOpenNI.depthHeight());
  popStyle();

  drawShutter();
}

void drawSecondScene() {
  PImage img = loadImage("tutorial.png");
  imageMode(CORNER);
  image(img, 0, 0, width, height);
}

void drawScene(String title) {
  // level bg
  imageMode(CORNER);
  image(levelBG, 0, 0, width, height);
  
  // title
  
  textFont(font, 60);
  textAlign(LEFT);
  text(title, 50, 80);
  
  // time count down
  if(!hasStarted) {
    startTime = millis();
    hasStarted = true;
  }
  if(!bComplete && !isTimeout) {
    drawCountdown();
  }
}

void drawLose() {
  if(isPlayingAnim) {
    currentOpacity = map(millis()-startOpacity, 0, 1000, 0, 255);
    if(millis()-startOpacity > 1000) {
      isPlayingAnim = false;
    }
  } else {
    currentOpacity = 255;
  }
  
  PImage animateImg = loadImage("level_bg_dead.png");
  imageMode(CORNER);
  pushStyle();
  tint(255, currentOpacity);
  image(animateImg, 0, 0, width, height);
  popStyle();
  
  textFont(font, 60);
  textAlign(LEFT);
  text("BOOOOO!", 50, 80);
  
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
    currentScene = currentLevel + 1;
    setLevel();
  }
}
