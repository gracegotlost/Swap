/*---------------------------------------------------------------
 Draw the skeleton of a tracked user. Input is userID
 ----------------------------------------------------------------*/
void drawSkeleton(int userId) { 
  //draw limb from head to neck
  line(bodyPosition[4].x, bodyPosition[4].y, bodyPosition[9].x, bodyPosition[9].y);
//  kinect.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
  //draw limb from neck to left shoulder
  line(bodyPosition[9].x, bodyPosition[9].y, bodyPosition[10].x, bodyPosition[10].y);
//  kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  //draw limb from left shoulder to left elbow
  line(bodyPosition[10].x, bodyPosition[10].y, bodyPosition[5].x, bodyPosition[5].y);
//  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  //draw limb from left elbow to left hand
  line(bodyPosition[5].x, bodyPosition[5].y, bodyPosition[0].x, bodyPosition[0].y);
//  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
  //draw limb from neck to right shoulder
  line(bodyPosition[9].x, bodyPosition[9].y, bodyPosition[11].x, bodyPosition[11].y);
//  kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  //draw limb from right shoulder to right elbow
  line(bodyPosition[11].x, bodyPosition[11].y, bodyPosition[6].x, bodyPosition[6].y);
//  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  //draw limb from right elbow to right hand
  line(bodyPosition[6].x, bodyPosition[6].y, bodyPosition[1].x, bodyPosition[1].y);
//  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
  //draw limb from left shoulder to torso
  line(bodyPosition[10].x, bodyPosition[10].y, bodyPosition[12].x, bodyPosition[12].y);
//  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  //draw limb from right shoulder to torso
  line(bodyPosition[11].x, bodyPosition[11].y, bodyPosition[12].x, bodyPosition[12].y);
//  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  //draw limb from torso to left hip
  line(bodyPosition[12].x, bodyPosition[12].y, bodyPosition[13].x, bodyPosition[13].y);
//  kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  //draw limb from left hip to left knee
  line(bodyPosition[13].x, bodyPosition[13].y, bodyPosition[7].x, bodyPosition[7].y);
//  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  //draw limb from left knee to left foot
  line(bodyPosition[7].x, bodyPosition[7].y, bodyPosition[2].x, bodyPosition[2].y);
//  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);
  //draw limb from torse to right hip
  line(bodyPosition[12].x, bodyPosition[12].y, bodyPosition[14].x, bodyPosition[14].y);
//  kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  //draw limb from right hip to right knee
  line(bodyPosition[14].x, bodyPosition[14].y, bodyPosition[8].x, bodyPosition[8].y);
//  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  //draw limb from right kneee to right foot
  line(bodyPosition[8].x, bodyPosition[8].y, bodyPosition[3].x, bodyPosition[3].y);
//  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
} // void drawSkeleton(int userId)

/*---------------------------------------------------------------
 When a new user is found, print new user detected along with
 userID and start pose detection.  Input is userID
 ----------------------------------------------------------------*/
void onNewUser(SimpleOpenNI curContext, int userId) {
  println("New User Detected - userId: " + userId);
  // start tracking of user id
  curContext.startTrackingSkeleton(userId);
} //void onNewUser(SimpleOpenNI curContext, int userId)

/*---------------------------------------------------------------
 Print when user is lost. Input is int userId of user lost
 ----------------------------------------------------------------*/
void onLostUser(SimpleOpenNI curContext, int userId) {
  // print user lost and user id
  println("User Lost - userId: " + userId);
} //void onLostUser(SimpleOpenNI curContext, int userId)

/*---------------------------------------------------------------
 Called when a user is tracked.
 ----------------------------------------------------------------*/
void onVisibleUser(SimpleOpenNI curContext, int userId) {
} //void onVisibleUser(SimpleOpenNI curContext, int userId)
