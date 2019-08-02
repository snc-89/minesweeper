class Square {
  int xPos;
  int yPos;
  int len;
  int wid;
  color red = color(255, 0, 0);
  color white = color(255);
  int adjMineCount;
  boolean isMine = false;
  boolean setFlag = false;
  boolean revealed = false;
  boolean visited = false;
  LinkedList<Square> adjZeroList;
  LinkedList<Square> allAdjCells;

  Square(int x, int y, int w, int l, int amc, int random) {
    this.xPos = x;
    this.yPos = y;
    this.len = l;
    this.wid = w;
    fill(white);
    if (random == 0) {
      this.isMine = true;
    }
    if (random == 20) {
      this.isMine = true;
      fill(0, 0, 170);
    }
    if (random == 10) {
      fill(200);
    }
    rect(x, y, w, l);
    adjMineCount = amc;
  }

  float distance() {
    return dist(mouseX, mouseY, xPos+(wid/2), yPos+(len/2));
  }
}