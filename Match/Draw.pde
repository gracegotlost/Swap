/*---------------------------------------------------------------
 Draw all positions of main body parts
 ----------------------------------------------------------------*/
void drawPosition() {
  imageMode(CENTER);
  image(headImage, bodyPosition[8].x, bodyPosition[8].y, headSize, headSize);
  
  for (int i = 0; i < bodyPart[currentLevel]; i++) {
    image(imageBody[imageOrder[i]], bodyPosition[i].x, bodyPosition[i].y, 100, 100);
  }
}

void drawFirstScene() {
   // bg
  PImage img = loadImage("profile_bg.jpg");
  imageMode(CORNER);
  image(img, 0, 0);

  // video frame
  imageMode(CENTER);
  image(kinectOpenNI.rgbImage(), width/2, height/2);
  filter(GRAY);
  
  // cover
  int offset = 10;
  pushStyle();
  fill(255);
  rect(width/2 - kinectOpenNI.depthWidth()/2, height/2 - kinectOpenNI.depthHeight()/2 - offset, (kinectOpenNI.depthWidth() - kinectOpenNI.depthHeight())/2, kinectOpenNI.depthHeight() + 2*offset);
  rect(width/2 + kinectOpenNI.depthHeight()/2, height/2 - kinectOpenNI.depthHeight()/2 - offset, (kinectOpenNI.depthWidth() - kinectOpenNI.depthHeight())/2, kinectOpenNI.depthHeight() + 2*offset);
  popStyle();

  // title
  textFont(font, 60);
  text("Take your head shot", width/2, 120);

  drawShutter();
}

void drawSecondScene() {
  PImage img = loadImage("tutorial.jpg");
  imageMode(CORNER);
  image(img, 0, 0);
}

void drawScene(String title) {
  // title
  textFont(font, 60);
  textAlign(LEFT);
  text(title, 50, 60);
  
  // time count down
  if(!hasStarted) {
    startTime = millis();
    hasStarted = true;
  }
  if(!bComplete && !isTimeout) {
    drawCountdown();
  }
}

void drawShutter() {
  PImage img = loadImage("button.png");
  double distance = sqrt(pow(mouseX - width/2, 2) + pow(mouseY - height*7/8, 2));
  
  if (distance < img.width/2) {
    img = loadImage("button2.png");
    if (mousePressed) {
      //take head screenshot
      saveHeadShot();
      headImage = loadImage("head.jpg");
      headImage.mask(maskImage);
      bContinue = true;
    }
  } 
  
  if (bContinue) {
    bContinue = false;
    currentScene++;
    setLevel();
  }
  
  imageMode(CENTER);
  image(img, width/2, height*7/8, img.width, img.height);
}

void drawButton() {
  // continue button
  PImage img = loadImage("button.png");
  double distance = sqrt(pow(bodyPosition[0].x-(width-400), 2) + pow(bodyPosition[0].y-(height-300), 2));
  if (distance < 100) {
    img = loadImage("button2.png");
    bContinue = true;
  } else if (bContinue) {
    bContinue = false;
    currentScene++;
    setLevel();
  }
  imageMode(CENTER);
  image(img, width-400, height-300, 100, 100);
}

void drawLose() {
  textFont(font, 60);
  textAlign(LEFT);
  text("You Lose!", 50, 60);
  
  pushStyle();
  fill(255);
  rect(width-400, height-300, 200, 100);
  fill(0);
  textFont(font, 60);
  textAlign(CENTER);
  text("Restart", width-300, height-225);
  popStyle(); 
  
  double distance = sqrt(pow(bodyPosition[0].x-(width-300), 2) + pow(bodyPosition[0].y-(height-250), 2));
  if (distance < 100) {
    bContinue = true;
  } else if (bContinue) {
    bContinue = false;
    currentScene = currentLevel + 1;
    setLevel();
  }
}

void drawCountdown() {
  int currentTime = millis() - startTime;
  int currentDuration = levelDuration[currentLevel] * 1000;
  if(currentTime < currentDuration) {
    int currentProgress = (int)map(currentTime, 0, currentDuration, 0, width/2);
    pushStyle();
    fill(255);
    rect(width/4, 40, width/2, 10);
    fill(0);
    rect(width/4, 40, currentProgress, 10);
    popStyle();
  } else {
    isTimeout = true;
    hasStarted = false;
  }
}
