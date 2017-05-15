
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
// int of each user being  tracked
int[] userID;
// user colors
color[] userColor = new color[] {
  color(255, 0, 0), color(0, 255, 0), color(0, 0, 255), 
  color(255, 255, 0), color(255, 0, 255), color(0, 255, 255)
};
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
// head image mask
PImage maskImage;
PVector[] bodyPosition = new PVector[15];
PImage[] imageBody = new PImage[7];
int[] imageOrder = new int[7];
boolean[] locked = new boolean[7];
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
  0, 2, 4, 5, 7, 7
};
int[] levelDuration = {
  0, 0, 20, 30, 40, 50
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
  
  // set current scene
  setScene();
  
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
        if (currentScene >= 2 && currentScene <= 5) {
          if (!bComplete && !isTimeout) {
            gamePlaying(i);
          } else if (!bComplete && isTimeout) {
            gameOver();
          } else {
            drawButton();
            gameNext();
          }
        } else if (currentScene == 6) {
          if (!bComplete && !isTimeout) {
            gamePlayingLastLevel(i);
          } else if (!bComplete && isTimeout) {
            gameOverLastLevel();
          } else {
            drawButton();
            gameNext();
          }
        } else if (currentScene == 7) {
            gameNext();
        }
      }
    }
  }
}

void saveHeadShot() {
  PImage headShot = get(width/2 - kinectOpenNI.depthHeight()/2, height/2 - kinectOpenNI.depthHeight()/2 - 40, kinectOpenNI.depthHeight(), kinectOpenNI.depthHeight());
  headShot.save("data/head.jpg");
  imageName = splice(imageName, "head.jpg", 4); 
  
  for (int i = 0; i < imageBody.length; i++) {
    imageBody[i] = loadImage(imageName[i]);
    imageOrder[i] = i;
  }
  
  imageBody[4].mask(maskImage);
}

