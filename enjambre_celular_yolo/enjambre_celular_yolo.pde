//YOLO
import processing.awt.PSurfaceAWT;

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
PImage llegada;
PImage player_img;

int last_x = 0;
int last_y = 0;
int gameScreen = 0;
int active_game =  0;

CellPos currcell;


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

  //letras
  x = mouseX;
  y = mouseY;
  texto = createGraphics(130, 120);

  font = createFont("LemonMilkbold.otf", 10);
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

  img.mask(imgMask);
  //fondo_video.mask(mascara_video);
  imageMode(CENTER);
  size(272, 237,P2D);

  maze.setup();
}

void draw() {
  // active_game =3;
  background(0);
  strokeWeight(1);

  stroke(255);
  fill(255, 100);

  if (gameScreen == 0) {
    image(fondo_video, 100, 100);
    fill(255, 215, 0, 200);
    textFont(font, 7);
    textAlign(CENTER);
    text("enjambre\ncelular", width/2, (height/2)-30);
    stroke(255, 215, 0);
    fill(0);

    ellipse(width/2, (height/2)+20, 30,30);


    stroke(255);
    fill(255);
    // image(win_video,135,122);
  } else if (gameScreen == 1) {
    if (active_game == 0) {
      fill(0, 255, 0);

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

      //texto.background(100,100,100, 150);
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
      image(texto, width/2, (height/2)+20);
      //popMatrix();
    } else if (active_game == 2) {
      fill(0, 255, 0);
      //   text("GAME 3", 137, 68);
      fill(255);

      gameScreen();

      //laberinto giro, funciones de girar el laberinto
    } else if (active_game == 3) {
      gameScreen();

      fill(0, 255, 0);
      // text("GAME 4", 137, 68);
      fill(255);
      //laberinto mascara, funciones ver en mascara
    }
    //tapar errores laberinto
    //cambiar de pantalla
    if(maze.isCreated()) {
      if(player.x==goal.x && player.y==goal.y) {
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


  if (maze.isCreated()&&gameScreen>0) {
    //primero ver si el cursor esta encima del player, tener en cuenta el translate y añadir margen para k sea mas faicl
    if (mouseX-70>=(player.x* CELLSIZE)-CELLSIZE&&mouseX-70<=(player.x*CELLSIZE) +CELLSIZE ) {
      if (mouseY-67>=(player.y*CELLSIZE)-CELLSIZE&&mouseY-67<=(player.y*CELLSIZE)+CELLSIZE) {
        println("esta encima del player");
        if(mouseY<anterior_mouse_y&& !maze.getHorWall(player.x,player.y)) {
          player.y -=1;
          escribe =  true;
        }else if(mouseY>anterior_mouse_y&& !maze.getHorWall(player.x,player.y+1)) {
          player.y +=1;
          escribe =  true;
        }else{
          escribe =  false;
        }

        if(mouseX<anterior_mouse_x&& !maze.getVerWall(player.x,player.y)) {
          player.x -=1;
          escribe =  true;
        }else if(mouseX>anterior_mouse_x& !maze.getVerWall(player.x+1,player.y)) {
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
  
  //YOLO
  if(testing==true){
 /* if (bBackgroundAlpha) {
    fill(0, 0, 0, alphaBk);
    rectMode(CORNER);
    rect(0, 0, 192+40, 157+40);
  } else background(0, 0, 0);*/

  strokeWeight(1);
  stroke(0, 255, 255); //RGB Contour Color. https://processing.org/reference/stroke_.html
  drawFacadeContourInside(); //Facade Contour

  //Text info
  fill(255);
  //text("Client example receiving Blobs at localhost port:12345", 0, height-0.05*height);
 // text("FrameRate --> "+str(frameRate), 0, height-0.1*height);

  pushMatrix();
  translate(40, 40 + 32);
  noFill();
  stroke(0, 255, 255);

  fill(0, 255, 0);
  draw_clientSensor4Games(widthDesiredScale, heightDesiredScale - 32, scaleRawSize, bDrawInfo);
  popMatrix();
  }

  //dibujar fachada
  //stroke(143, 4, 231);
  stroke(255);
  strokeWeight(3);

  drawFacadeContourInside();

  noStroke();
  fill(143, 4, 231, 100);
  ellipse(mouseX, mouseY, 10, 10);
  stroke(255);
}


//GAME SCREENS


void gameScreen() {

  pushMatrix();
  translate(71, 69);

  maze.draw();

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
  if (maze.isCreated()) {
    stroke(255, 0, 255);
    fill(255, 0, 255);


    rect(player.x * CELLSIZE, player.y * CELLSIZE, CELLSIZE,CELLSIZE);

    fill(255, 215, 0);
    stroke(255, 215, 0);
    //rect((MAZE_X * CELLSIZE)-CELLSIZE*2, (MAZE_Y * CELLSIZE)-CELLSIZE*2, CELLSIZE, CELLSIZE);
    rect((goal.x * CELLSIZE), (goal.y * CELLSIZE), CELLSIZE, CELLSIZE);

    //image(llegada, (MAZE_X * CELLSIZE)-CELLSIZE*2, (MAZE_Y * CELLSIZE)-CELLSIZE*2, 13, 13);
    stroke(255);
    fill(255);
  }

  image(mascara_tapar_laberinto,67,51);
  fill(255, 215, 0);
  textFont(font, 6);
  text((active_game+1)+"/4", 66, -13);
  fill(0,255,255);
  textFont(font, 4);
  text("completa el juego", 65, 2);

// if (create==true&&active_game==3) {
  if (maze.isCreated()&&active_game==3) {
    image(imgMask,mouseX-65,mouseY-65);
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
  // codes for winner screen
  //background(0);
  //textAlign(CENTER);
  //fill(255,0,0);
  //text("Has pasado la pantalla!", height/2, width/2);
  image(nivel_superado, width/2, height/2);
  timer++;

  if (timer > 300) {
    if (active_game<3) {
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

    if (gameScreen==4) {
      gameScreen= 0;
    }else{
      gameScreen++;
    }
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