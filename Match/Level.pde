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
