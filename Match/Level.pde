void setLevel() {
  switch(currentLevel) {
    case 1:
      imageOrder[0] = 2;
      imageOrder[1] = 3;
      imageOrder[2] = 1;
      imageOrder[3] = 0;
      break;
    case 2:
      imageOrder[0] = 3;
      imageOrder[1] = 4;
      imageOrder[2] = 1;
      imageOrder[3] = 0;
      imageOrder[4] = 2;
      break;
    case 3:
      imageOrder[0] = 5;
      imageOrder[1] = 3;
      imageOrder[2] = 0;
      imageOrder[3] = 4;
      imageOrder[4] = 2;
      imageOrder[5] = 6;
      imageOrder[6] = 1;
      break;
    case 4:
      imageOrder[0] = -1;
      imageOrder[1] = 6;
      imageOrder[2] = 0;
      imageOrder[3] = -1;
      imageOrder[4] = 3;
      imageOrder[5] = 1;
      imageOrder[6] = 2;
      break;
    default:
      break;
  }
}
