void setScene() {
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
      drawScene("Level 3");
      break;
    case 6:
      drawScene("Level 4");
      break;
    case 7:
      drawLose();
      break;
    default:
      break;
  }
}
