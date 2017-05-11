
/*---------------------------------------------------------------
 Imports
 ----------------------------------------------------------------*/
// import kinect library
import SimpleOpenNI.*;
import ddf.minim.*;

/*---------------------------------------------------------------
 Kinect Variables
 ----------------------------------------------------------------*/
// create kinect object for skeleton tracking
SimpleOpenNI  kinectOpenNI;
// image storage from kinect
PImage kinectDepth;
// int of each user being  tracked
int[] userID;
// user colors
color[] userColor = new color[] { 
  color(255, 0, 0), color(0, 255, 0), color(0, 0, 255), 
  color(255, 255, 0), color(255, 0, 255), color(0, 255, 255)
};

// position of head to draw circle
PVector headPosition = new PVector();
// turn headPosition into scalar form
float distanceScalar;
// diameter of head drawn in pixels
float headSize = 200;

// threshold of level of confidence
float confidenceLevel = 0.5;
// the current confidence level that the kinect is tracking
float confidence;
// vector of tracked head for confidence checking
PVector confidenceVector = new PVector();

/*---------------------------------------------------------------
 My Variables
 ----------------------------------------------------------------*/

String[] imageName = {
  "lefthand.png", "righthand.png", "leftfoot.png", "rightfoot.png", 
  "leftelbow.png", "rightelbow.png", "lefthand.png", "lefthand.png", "lefthand.png"
};
PVector[] bodyPosition = new PVector[15];
PImage[] imageBody = new PImage[9];
int[] imageOrder = new int[9];
boolean[] locked = new boolean[9];
AudioPlayer player;
Minim minim;

/*---------------------------------------------------------------
 Game Control
 ----------------------------------------------------------------*/
int currentLevel = 1;
int currentScene = 1;
int[] bodyPart = {
  0, 2, 4, 6, 8, 9
};
int starttime = 0;
boolean bComplete = false;
boolean bContinue = false;
PFont font;
/*---------------------------------------------------------------
 Starts new kinect object and enables skeleton tracking. 
 Draws window
 ----------------------------------------------------------------*/
void setup()
{
  // start a new kinect object
  kinectOpenNI = new SimpleOpenNI(this);
  // enable depth sensor 
  kinectOpenNI.enableDepth();
  kinectOpenNI.enableRGB();
  // enable skeleton generation for all joints
  kinectOpenNI.enableUser();

  // set up style
  imageMode(CENTER);
  textAlign(CENTER);
  strokeWeight(3);
  fill(0);

  // size
  size(displayWidth, displayHeight);

  // set bodyPosition and image
  for (int i = 0; i < bodyPosition.length; i++) {
    bodyPosition[i] = new PVector();
  }

  for (int i = 0; i < imageBody.length; i++) {
    imageBody[i] = loadImage(imageName[i]);
    imageOrder[i] = i;
  }

  setLevel();

  //sount init
  minim = new Minim(this);
  player = minim.loadFile("ka.mp3", 2048);

  // font init
  font = loadFont("YuppySC-Regular-72.vlw");
}

/*---------------------------------------------------------------
 Updates Kinect. Gets users tracking and draws skeleton and
 head if confidence of tracking is above threshold
 ----------------------------------------------------------------*/
void draw() {
  background(255);

  switch(currentScene) {
  case 1:
    drawFirstScene();
    break;
  case 2:
    drawScene("Instruction", "You are cut into pieces and all your body parts\nare messed up. Swap body parts to make\nall of them in order.", true);
    break;
  case 3:
    drawThirdScene();
    break;
  case 4:
    drawScene("Level 1", "", false);
    break;
  case 5:
    drawScene("Level 2", "", false);
    break;
  case 6:
    drawScene("Level 3", "", false);
    break;
  case 7:
    drawScene("Thank You", "Everybody, come to try!", false);
    break;
  default:
    break;
  }

  // update the camera
  kinectOpenNI.update();
  // get all user IDs of tracked users
  userID = kinectOpenNI.getUsers();

  // loop through each user to see if tracking
  for (int i = 0; i < userID.length; i++)
  {
    // if Kinect is tracking certain user then get joint vectors
    if (kinectOpenNI.isTrackingSkeleton(userID[i]))
    {
      // get confidence level that Kinect is tracking head
      confidence = kinectOpenNI.getJointPositionSkeleton(userID[i], SimpleOpenNI.SKEL_HEAD, confidenceVector);
      // if confidence of tracking is beyond threshold, then track user
      if (confidence > confidenceLevel)
      {
        getPosition(userID[i]);
        if (currentScene == 4 || currentScene == 5 || currentScene == 6) {
          if (bComplete == false) {
            convertPosition();
            drawPosition();
            drawSkeleton(userID[i]);
            checkSwap();
            unlock();
            if (checkComplete()) {
              currentLevel++;
              player.rewind(); 
              player.play();
              int temptime = millis();
              while (millis () - temptime < 2000)
                ;
              bComplete = true;
            }
          } else {
            PImage img = loadImage("instruction3.png");
            imageMode(CORNER);
            //image(img, 700 - bodyPosition[8].x, bodyPosition[8].y);
            image(imageBody[1], displayWidth-map(bodyPosition[0].x, 0, kinectOpenNI.depthWidth(), 0, displayWidth), map(bodyPosition[0].y, 0, kinectOpenNI.depthHeight(), 0, displayHeight));
            drawButton();
          }
        } else
          image(imageBody[1], displayWidth-map(bodyPosition[0].x, 0, kinectOpenNI.depthWidth(), 0, displayWidth), map(bodyPosition[0].y, 0, kinectOpenNI.depthHeight(), 0, displayHeight));
      }
    }
  }
}

void setLevel() {
  bComplete = false;
  switch(currentLevel) {
  case 1:
    imageOrder[0] = 1;
    imageOrder[1] = 0;
    break;
  case 2:
    imageOrder[0] = 2;
    imageOrder[1] = 3;
    imageOrder[2] = 1;
    imageOrder[3] = 0;
    break;
  case 3:
    imageOrder[0] = 2;
    imageOrder[1] = 4;
    imageOrder[2] = 0;
    imageOrder[3] = 1;
    imageOrder[4] = 3;
    break;
  default:
    break;
  }
}

/*---------------------------------------------------------------
 If any two of body parts touch each other, then swap these two parts on the screen
 ----------------------------------------------------------------*/
void checkSwap() {
  for (int i = 0; i < bodyPart[currentLevel]; i++) {
    if (locked[i])
      continue;
    for (int j = 0; j < i; j++) {
      if (locked[j])
        continue;
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
    if (locked[i] == false)
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

/*---------------------------------------------------------------
 Draw all positions of main body parts
 ----------------------------------------------------------------*/
void drawPosition() {
  // create a distance scalar related to the depth in z dimension
  distanceScalar = (525/bodyPosition[8].z);
  // draw the circle at the position of the head with the head size scaled by the distance scalar
  ellipse(bodyPosition[8].x, bodyPosition[8].y, distanceScalar*headSize, distanceScalar*headSize);

  for (int i = 0; i < bodyPart[currentLevel]; i++) {
    image(imageBody[imageOrder[i]], bodyPosition[i].x, bodyPosition[i].y);
  }
}

void drawScene(String title, String content, boolean bButton) {
  // title
  textFont(font, 60);
  textAlign(CENTER);
  text(title, width/2, 100);

  // content
  textFont(font, 30);
  textAlign(LEFT);
  text(content, 50, 150);

  if (bButton)
    drawButton();
}

void drawFirstScene() {
  // video frame
  image(kinectOpenNI.rgbImage(), displayWidth/2, displayHeight/2);
  
  // title
  textFont(font, 60);
  text("Take a head shot and join this game", width/2, 100);

  drawShutter();
}

void drawThirdScene() {
  // title
  textFont(font, 60);
  text("How to play", width/2, 100);

  PImage img1 = loadImage("instruction1.png");
  PImage img2 = loadImage("instruction2.png");
  PImage img3 = loadImage("instruction3.png");
  PImage headImg = loadImage("head.jpg");
  image(img1, displayWidth/6, 150);
  image(img2, displayWidth/2, 150);
  image(img3, displayWidth*5/6, 150);
  image(headImg, displayWidth/6, 150, 100, 100);
  image(headImg, displayWidth/2, 150, 100, 100);
  image(headImg, displayWidth*5/6, 150, 100, 100);

  textFont(font, 24);
  textAlign(LEFT);
  text("1. Detect your body parts", 50, 500);
  text("2. Touch two body parts to swap", 50, 550);
  text("3. Make all body parts in order to complete this level", 50, 600);

  drawButton();
}

void drawShutter() {
  PImage img = loadImage("button.png");
  double distance = sqrt(pow(mouseX - displayWidth/2, 2) + pow(mouseY - displayHeight*7/8, 2));
  
  if (distance < img.width/2) {
    img = loadImage("button2.png");
    if (mousePressed) {
      //take head screenshot
      saveHeadShot();
      bContinue = true;
    }
  } 
  
  if (bContinue) {
    bContinue = false;
    currentScene++;
    setLevel();
  }
  
  image(img, displayWidth/2, displayHeight*7/8, img.width, img.height);
}

void drawButton() {
  float x = displayWidth-map(bodyPosition[0].x, 0, kinectOpenNI.depthWidth(), 0, displayWidth);
  float y = map(bodyPosition[0].y, 0, kinectOpenNI.depthHeight(), 0, displayHeight);
  // continue button
  PImage img = loadImage("button.png");
  double distance = sqrt(pow(x-(displayWidth-400), 2) + pow(y-(displayHeight-400), 2));
  if (distance < 100) {
    img = loadImage("button2.png");
    bContinue = true;
  } else if (bContinue) {
    bContinue = false;
    currentScene++;
    setLevel();
  }
  image(img, displayWidth-400, displayHeight-400, 100, 100);
}

void saveHeadShot() {
  PImage headShot = get(displayWidth/2 - kinectOpenNI.depthHeight()/2, displayHeight/2 - kinectOpenNI.depthHeight()/2, kinectOpenNI.depthHeight(), kinectOpenNI.depthHeight());
  headShot.save("data/head.jpg");
}

/*---------------------------------------------------------------
 Get all positions of main body parts
 ----------------------------------------------------------------*/
void getPosition(int userId) {
  kinectOpenNI.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, bodyPosition[0]);
  kinectOpenNI.convertRealWorldToProjective(bodyPosition[0], bodyPosition[0]);
  kinectOpenNI.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, bodyPosition[1]);
  kinectOpenNI.convertRealWorldToProjective(bodyPosition[1], bodyPosition[1]);
  kinectOpenNI.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_FOOT, bodyPosition[2]);
  kinectOpenNI.convertRealWorldToProjective(bodyPosition[2], bodyPosition[2]);
  kinectOpenNI.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_FOOT, bodyPosition[3]);
  kinectOpenNI.convertRealWorldToProjective(bodyPosition[3], bodyPosition[3]);
  kinectOpenNI.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, bodyPosition[4]);
  kinectOpenNI.convertRealWorldToProjective(bodyPosition[4], bodyPosition[4]);
  kinectOpenNI.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, bodyPosition[5]);
  kinectOpenNI.convertRealWorldToProjective(bodyPosition[5], bodyPosition[5]);
  kinectOpenNI.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_KNEE, bodyPosition[6]);
  kinectOpenNI.convertRealWorldToProjective(bodyPosition[6], bodyPosition[6]);
  kinectOpenNI.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, bodyPosition[7]);
  kinectOpenNI.convertRealWorldToProjective(bodyPosition[7], bodyPosition[7]);
  kinectOpenNI.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_HEAD, bodyPosition[8]);
  kinectOpenNI.convertRealWorldToProjective(bodyPosition[8], bodyPosition[8]);

  kinectOpenNI.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_NECK, bodyPosition[9]);
  kinectOpenNI.convertRealWorldToProjective(bodyPosition[9], bodyPosition[9]);
  kinectOpenNI.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, bodyPosition[10]);
  kinectOpenNI.convertRealWorldToProjective(bodyPosition[10], bodyPosition[10]);
  kinectOpenNI.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, bodyPosition[11]);
  kinectOpenNI.convertRealWorldToProjective(bodyPosition[11], bodyPosition[11]);
  kinectOpenNI.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_TORSO, bodyPosition[12]);
  kinectOpenNI.convertRealWorldToProjective(bodyPosition[12], bodyPosition[12]);
  kinectOpenNI.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HIP, bodyPosition[13]);
  kinectOpenNI.convertRealWorldToProjective(bodyPosition[13], bodyPosition[13]);
  kinectOpenNI.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HIP, bodyPosition[14]);
  kinectOpenNI.convertRealWorldToProjective(bodyPosition[14], bodyPosition[14]);
}

void convertPosition() {
  for (int i = 0; i < bodyPosition.length; i++) {
    bodyPosition[i].x = bodyPosition[i].x * displayWidth / kinectOpenNI.depthWidth();
    bodyPosition[i].y = bodyPosition[i].y * displayHeight / kinectOpenNI.depthHeight();
  }
}

