void drawScene(String title) {
  // level bg
  imageMode(CORNER);
  image(levelBG, 0, 0, width, height);
  
  // title
  textFont(font, 60);
  textAlign(LEFT);
  text(title, 50, 80);
}

void redrawScene(String title) {
  // level bg
  imageMode(CORNER);
  image(levelBG, 0, 0, width, height);
  
  // title
  textFont(font, 60);
  textAlign(LEFT);
  text(title, 50, 80);
}
