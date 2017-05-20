void drawScene(String title) {
  // level bg
  imageMode(CORNER);
  image(levelBG, 0, 0, width, height);
  
  // title
  textFont(font, 60);
  textAlign(LEFT);
  text(title, 50, 80);
  
  // instruction
  textFont(font, 60);
  textAlign(CENTER);
  text("swap your body parts", width/2, 80);
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
