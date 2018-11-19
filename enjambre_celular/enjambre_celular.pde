public class Player {
  public Player(int x, int y) {
    this.x = x;
    this.y = y;
  }

  int x;
  int y;
}

int anterior_mouse_x = 0;
int anterior_mouse_y = 0;

class CellPos {
  int x, y;

  CellPos(int x, int y) {
    this.x = x;
    this.y = y;
  }
}

int MAZE_X, MAZE_Y;
float CELLSIZE;
float WALLSIZE;

int s = 18;

CellPos currcell;
ArrayList<CellPos> cellstack;
boolean[][] horwalls;
boolean[][] verwalls;
boolean[][] visited;
boolean whiledraw;

boolean create =false;

PGraphics pg;


Player player;

int first_x = 0;
int first_y = 0;

//mascara
PImage imgMask;
PImage img;

int last_x = 0;
int last_y = 0;
int gameScreen = 0;
int active_game =  0;

ArrayList<CellPos> unvisited_n(CellPos cp) {
  ArrayList<CellPos> u = new ArrayList<CellPos>();

  u.add(new CellPos(cp.x - 1, cp.y));
  u.add(new CellPos(cp.x, cp.y + 1));
  u.add(new CellPos(cp.x, cp.y - 1));
  u.add(new CellPos(cp.x + 1, cp.y));

  for (int i = u.size() - 1; i >= 0; i--) {
    CellPos c = u.get(i);

    if (visited[c.x][c.y]) {
      u.remove(i);
    }
  }

  return u;
}

void domaze() {
  for (int i = 0; i < MAZE_X; i++) {
    for (int j = 0; j < MAZE_Y; j++) {
      visited[i][j] = false;
      verwalls[i][j] = true;
      horwalls[i][j] = true;
    }
  }

  for (int x = 0; x < MAZE_X; x++) {
    visited[x][0] = true;
    verwalls[x][MAZE_Y] = true;
    visited[x][MAZE_Y - 1] = true;
  }
  for (int y = 0; y < MAZE_Y; y++) {
    visited[0][y] = true;
    visited[MAZE_X - 1][y] = true;
    horwalls[MAZE_X][y] = true;
  }

  whiledraw = true;
}


void setup() {

  img = loadImage("img.png");
  imgMask = loadImage("mask.png");
  img.mask(imgMask);
  imageMode(CENTER);
  size(272, 237);
  // size(1024, 768);
  //130 -390
  CELLSIZE = 130 / (s * 1.0);
  MAZE_X = (int)(130 / CELLSIZE);
  MAZE_Y = (int)(130 / CELLSIZE);
  WALLSIZE = CELLSIZE / 10.0;
  pg = createGraphics(272, 237);
  visited = new boolean[MAZE_X][MAZE_Y];
  cellstack = new ArrayList<CellPos>();
  verwalls = new boolean[MAZE_X][MAZE_Y + 1];
  horwalls = new boolean[MAZE_X + 1][MAZE_Y];
  currcell = new CellPos(1, 1);
  cellstack.add(currcell);
}

void draw() {
  background(0);
  stroke(255);
  fill(255);

  if (gameScreen == 0) {
    initScreen();
  } else if (gameScreen == 1) {
    if (active_game == 0) {
      fill(0, 255, 0);
      text("GAME 1", 137, 68);
      fill(255);
      gameScreen();

      //gameScreenPgraphics();
      //laberinto normal, funciones de caminar normal
    } else if (active_game == 1) {
      fill(0, 255, 0);
      text("GAME 2", 137, 68);
      fill(255);
      gameScreen();
      //laberinto palabras, funciones de caminar dubujando palabras
    } else if (active_game == 2) {


      fill(0, 255, 0);
      text("GAME 3", 137, 68);
      fill(255);

      gameScreen();

      //laberinto giro, funciones de girar el laberinto
    } else if (active_game == 3) {

      gameScreen();
      if (create==true) {
        image(imgMask, mouseX, mouseY);
      }
      fill(0, 255, 0);
      text("GAME 4", 137, 68);
      fill(255);
      //laberinto mascara, funciones ver en mascara
    }
  } else if (gameScreen == 2) {
    gameOverScreen();
  } else if (gameScreen == 3) {
    winnerScreen();
  }


  if (create==true&&gameScreen>0) {
    /*   println(horwalls[player.x][player.y-1],horwalls[player.x][player.y],horwalls[player.x][player.y+1]);
     if (keyCode == UP&&!horwalls[player.x][player.y]) {
     
     player.y -=1;
     } else if (keyCode == DOWN&&!horwalls[player.x][player.y+1] ) {
     player.y +=1;
     } else if (keyCode == LEFT&&!verwalls[player.x][player.y] ) {
     player.x -=1;
     } else if (keyCode == RIGHT &&!verwalls[player.x+1][player.y] ) {
     player.x +=1;
     }*/

  //println(mouseX-70,player.x * CELLSIZE, mouseY-67, player.y * CELLSIZE);
    
    //primero ver si el cursor esta encima del player, tener en cuenta el translate
    if (mouseX-70>=(player.x* CELLSIZE)-CELLSIZE&&mouseX-70<=(player.x*CELLSIZE) +CELLSIZE ){
      if (mouseY-67>=(player.y*CELLSIZE)-CELLSIZE&&mouseY-67<=(player.y*CELLSIZE)+CELLSIZE){
         println("esta encima del player");
         if(mouseY<anterior_mouse_y&&!horwalls[player.x][player.y]){
           player.y -=1;
         }else if(mouseY>anterior_mouse_y&&!horwalls[player.x][player.y+1]){
            player.y +=1;
         }
         
         if(mouseX<anterior_mouse_x&&!verwalls[player.x][player.y]){
           player.x -=1;
         }else if(mouseX>anterior_mouse_x&&!verwalls[player.x+1][player.y]){
            player.x +=1;
         }
      }
    }
    }
  anterior_mouse_x = mouseX;
  anterior_mouse_y = mouseY;
  
    //dibujar fachada
    stroke(255, 0, 0);
  drawFacadeContourInside();
  stroke(255);
}


//GAME SCREENS 
void initScreen() {
  background(0);
  textAlign(CENTER);
  text("Click to start", height/2, width/2);
}
void gameScreen() {

  pushMatrix();
  translate(70, 67);
  if (whiledraw & cellstack.size() > 0) {
    ArrayList<CellPos> neighbours = unvisited_n(currcell);

    if (neighbours.size() > 0) {
      cellstack.add(0, currcell);
      currcell = neighbours.get((int)random(neighbours.size()));
      //situar cuadrado rojo
      if (first_x==0) {
        first_x = currcell.x;
        first_y = currcell.y;
      }

      visited[currcell.x][currcell.y] = true;

      CellPos old = cellstack.get(0);

      if (old.x == currcell.x) {
        if (old.y > currcell.y) {
          horwalls[old.x][old.y] = false;
        } else {
          horwalls[currcell.x][currcell.y] = false;
        }
      } else {
        if (old.x > currcell.x) {
          verwalls[old.x][old.y] = false;
        } else {
          verwalls[currcell.x][currcell.y] = false;
        }
      }
    } else {
      currcell = cellstack.get(0);
      cellstack.remove(0);
    }
  } else {


    whiledraw = false;


    //situar cuadrado rojo
    if (create==false) {

      player = new Player(first_x, first_y);
      create =  true;
      scale(1, -1);
    }
  }
  if (create==true) {
   stroke(255,0,0);
    fill(255, 0, 0);
    rect(player.x * CELLSIZE, player.y * CELLSIZE, CELLSIZE, CELLSIZE);
    fill(0, 255, 0);
    stroke(0, 255, 0);
    rect((MAZE_X * CELLSIZE)-CELLSIZE*2, (MAZE_Y * CELLSIZE)-CELLSIZE*2, CELLSIZE, CELLSIZE);
    stroke(255);
    fill(255);
  }
  //situar cuadrado rojo (fin)
  //translate(-CELLSIZE * 2, -CELLSIZE * 2);

  for (int i = 1; i < MAZE_X; i++) {
    for (int j = 1; j < MAZE_Y; j++) {
      if (verwalls[i][j]) {
        rect(i * CELLSIZE, j * CELLSIZE, WALLSIZE, CELLSIZE);
      }
      if (horwalls[i][j]) {
        rect(i * CELLSIZE, j * CELLSIZE, CELLSIZE, WALLSIZE);
      }
    }
  }
  //este debería estar cerrando peor hace cosa rara
  for (int x = 0; x < MAZE_X; x++) {
    if (verwalls[x][MAZE_Y]) {
      // rect(x * CELLSIZE, MAZE_Y * CELLSIZE, WALLSIZE, CELLSIZE);
    }
  }
  for (int y = 0; y < MAZE_Y; y++) {
    if (horwalls[MAZE_X][y]) {
      //rect(MAZE_X * CELLSIZE, y * CELLSIZE, CELLSIZE, WALLSIZE);
    }
  }

  popMatrix();
}


void gameScreenPgraphics() {


  pg.beginDraw();
  pg.pushMatrix();
  pg.translate(70, 67);
  if (whiledraw & cellstack.size() > 0) {
    ArrayList<CellPos> neighbours = unvisited_n(currcell);

    if (neighbours.size() > 0) {
      cellstack.add(0, currcell);
      currcell = neighbours.get((int)random(neighbours.size()));
      //situar cuadrado rojo
      if (first_x==0) {
        first_x = currcell.x;
        first_y = currcell.y;
      }

      visited[currcell.x][currcell.y] = true;

      CellPos old = cellstack.get(0);

      if (old.x == currcell.x) {
        if (old.y > currcell.y) {
          horwalls[old.x][old.y] = false;
        } else {
          horwalls[currcell.x][currcell.y] = false;
        }
      } else {
        if (old.x > currcell.x) {
          verwalls[old.x][old.y] = false;
        } else {
          verwalls[currcell.x][currcell.y] = false;
        }
      }
    } else {
      currcell = cellstack.get(0);
      cellstack.remove(0);
    }
  } else {


    whiledraw = false;


    //situar cuadrado rojo
    if (create==false) {

      player = new Player(first_x, first_y);
      create =  true;
      scale(1, -1);
    }
  }
  if (create==true) {
    pg.stroke(255, 0, 0);
    pg.fill(255, 0, 0);
    pg.rect(player.x * CELLSIZE, player.y * CELLSIZE, CELLSIZE, CELLSIZE);
    pg.fill(0, 255, 0);
    pg.rect((MAZE_X * CELLSIZE)-CELLSIZE*2, (MAZE_Y * CELLSIZE)-CELLSIZE*2, CELLSIZE, CELLSIZE);
    pg.stroke(255);
    pg.fill(255);
  }
  //situar cuadrado rojo (fin)
  //translate(-CELLSIZE * 2, -CELLSIZE * 2);

  for (int i = 1; i < MAZE_X; i++) {
    for (int j = 1; j < MAZE_Y; j++) {
      if (verwalls[i][j]) {
        pg.rect(i * CELLSIZE, j * CELLSIZE, WALLSIZE, CELLSIZE);
      }
      if (horwalls[i][j]) {
        pg.rect(i * CELLSIZE, j * CELLSIZE, CELLSIZE, WALLSIZE);
      }
    }
  }
  //este debería estar cerrando peor hace cosa rara
  for (int x = 0; x < MAZE_X; x++) {
    if (verwalls[x][MAZE_Y]) {
      //  pg.rect(x * CELLSIZE, MAZE_Y * CELLSIZE, WALLSIZE, CELLSIZE);
    }
  }
  for (int y = 0; y < MAZE_Y; y++) {
    if (horwalls[MAZE_X][y]) {
      // pg.rect(MAZE_X * CELLSIZE, y * CELLSIZE, CELLSIZE, WALLSIZE);
    }
  }
  pg.popMatrix();
  pg.endDraw();
  image(pg, width/2, height/2); 

  //popMatrix();
}
void gameOverScreen() {
  // codes for game over screen
  background(0);
  textAlign(CENTER);
  text("Game over", height/2, width/2);
}

void winnerScreen() {
  // codes for winner screen
  background(0);
  textAlign(CENTER);
  text("You win", height/2, width/2);
}


public void mousePressed() {
  // if we are on the initial screen when clicked, start the game
  if (gameScreen==0) {
    gameScreen= 1;
    active_game = 0;
    domaze();
  }
}



void keyPressed() {
  //s++;
  if (keyCode == 'R') {
    /* s = 15;
     println(s - 2);
     setup();*/

    if (gameScreen==3) {
      gameScreen= 0;
    }
  }
  println(keyCode);
  if (keyCode == 80) {
    if (active_game==0) {
      active_game = 1;
      create = false;
      domaze();
    } else if (active_game==1) {
      active_game = 2;
      create = false;
      domaze();
    } else if (active_game==2) {
      active_game = 3;
      create = false;
      domaze();
    } else {
      gameScreen= 3;
      active_game = 0;
      create = false;
      domaze();
    }
  }
}

void keyReleased() {

  if (create==true) {
    println(horwalls[player.x][player.y-1], horwalls[player.x][player.y], horwalls[player.x][player.y+1]);
    if (keyCode == UP&&!horwalls[player.x][player.y]) {

      player.y -=1;
    } else if (keyCode == DOWN&&!horwalls[player.x][player.y+1] ) {
      player.y +=1;
    } else if (keyCode == LEFT&&!verwalls[player.x][player.y] ) {
      player.x -=1;
    } else if (keyCode == RIGHT &&!verwalls[player.x+1][player.y] ) {
      player.x +=1;
    }
  }
}


void drawFacadeContourInside()
{

  //left line
  line(40, 72, 40, 196);

  //bottom
  line(40, 196, 231, 196);

  //right side
  line(231, 72, 231, 196);

  // steps
  //flat left
  line(40, 72, 76, 72);

  //vert
  line(76, 72, 76, 56);

  // horm
  line(76, 56, 112, 56);

  //vert
  line(112, 56, 112, 40);

  //top
  line(112, 40, 159, 40);

  //vert right side
  line(159, 40, 159, 56);

  //hors
  line(160, 56, 195, 56);

  //  vert
  line(195, 56, 195, 72);

  //hor
  line(196, 72, 231, 72);
}