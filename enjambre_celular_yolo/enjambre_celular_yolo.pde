//YOLO
import lord_of_galaxy.timing_utils.*;

import processing.awt.PSurfaceAWT;

int NUM_LEVELS = 3;
int FLIP_TIME = 10;

PFont f;
import java.util.concurrent.CopyOnWriteArrayList;
int widthDesiredScale = 192;
int heightDesiredScale = 157;
float scaleRawSize = 0.5;
Boolean bDrawInfo = false;

Boolean bBackgroundAlpha = false;
int alphaBk = 200;


//fondo
import processing.video.*;
Movie fondo_video;
Movie fondo_video_abeja;
Movie win_video;
Movie video_colores;


//texto
import java.util.Calendar;

float x = 0, y = 0;
float stepSize = 5.0;

boolean escribe = false;

PFont font;
PFont font_2;

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

PGraphics pg;

boolean testing=true;

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
PImage puntero;
PImage player_img;

int last_x = 0;
int last_y = 0;
int gameScreen = 0;
int active_game =  0;

CellPos currcell;
Stopwatch flipTimer;


void setup() {

  //YOLO
/*  PSurfaceAWT awtSurface = (PSurfaceAWT)surface;
  PSurfaceAWT.SmoothCanvas smoothCanvas = (PSurfaceAWT.SmoothCanvas)awtSurface.getNative();
  smoothCanvas.getFrame().setAlwaysOnTop(true);
  smoothCanvas.getFrame().removeNotify();
  smoothCanvas.getFrame().setUndecorated(true);
  smoothCanvas.getFrame().setLocation(0, 0);//2560
  smoothCanvas.getFrame().addNotify();*/
  setup_clientSensor4Games();

  //video
  fondo_video  = new Movie(this, "hex_lluvia.mp4");
  fondo_video.loop();
  win_video  = new Movie(this, "hexagonos_negros.mp4");
  win_video.loop();
  video_colores  = new Movie(this, "cambio_forma_colores.mp4");
  video_colores.loop();

  fondo_video_abeja  = new Movie(this, "lluvia.mp4");
  fondo_video_abeja.loop();

  //letras
  x = mouseX;
  y = mouseY;
  texto = createGraphics(130, 120);

  font = createFont("LemonMilkbold.otf", 10);
  font_2 = createFont("8_bit_party.ttf", 10);


  img = loadImage("img.png");
  imgMask = loadImage("mask.png");
  mascara_tapar_laberinto = loadImage("fondo_tapar.png");
  mascara_video = loadImage("mascara_video_notit.png");
  nivel_superado =  loadImage("superado_trans.png");
  has_ganado =  loadImage("ganado.png");
  puntero = loadImage("punter.png");
  player_img = loadImage("player.png");

  img.mask(imgMask);
  //fondo_video.mask(mascara_video);
  imageMode(CENTER);
  size(272, 237,P2D);

  maze.setup();
  flipTimer = new Stopwatch(this);

}

void draw() {
  active_game = 2;
  background(0);
  strokeWeight(1);

  stroke(255);
  fill(255, 100);

  switch(gameScreen){
    case 0: // Presentacion
      image(fondo_video_abeja, 150, 100);
      fill(255, 215, 0);
      textFont(font, 7);
      textAlign(CENTER);
      text("enjambre\ncelular", width/2, (height/2)-38);
      stroke(255, 215, 0);
      fill(0);
      strokeWeight(3);
      pushMatrix();
      translate(width/2, (height/2)+20);
      rotate(frameCount / -100.0);
      polygon(0, 0, 14, 5);
      popMatrix();
     // ellipse(width/2, (height/2)+20, 30,30);
      fill(0);
       textFont(font, 3);
       noStroke();
       rect(0, (height/2)+65, width, 20);
        fill(255);
       text("Sitúate en el hexagono para empezar a jugar", width/2, (height/2)+73);
      strokeWeight(0.5);

      stroke(255);
      fill(255);
    break;
    case 1: // Juego
      strokeWeight(0.5);
      switch(active_game){
        case 0:
        //laberinto normal, funciones de caminar normal
          fill(0, 255, 0);
          fill(255);
          gameScreen();
        break;
        case 1:
        //laberinto giro, funciones de girar el laberinto
          fill(0, 255, 0);
          fill(255);
          gameScreen();
          if(flipTimer.second() == FLIP_TIME){
            println("Flip!");
            maze.flip();
            player.y = MAZE_Y-1 - player.y;
            goal.y = MAZE_Y-1 - goal.y;
            flipTimer.restart();
          }
        break;
        case 2:
        //laberinto con lupa
          gameScreen();
          fill(0, 255, 0);
          fill(255);
        break;
      }
      if(maze.isCreated()) {
        if(player.x==goal.x && player.y==goal.y) {
          nextScreen();
        }
      }
    break;
    case 2: // Next level
      image(nivel_superado, width/2, height/2);
      timer++;
      if (timer > 300) {
        gameScreen = 1;
        escribe = false;
        println("PASA A JUEGO: ", active_game);
        timer= 0;
        if(active_game == 1){
          flipTimer.start();
        }
        maze.setup();
      }
      break;
    case 3: // Winner screen
      image(video_colores, 135, 122);
      winnerScreen();
    break;
  }

  if (maze.isCreated()&&gameScreen==1) {
    //primero ver si el cursor esta encima del player, tener en cuenta el translate y añadir margen para k sea mas faicl
    if (mouseX-70>=(player.x* CELLSIZE)-CELLSIZE&&mouseX-70<=(player.x*CELLSIZE) +CELLSIZE ) {
      if (mouseY-67>=(player.y*CELLSIZE)-CELLSIZE&&mouseY-67<=(player.y*CELLSIZE)+CELLSIZE) {
        //println("esta encima del player");
        if(mouseY<anterior_mouse_y&& !maze.getHorWall(player.x,player.y)) {
          player.y -=1;
        }else if(mouseY>anterior_mouse_y&& !maze.getHorWall(player.x,player.y+1)) {
          player.y +=1;
        }
        if(mouseX<anterior_mouse_x&& !maze.getVerWall(player.x,player.y)) {
          player.x -=1;
        }else if(mouseX>anterior_mouse_x& !maze.getVerWall(player.x+1,player.y)) {
          player.x +=1;
        }
      }
    }
  }
  anterior_mouse_x = mouseX;
  anterior_mouse_y = mouseY;

  //YOLO
  if(testing==true){

  strokeWeight(1);
  stroke(0, 255, 255); //RGB Contour Color. https://processing.org/reference/stroke_.html
  drawFacadeContourInside(); //Facade Contour

  //Text info
  fill(255);
  //text("Client example receiving Blobs at localhost port:12345", 0, height-0.05*height);
 // text("FrameRate --> "+str(frameRate), 0, height-0.1*height);
if(maze.isCreated()&&active_game==2){
  
}else{
   pushMatrix();
  translate(40, 40 + 32);
  noFill();
  stroke(0, 255, 255);

  fill(0, 255, 0);
  draw_clientSensor4Games(widthDesiredScale, heightDesiredScale - 32, scaleRawSize, bDrawInfo);
  popMatrix();
}
 
  }

  //dibujar fachada
  stroke(255);
  strokeWeight(2);

  drawFacadeContourInside();

  noStroke();
  fill(143, 4, 231, 100);
 // ellipse(mouseX, mouseY, 10, 10);
  image(puntero,mouseX, mouseY, 20, 20);
  stroke(255);
}


//GAME SCREENS


void gameScreen() {

  pushMatrix();
  translate(71, 69);

  maze.draw();

  stroke(255,215,0);

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

  //situar cuadrado rojo (fin)
  if (maze.isCreated()) {




    stroke(0, 0, 255);
    fill(0, 0, 255);

    rect(player.x * CELLSIZE, player.y * CELLSIZE, CELLSIZE-1,CELLSIZE-1);
    //imageMode(CENTER);
  //image(player_img,(player.x * CELLSIZE)+3, (player.y * CELLSIZE)+3, 15,15);

    fill(255, 0, 255);
    stroke(255, 0, 255);
    //rect((MAZE_X * CELLSIZE)-CELLSIZE*2, (MAZE_Y * CELLSIZE)-CELLSIZE*2, CELLSIZE, CELLSIZE);
    rect((goal.x * CELLSIZE), (goal.y * CELLSIZE), CELLSIZE-1, CELLSIZE-1);
    stroke(255);
    fill(255);
  }

  image(mascara_tapar_laberinto,67,51);
   if (maze.isCreated()&&active_game==2) {
    image(imgMask,mouseX-70,mouseY-70);
     pushMatrix();
 // translate(40, 40 + 32);
  noFill();
  stroke(0, 255, 255);

  
  fill(0, 255, 0);
  draw_clientSensor4Games(widthDesiredScale, heightDesiredScale - 32, scaleRawSize, bDrawInfo);
  popMatrix();
  }
 

  
  fill(0, 255, 0);
  textFont(font_2, 11);
  text((active_game+1), 66, -13);
  fill(255);
  textFont(font_2, 10);
  if(active_game == 1){
    text("Flip en " + (FLIP_TIME - flipTimer.second()), 65, 2);
  }
  else{
    if(active_game == 0){
    text("llevar el azul al verde", 65, 2);
   }else if(active_game == 2){
    text("vision reducida", 30, 2);
   }
  }

 
  image(fondo_video, -172, 71);
 image(fondo_video, 302, 71);
  popMatrix();

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
  println("Nivel completado!");
  gameScreen = 2;
  active_game = (active_game + 1) % NUM_LEVELS;
  if (active_game == 2){
    gameScreen = 3;
  }
  println("Next screen " + gameScreen);
  println("Next game " + active_game);
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
    }else{
      gameScreen++;
    }
    println(gameScreen);
  }

  if (keyCode == 80) {
    if (active_game==0) {
      active_game = 1;
      maze.setup();
      maze.addCell(currcell);
    } else if (active_game==1) {
      active_game = 2;
      maze.setup();
    } else if (active_game==2) {
      active_game = 3;
      maze.setup();
      maze.addCell(currcell);
    } else if (active_game==2) {
      active_game = 3;
      maze.setup();
      maze.addCell(currcell);
    } else {
      gameScreen= 3;
      active_game = 0;
      maze.setup();
      maze.addCell(currcell);
    }
  }
}

void keyReleased() {

  if (maze.isCreated()) {
    if (keyCode == UP&&!maze.getHorWall(player.x,player.y)) {
      player.y -=1;
    } else if (keyCode == DOWN&&!maze.getHorWall(player.x,player.y+1) ) {
      player.y +=1;
    } else if (keyCode == LEFT&&!maze.getVerWall(player.x,player.y) ) {
      player.x -=1;
    } else if (keyCode == RIGHT &&!maze.getVerWall(player.x+1,player.y) ) {
      player.x +=1;
    }
    else if(keyCode == 50) {
      maze.flip();
      player.y = MAZE_Y-1 - player.y;
      goal.y = MAZE_Y-1 - goal.y;
    }
  }
  if(keyCode == 51) {
    s = 8;
    maze.setup();
  }
  if(keyCode == 'f'){
    active_game = 1;
  }
  if(keyCode == 52) {
    s = 18;
    maze.setup();
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