import java.util.*;

Square[][] cells;
PFont font;
PFont font1;
int rows = 10;
int cols = 10;
boolean gameOver = false;
boolean won;
PImage blobdrool;
PImage dab;
int[] colours = {color(150, 0, 0), color(0, 0, 150), 
  color(0, 150, 0), color(200, 200, 0), 
  color(255, 127, 0), color(100, 150, 200), 
  color(130, 0, 175), color(0)};
int wid = 60;
int len = 60;
int chance = 7;
boolean opening = true;
int timer;
int lastTime;


public void setup() {
  background(200);
  size(600, 660);



  cells = new Square[rows][cols];
  blobdrool = loadImage("blobdrool.png");
  dab = loadImage("dab.png");
  font1 = createFont("Arial Bold", wid/2);
  font = loadFont("FelixTitlingMT-48.vlw");


  for (int i = 0; i < cells.length; i++) {
    for (int j = 0; j < cells.length; j++) { 
      int random = (int) random(chance);
      cells[i][j] = new Square(i*wid, j*len, wid, len, 0, random);
    }
  }


  for (int i = 0; i < cells.length; i++) {
    for (int j = 0; j < cells.length; j++) { 
      if (cells[i][j].isMine) {
        setAdjMineCounts(i, j);
      } else if (cells[i][j].adjMineCount==0) {
        cells[i][j].allAdjCells = getAdjMines(i, j);
      }
    }
  }
}

public void draw() {
      fill(200);
      rect(0, 600, 600, 60);

  if (opening) {
    gameOver = true;
    drawOpening();
  }

  if (!opening && !gameOver) {
    frameRate(60);
    gameWon();

    fill(0);
    textFont(font1);
    textSize(40);
    timer = millis()/1000-lastTime;
    text(timer, 10, 640);
  }

  if (gameOver) {
    fill(0);
    textSize(25);
    text("press p to play again", width/5, 640);
  }
}

public void mousePressed() {
  if (mouseButton == LEFT) {
    for (int i = 0; i < cells.length; i++) {
      for (int j = 0; j < cells.length; j++) { 
        if (cells[i][j].distance() < wid/2 && !cells[i][j].setFlag && !gameOver && !won && !cells[i][j].revealed) {
          if (cells[i][j].isMine) {
            gameOver();
          } else {
            if (cells[i][j].adjMineCount == 0) {
              fillConnectedZeros(cells[i][j]);
            }
            reveal(cells[i][j]);
            cells[i][j].revealed = true;
          }
        }
      }
    }
  }

  if (mouseButton == RIGHT)
    for (int i = 0; i < cells.length; i++) {
      for (int j = 0; j < cells.length; j++) { 
        if (cells[i][j].distance() < wid/2 && !cells[i][j].revealed && !gameOver && !won) {
          if (!cells[i][j].setFlag) {
            drawFlag(i, j);
          } else {
            if (!cells[i][j].isMine) {
              cells[i][j] = new Square(i*wid, j*len, wid, len, cells[i][j].adjMineCount, 2);
            } else {
              cells[i][j] = new Square(i*wid, j*len, wid, len, 0, 0);
            }
          }
        }
      }
    }
}

public void gameOver() {
  for (int i = 0; i < cells.length; i++) {
    for (int j = 0; j < cells.length; j++) { 
      if (cells[i][j].isMine) {
        cells[i][j] = new Square(i*wid, j*len, wid, len, 0, 20);
        cells[i][j].revealed = true;
      }
    }
  }
  gameOver = true;
  image(blobdrool, width/3, height/3);
}

public void keyPressed() {
  opening = false;

  if (key == 'p') {
    setup();
    gameOver = false;
    lastTime = millis()/1000;
  }

  if (key == '1') {
    cols = 10;
    rows = 10;
    wid = width/10;
    len = (height-60)/10;
    gameOver = false;
    chance = 7;
    setup();
    lastTime = millis()/1000;
  }

  if (key == '2') {
    cols = 15;
    rows = 15;
    wid = width/15;
    len = (height-60)/15;
    gameOver = false;
    chance = 5;
    setup();
    lastTime = millis()/1000;
  }

  if (key == '3') {
    cols = 20;
    rows = 20;
    wid = width/20;
    len = (height-60)/20;
    gameOver = false;
    chance = 4;
    setup();
    lastTime = millis()/1000;
  }
}

public void gameWon() {
  for (int i = 0; i < cells.length; i++) {
    for (int j = 0; j < cells.length; j++) {
      if (!cells[i][j].revealed && !cells[i][j].isMine) {
        won = false;
        return;
      }
    }
  }
  won = true;
  image(dab, width/3, height/3);
  text("press p to play again", width/5, 620);
}

public LinkedList<Square> getAdjMines(int i, int j) {
  LinkedList<Square> list = new LinkedList<Square>();

  int startI = i-1;
  int endI = i+1;
  int startJ = j-1;
  int endJ = j+1;

  if (i == 0) {
    startI = i;
  }
  if (j == 0) {
    startJ = j;
  }
  if (i == cols-1) {
    endI = i;
  }
  if (j == rows-1) {
    endJ = j;
  }

  for (int k = startI; k <= endI; k++) {
    for (int l = startJ; l <= endJ; l++) {
      if (cells[k][l] != cells[i][j] && !cells[k][l].isMine && !cells[k][l].revealed) {
        list.add(cells[k][l]);
      }
    }
  }
  return list;
}

public void reveal(Square cell) {
  if (!cell.isMine) {
    if (cell.adjMineCount != 0) {
      revealedCell(cell);
      printMineCount(cell);
    } else {
      revealedCell(cell);
    }
  }
}

public void printMineCount(Square cell) {
  for (int m = 1; m < 10; m++) {
    if (cell.adjMineCount == m) {
      fill(colours[m-1]);
      textFont(font1);
      int xOffset = wid*2/5;
      int yOffset = len*2/3;
      int xPos = cell.xPos+xOffset;
      int yPos = cell.yPos+yOffset;


      text(cell.adjMineCount, xPos, yPos);
      fill(0);
    }
  }
}

public void revealedCell(Square cell) {
  cell = new Square(cell.xPos, cell.yPos, wid, len, cell.adjMineCount, 10);
  fill(0);
  cell.revealed = true;
}

public void setAdjMineCounts(int i, int j) {
  int startI = i-1;
  int endI = i+1;
  int startJ = j-1;
  int endJ = j+1;

  if (i == 0) {
    startI = i;
  }
  if (j == 0) {
    startJ = j;
  }
  if (i == cols-1) {
    endI = i;
  }
  if (j == rows-1) {
    endJ = j;
  }

  for (int k = startI; k <= endI; k++) {
    for (int l = startJ; l <= endJ; l++) {
      if (cells[k][l] != cells[i][j]) {
        cells[k][l].adjMineCount++;
      }
    }
  }
}

public void fillConnectedZeros(Square cell) {
  for (Square item : cell.allAdjCells) {
    reveal(item);
    item.revealed = true;
  }
  cell.visited = true;

  Iterator<Square> loop = cell.allAdjCells.iterator();
  while (loop.hasNext()) {
    Square nextCell = loop.next();
    if (!nextCell.visited && nextCell.adjMineCount == 0) {
      fillConnectedZeros(nextCell);
    }
  }
}

public void drawFlag(int i, int j) {
  strokeWeight(wid/2);
  stroke(0, 200, 0);
  point(i*wid+wid/2, j*len+len/2);
  strokeWeight(1);
  stroke(0);
  cells[i][j].setFlag = !cells[i][j].setFlag;
}

void drawOpening() {
  int x = 20;
  int y = 20;

  for (int i = 0; i < x; i++) {
    frameRate(5);
    for (int j = 0; j < y; j++) {
      float red = random(150);
      float green = 200;
      float blue = random(150);
      fill(red, green, blue);
      rect(i*width/20, j*width/20, width/20, width/20);
    }
  }
  textFont(font);
  textSize(50);
  fill(255, 218, 185);
  rect(width/10, width*1/3, width*4/5, width*1/2, 20);
  fill(0);
  text("press 1 for easy \n  2 for medium \n    3 for hard", width/6, height*1/2);
  fill(255);
  text("Minesweeper", width*2.15/10, height/4);
  fill(0);
}