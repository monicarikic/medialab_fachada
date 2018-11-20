//fondo
import processing.video.*;
Movie fondo_video;
Movie win_video;
Movie video_colores;


//texto
import java.util.Calendar;

float x = 0, y = 0;
float stepSize = 5.0;

boolean escribe = false;

PFont font;
String letters = "Sie hören nicht die folgenden Gesänge, Die Seelen, denen ich die ersten sang, Zerstoben ist das freundliche Gedränge, Verklungen ach! der erste Wiederklang.";
int fontSizeMin = 7;
float angleDistortion = 0.0;

int counter = 0;


PGraphics texto;


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

float timer;
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

int s = 18;//18;

boolean create =false;

PGraphics pg;


Player player;
Player goal;
Maze maze = new Maze();
int first_x = 0;
int first_y = 0;

//mascara
PImage imgMask;
PImage img;
PImage mascara_tapar_laberinto;
PImage mascara_video;
PImage nivel_superado;
PImage has_ganado;
PImage llegada;
PImage player_img;

int last_x = 0;
int last_y = 0;
int gameScreen = 0;
int active_game =  0;
CellPos currcell;


void setup() {

  //video
  fondo_video  = new Movie(this, "hex_lluvia.mov");
  fondo_video.loop();
  win_video  = new Movie(this, "hexagonos_negros.mov");
  win_video.loop();
  video_colores  = new Movie(this, "cambio_forma_colores.mov");
  video_colores.loop();



  //letras
  x = mouseX;
  y = mouseY;
  texto = createGraphics(130, 120);

  font = createFont("American Typewriter", 10);
  //font = createFont("ArnhemFineTT-Normal",10);
  textFont(font, fontSizeMin);
  textAlign(LEFT);


  img = loadImage("img.png");
  imgMask = loadImage("mask.png");
  mascara_tapar_laberinto = loadImage("fondo_tapar.png");
  mascara_video = loadImage("mascara_video_notit.png");
  nivel_superado =  loadImage("superado_trans.png");
  has_ganado =  loadImage("ganado.png");
  llegada = loadImage("llegada.png");
  player_img = loadImage("player.png");

  img.mask(imgMask);
  fondo_video.mask(mascara_video);
  imageMode(CENTER);
  size(272, 237);

  maze.setup();

}

void draw() {
  active_game =1;
  background(0);
  strokeWeight(1);

  stroke(255);
  fill(255, 100);

  if (gameScreen == 0) {
    image(fondo_video, 100, 100);
    // image(win_video,135,122);
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
      texto.beginDraw();
      texto.background(100,100,100, 150);
      texto.fill(255, 255, 0);

      if (escribe==true) {
        float d = dist(x, y, mouseX, mouseY);
        texto.textFont(font, fontSizeMin);
        char newLetter = letters.charAt(counter);
        stepSize = textWidth(newLetter);

        if (d > stepSize) {
          float angle = atan2(mouseY-y, mouseX-x);

          texto.pushMatrix();
          texto.translate(mouseY-60, mouseX-70);
          texto.rotate(angle + random(angleDistortion));
          texto.text(newLetter, 0, 0);
          texto.popMatrix();

          counter++;
          if (counter > letters.length()-1) counter = 0;

          x = x + cos(angle) * stepSize;
          y = y + sin(angle) * stepSize;
        }
      }
      texto.endDraw();
      //pushMatrix();
     // translate(130, 100);
      image(texto, width/2, height/2);
      //popMatrix();
    } else if (active_game == 2) {


      fill(0, 255, 0);
      text("GAME 3", 137, 68);
      fill(255);

      gameScreen();

      //laberinto giro, funciones de girar el laberinto
    } else if (active_game == 3) {

      gameScreen();

      fill(0, 255, 0);
      text("GAME 4", 137, 68);
      fill(255);
      //laberinto mascara, funciones ver en mascara
    }

    //tapar errores laberinto


      //cambiar de pantalla
      if(create==true){

      if(player.x==goal.x && player.y==goal.y){
        println("ha llegado");
        gameScreen = 4;
      }
      }


  } else if (gameScreen == 2) {
    gameOverScreen();
  } else if (gameScreen == 3) {
    image(video_colores, 135, 122);
    winnerScreen();
  } else if (gameScreen == 4) {
    image(win_video, 135, 122);

    nextScreen();
  }



  if (create==true&&gameScreen>0) {


    //primero ver si el cursor esta encima del player, tener en cuenta el translate y añadir margen para k sea mas faicl

    if (mouseX-70>=(player.x* CELLSIZE)-CELLSIZE&&mouseX-70<=(player.x*CELLSIZE) +CELLSIZE ){
      if (mouseY-67>=(player.y*CELLSIZE)-CELLSIZE&&mouseY-67<=(player.y*CELLSIZE)+CELLSIZE){
         println("esta encima del player");
         if(mouseY<anterior_mouse_y&& !maze.getHorWall(player.x,player.y)){
           player.y -=1;
            escribe =  true;
         }else if(mouseY>anterior_mouse_y&& !maze.getHorWall(player.x,player.y+1)){
            player.y +=1;
             escribe =  true;
         }else{
            escribe =  false;
         }

         if(mouseX<anterior_mouse_x&& !maze.getVerWall(player.x,player.y)){
           player.x -=1;
            escribe =  true;
         }else if(mouseX>anterior_mouse_x& !maze.getVerWall(player.x+1,player.y)){
            player.x +=1;
             escribe =  true;
         }else{
            escribe =  false;
         }

      }
    }
  }
  anterior_mouse_x = mouseX;
  anterior_mouse_y = mouseY;


  //dibujar fachada
  stroke(143, 4, 231);
  strokeWeight(2);

  drawFacadeContourInside();

  noStroke();
  fill(143, 4, 231, 100);
  ellipse(mouseX, mouseY, 10, 10);
  stroke(255);
}


//GAME SCREENS
void initScreen() {

  textAlign(CENTER);
  text("Click to start", height/2, width/2);
}
void gameScreen() {

  pushMatrix();
  translate(71, 69);

  maze.draw();

  //situar cuadrado rojo
  if (create==false) {
    player = new Player(first_x, first_y);
    goal = new Player(MAZE_X-2,MAZE_Y-2);
    create =  true;
    scale(1, -1);
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


  //situar cuadrado rojo (fin)
  if (create==true) {
    stroke(255, 0, 255);
    fill(255, 0, 255);
    ellipse(player.x * CELLSIZE+(CELLSIZE/2), player.y * CELLSIZE+(CELLSIZE/2), CELLSIZE, CELLSIZE);

    image(llegada, (goal.x * CELLSIZE), (goal.y * CELLSIZE), 13, 13);
    stroke(255);
    fill(255);
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

  if (create==true&&active_game==3) {
      image(imgMask, mouseX-68, mouseY-68);
   }


  //image(mascara_tapar_laberinto, 66, 51);

  // image(mascara_video, 66, 71);

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
   popMatrix();
  image(fondo_video, -172, 71);

  image(fondo_video, 300, 71);

}

void gameOverScreen() {
  // codes for game over screen
  background(0);
  textAlign(CENTER);
  text("Game over", height/2, width/2);
}

void winnerScreen() {
  // codes for winner screen
  image(has_ganado, width/2, height/2);
  timer++;
  if (timer > 500) {

    gameScreen = 0;
    active_game=0;

    timer = 0;
  }
}

void nextScreen() {
  // codes for winner screen
  //background(0);
  //textAlign(CENTER);
  //fill(255,0,0);
  //text("Has pasado la pantalla!", height/2, width/2);
  image(nivel_superado, width/2, height/2);
  timer++;

  if (timer > 300) {
    if (active_game<3) {
      create = false;
      maze.setup();
       gameScreen = 1;

      active_game++;
    } else {
      gameScreen = 3;
    }
    timer = 0;
  }
}


public void mousePressed() {
  x = mouseX;
  y = mouseY;
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

      maze.addCell(currcell);

    } else if (active_game==1) {

      active_game = 2;
      create = false;

      maze.setup();

    } else if (active_game==2) {
      active_game = 3;
      create = false;
       maze.setup();


       maze.addCell(currcell);


    } else if (active_game==2) {
      active_game = 3;
      create = false;
      maze.setup();

       maze.addCell(currcell);

    } else {
      gameScreen= 3;
      active_game = 0;
      create = false;
 maze.setup();

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
      println(player.x +" "+player.y);
      println((MAZE_X - (player.x)) +" "+(MAZE_Y - player.y));
      maze.flip();
      //player.x = MAZE_X - player.x;
      player.y = MAZE_Y -1 - player.y;
      goal.y = MAZE_Y -1 - goal.y;
    }
  }
}



void movieEvent(Movie m) {
  m.read();
}

void polygon(float x, float y, float radius, int npoints) {
  float angle = TWO_PI / npoints;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}
