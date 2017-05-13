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
    bodyPosition[i].x = width - map(bodyPosition[i].x, 0, kinectOpenNI.depthWidth(), width*0.1, width*0.9);
    bodyPosition[i].y = map(bodyPosition[i].y, 0, kinectOpenNI.depthHeight(), height*0.1, height*0.9);
  }
}
