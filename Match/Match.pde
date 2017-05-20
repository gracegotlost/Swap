
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
  "head.png", "rightelbow.png", "leftelbow.png"
};
PVector[] bodyPosition = new PVector[15];
PImage[] imageBody = new PImage[7];
int[] imageOrder = new int[7];
boolean[] locked = new boolean[7];
AudioPlayer player;
AudioPlayer bgMusic;
Minim minim;

/*---------------------------------------------------------------
 Game Control
 ----------------------------------------------------------------*/
int currentLevel = 1;
int currentScene = 1;
int btnWidth = 240;
int btnHeight = 88;
int btnRight = 600;
int btnBottom = 500;
int partSize = 120;
int countShow = 0;
int countHide = 0;
float headX = 0;
float headY = 0;
float elbowX = 0;
float elbowY = 0;
int[] bodyPart = {
  0, 4, 5, 7, 7
};
// for game
boolean foundHead = true;
boolean foundElbow = true;
// for testing
//boolean foundHead = false;
//boolean foundElbow = false;
boolean showHead = false;
boolean showElbow = false;
boolean countStarted = false;
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
//  size(1920, 1040);
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
  bgMusic = minim.loadFile("theme.mp3", 2048);
  bgMusic.loop();

  // font init
  font = loadFont("DKDirrrty-72.vlw");
  
  // image init
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
  
  if (userID.length == 0) {
    drawInstruction("stand at the blue line");
  }
  
  // loop through each user to see if tracking
  for (int i = 0; i < userID.length; i++) {
    // if Kinect is tracking certain user then get joint vectors
    if (kinectOpenNI.isTrackingSkeleton(userID[i])) {
      // get confidence level that Kinect is tracking head
      confidence = kinectOpenNI.getJointPositionSkeleton(userID[i], SimpleOpenNI.SKEL_HEAD, confidenceVector);
      // if confidence of tracking is beyond threshold, then track user
      if (confidence > confidenceLevel) {
        getPosition(userID[i]);
        convertPosition();
        // check if its center user
        if (bodyPosition[4].x <= width*0.3 || bodyPosition[4].x >= width*0.7) {
          drawInstruction("stand in the middle");
          continue;
        }
        if (currentScene >= 1 && currentScene <= 3) {
          gamePlaying(i);
        } else if (currentScene == 4) {
          gamePlayingLastLevel(i);
        }
      } else {
          drawInstruction("tracking you..");
      }
      break;
    }
  }
}

