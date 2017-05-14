
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

// position of head
PImage headImage;
PImage maskImage;
float headSize = 120;

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
  "righthand.png", "lefthand.png", "rightfoot.png", "leftfoot.png", 
  "rightelbow.png", "leftelbow.png"
};
PVector[] bodyPosition = new PVector[15];
PImage[] imageBody = new PImage[6];
int[] imageOrder = new int[6];
boolean[] locked = new boolean[6];
AudioPlayer player;
Minim minim;

/*---------------------------------------------------------------
 Game Control
 ----------------------------------------------------------------*/
int currentLevel = 1;
int currentScene = 1;
int btnWidth = 240;
int btnHeight = 88;
int partSize = 120;
int[] bodyPart = {
  0, 2, 4, 6
};
int[] levelDuration = {
  0, 0, 20, 30
};
int startTime = 0;
int startOpacity = 0;
float currentOpacity = 0;
boolean hasStarted = false;
boolean isTimeout = false;
boolean isPlayingAnim = false;
boolean bComplete = false;
boolean bContinue = false;
PFont font;
PImage levelBG;
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

  // level init
  setLevel();

  // sound init
  minim = new Minim(this);
  player = minim.loadFile("ka.mp3", 2048);

  // font init
  font = loadFont("DKDirrrty-72.vlw");
  
  // image init
  maskImage = loadImage("mask.png");
  levelBG = loadImage("level_bg.png");
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
    drawSecondScene();
    break;
  case 3:
    drawScene("Level 1");
    break;
  case 4:
    drawScene("Level 2");
    break;
  case 5:
    drawLose();
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
        convertPosition();
        if (currentScene == 2 || currentScene == 3 || currentScene == 4) {
          if (!bComplete && !isTimeout) {
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
          } else if (!bComplete && isTimeout) {
            isTimeout = false;
            isPlayingAnim = true;
            currentOpacity = 0;
            startOpacity = millis();
            currentScene = 5;
          } else {
            drawButton();
            imageMode(CENTER);
            image(imageBody[0], bodyPosition[0].x, bodyPosition[0].y, partSize, partSize);
          }
        } else if (currentScene == 5) {
          imageMode(CENTER);
          image(imageBody[0], bodyPosition[0].x, bodyPosition[0].y, partSize, partSize);
        }
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

void saveHeadShot() {
  PImage headShot = get(width/2 - kinectOpenNI.depthHeight()/2, height/2 - kinectOpenNI.depthHeight()/2 - 40, kinectOpenNI.depthHeight(), kinectOpenNI.depthHeight());
  headShot.save("data/head.jpg");
}

