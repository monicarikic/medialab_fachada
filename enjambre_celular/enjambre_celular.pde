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

int s = 6;//18;

boolean create =false;

PGraphics pg;


Player player;
Maze maze = new Maze();
int first_x = 0;
int first_y = 0;

//mascara
PImage imgMask;
PImage img;

int last_x = 0;
int last_y = 0;
int gameScreen = 0;
int active_game =  0;
CellPos currcell;


void setup() {
  img = loadImage("img.png");
  imgMask = loadImage("mask.png");
  img.mask(imgMask);
  imageMode(CENTER);
  size(272, 237);
  maze.setup();
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


    //primero ver si el cursor esta encima del player, tener en cuenta el translate y añadir margen para k sea mas faicl
    if (mouseX-70>=(player.x* CELLSIZE)-CELLSIZE&&mouseX-70<=(player.x*CELLSIZE) +CELLSIZE ){
      if (mouseY-67>=(player.y*CELLSIZE)-CELLSIZE&&mouseY-67<=(player.y*CELLSIZE)+CELLSIZE){
         println("esta encima del player");
         if(mouseY<anterior_mouse_y&& !maze.getHorWall(player.x,player.y)){
           player.y -=1;
         }else if(mouseY>anterior_mouse_y&& !maze.getHorWall(player.x,player.y+1)){
            player.y +=1;
         }

         if(mouseX<anterior_mouse_x&& !maze.getVerWall(player.x,player.y)){
           player.x -=1;
         }else if(mouseX>anterior_mouse_x& !maze.getVerWall(player.x+1,player.y)){
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

  maze.draw();

  //situar cuadrado rojo
  if (create==false) {
    player = new Player(first_x, first_y);
    create =  true;
    scale(1, -1);
  }

    //situar cuadrado rojo (fin)
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



  for (int i = 1; i < MAZE_X; i++) {
    for (int j = 1; j < MAZE_Y; j++) {
      if (maze.getVerWall(i,j)) {
        rect(i * CELLSIZE, j * CELLSIZE, WALLSIZE, CELLSIZE);
      }
      if (maze.getHorWall(i,j)) {
        rect(i * CELLSIZE, j * CELLSIZE, CELLSIZE, WALLSIZE);
      }
    }
  }
  //este debería estar cerrando peor hace cosa rara
  for (int x = 0; x < MAZE_X; x++) {
    if (maze.getVerWall(x,MAZE_Y)) {
      // rect(x * CELLSIZE, MAZE_Y * CELLSIZE, WALLSIZE, CELLSIZE);
    }
  }
  for (int y = 0; y < MAZE_Y; y++) {
    if (maze.getHorWall(MAZE_X,y)) {
      //rect(MAZE_X * CELLSIZE, y * CELLSIZE, CELLSIZE, WALLSIZE);
    }
  }

  popMatrix();
}


void gameScreenPgraphics() {


  pg.beginDraw();
  pg.pushMatrix();
  pg.translate(70, 67);

  maze.draw();
  //situar cuadrado rojo
  if (create==false) {
    player = new Player(first_x, first_y);
    create =  true;
    scale(1, -1);
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
      if (maze.getVerWall(i,j)) {
        pg.rect(i * CELLSIZE, j * CELLSIZE, WALLSIZE, CELLSIZE);
      }
      if (maze.getHorWall(i,j)) {
        pg.rect(i * CELLSIZE, j * CELLSIZE, CELLSIZE, WALLSIZE);
      }
    }
  }
  //este debería estar cerrando peor hace cosa rara
  for (int x = 0; x < MAZE_X; x++) {
    if (maze.getVerWall(x,MAZE_Y)) {
      //  pg.rect(x * CELLSIZE, MAZE_Y * CELLSIZE, WALLSIZE, CELLSIZE);
    }
  }
  for (int y = 0; y < MAZE_Y; y++) {
    if (maze.getHorWall(MAZE_X,y)) {
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
    maze.setup();
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
      maze.setup();
       currcell = new CellPos(1, 1);
      maze.addCell(currcell);
    } else if (active_game==1) {

      active_game = 2;
      create = false;
      maze.setup();

    } else if (active_game==2) {
      active_game = 3;
      create = false;
      maze.setup();
       currcell = new CellPos(1, 1);
       maze.addCell(currcell);
    } else {
      gameScreen= 3;
      active_game = 0;
      create = false;
      maze.setup();
       currcell = new CellPos(1, 1);
       maze.addCell(currcell);
    }
  }
}

void keyReleased() {

  if (create==true) {

    if (keyCode == UP&&!maze.getHorWall(player.x,player.y)) {

      player.y -=1;
    } else if (keyCode == DOWN&&!maze.getHorWall(player.x,player.y+1) ) {
      player.y +=1;
    } else if (keyCode == LEFT&&!maze.getVerWall(player.x,player.y) ) {
      player.x -=1;
    } else if (keyCode == RIGHT &&!maze.getVerWall(player.x+1,player.y) ) {
      player.x +=1;
    }
    else if(keyCode == 50){
      maze.flip();
    }
    else if(keyCode == 50){
      maze.flip();
    }
  }
}
