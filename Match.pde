/*---------------------------------------------------------------
 Imports
 ----------------------------------------------------------------*/
// import kinect library
import SimpleOpenNI.*;
import ddf.minim.*;

/*---------------------------------------------------------------
 Variables
 ----------------------------------------------------------------*/
// create kinect object
SimpleOpenNI  kinect;
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
PVector[] bodyPosition = new PVector[9]; 
// left hand, right hand, left foot, right foot, 
//left elbow, right elbow, left knee, right knee, head
String[] imageName = {
  "lefthand.png", "righthand.png", "leftfoot.png", "rightfoot.png", 
  "leftelbow.png", "rightelbow.png", "lefthand.png", "lefthand.png", "lefthand.png"
};
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
  kinect = new SimpleOpenNI(this);
  // enable depth sensor 
  kinect.enableDepth();
  // enable skeleton generation for all joints
  kinect.enableUser();

  //skeleton weight
  strokeWeight(3);
  fill(0);
  // size
  size(800, 800);

  // set bodyPosition and image
  for (int i = 0; i < 9; i++) {
    bodyPosition[i] = new PVector();
    imageBody[i] = loadImage(imageName[i]);
    imageOrder[i] = i;
  }
  setLevel();

  //sount init
  minim = new Minim(this);
  player = minim.loadFile("ka.mp3", 2048);
  
  // font init
  font = loadFont("YuppySC-Regular-72.vlw");
} // void setup()

/*---------------------------------------------------------------
 Updates Kinect. Gets users tracking and draws skeleton and
 head if confidence of tracking is above threshold
 ----------------------------------------------------------------*/
void draw() {
  background(255);

  switch(currentScene) {
  case 1:
    drawScene("Match", "Use your right hand to hover over the button to continue", true);
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
  kinect.update();
  // get all user IDs of tracked users
  userID = kinect.getUsers();

  // loop through each user to see if tracking
  for (int i = 0; i < userID.length; i++)
  {
    // if Kinect is tracking certain user then get joint vectors
    if (kinect.isTrackingSkeleton(userID[i]))
    {
      // get confidence level that Kinect is tracking head
      confidence = kinect.getJointPositionSkeleton(userID[i], SimpleOpenNI.SKEL_HEAD, confidenceVector);
      // if confidence of tracking is beyond threshold, then track user
      if (confidence > confidenceLevel)
      {
        getPosition(userID[i]);
        if (currentScene == 4 || currentScene == 5 || currentScene == 6) {
          if (bComplete == false) {
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
              bComplete = true;
            }
          }
          else {
            PImage img = loadImage("instruction3.png");
            imageMode(CORNER);
            //image(img, 700 - bodyPosition[8].x, bodyPosition[8].y);
            image(imageBody[1], 800-map(bodyPosition[0].x, 0, kinect.depthWidth(), 0, 800), map(bodyPosition[0].y, 0, kinect.depthHeight(), 0, 800));
            drawButton();
          }
        }
        else
          image(imageBody[1], 800-map(bodyPosition[0].x, 0, kinect.depthWidth(), 0, 800), map(bodyPosition[0].y, 0, kinect.depthHeight(), 0, 800));
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
  //  imageMode(CORNER);
  //  PImage img = loadImage("body.png");
  //  image(img, 700 - bodyPosition[8].x, bodyPosition[8].y, 200, 500);
  imageMode(CENTER);
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

void drawThirdScene() {
  // title
  textFont(font, 60);
  textAlign(CENTER);
  text("Instruction", width/2, 100);

  PImage img1 = loadImage("instruction1.png");
  PImage img2 = loadImage("instruction2.png");
  PImage img3 = loadImage("instruction3.png");
  image(img1, 50, 150);
  image(img2, 300, 150);
  image(img3, 550, 150);

  textFont(font, 24);
  textAlign(LEFT);
  text("1. Detect your body parts", 50, 500);
  text("2. Touch two body parts to swap", 50, 550);
  text("3. Make all body parts in order to complete this level", 50, 600);

  drawButton();
}

void drawButton() {
  float x = 800-map(bodyPosition[0].x, 0, kinect.depthWidth(), 0, 800);
  float y = map(bodyPosition[0].y, 0, kinect.depthHeight(), 0, 800);
  // continue button
  PImage img = loadImage("button.png");
  double distance = sqrt(pow(x-650, 2) + pow(y-600, 2));
  if (distance < 100) {
    img = loadImage("button2.png");
    bContinue = true;
  }
  else if (bContinue) {
    bContinue = false;
    currentScene++;
    setLevel();
  }
  image(img, 650, 600, 100, 100);
}

/*---------------------------------------------------------------
 Get all positions of main body parts
 ----------------------------------------------------------------*/
void getPosition(int userId) {
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, bodyPosition[0]);
  kinect.convertRealWorldToProjective(bodyPosition[0], bodyPosition[0]);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, bodyPosition[1]);
  kinect.convertRealWorldToProjective(bodyPosition[1], bodyPosition[1]);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_FOOT, bodyPosition[2]);
  kinect.convertRealWorldToProjective(bodyPosition[2], bodyPosition[2]);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_FOOT, bodyPosition[3]);
  kinect.convertRealWorldToProjective(bodyPosition[3], bodyPosition[3]);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, bodyPosition[4]);
  kinect.convertRealWorldToProjective(bodyPosition[4], bodyPosition[4]);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, bodyPosition[5]);
  kinect.convertRealWorldToProjective(bodyPosition[5], bodyPosition[5]);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_KNEE, bodyPosition[6]);
  kinect.convertRealWorldToProjective(bodyPosition[6], bodyPosition[6]);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, bodyPosition[7]);
  kinect.convertRealWorldToProjective(bodyPosition[7], bodyPosition[7]);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_HEAD, bodyPosition[8]);
  kinect.convertRealWorldToProjective(bodyPosition[8], bodyPosition[8]);
}