class Blob {
  float xPos;
  float yPos;
  int id;
  int time;
  //float probability;
  float wRawBlob;
  float hRawBlob;
  //TODO velx, vely

  int anterior_x = 0;
  int anterior_y = 0;

  // Constructor
  Blob() {
    xPos = -1;
    yPos = -1;
    id = -1; //Id will be the order received or ID from tracking
    time = -1; //time -1 if not tracking
    //probability = 0;
    //TODO add Velocity vector
    //TODO add Area info
  }

  // Custom method for updating the variables
  void updateOSC() {
  }

  //------------------------------
  void displayBlobInfo(int w, int h) {
    int deltaX = -40;
    int deltaY = -30;
    text("["+str(id)+"]"+"("+str(time)+")", xPos*w+deltaX, yPos*h*1+deltaY);
  }

  // Custom method for drawing the object
  void display(int w, int h, float _scaleRawDims, Boolean _bDrawInfo) {
    textAlign(LEFT);
    //Draw Received Blob. Probability = quality person detection.
    int idColor = id*100 % 255;
    fill(idColor, 255, 255, 200);
    //stroke(255, 255, 255, 255);
    noStroke();
    strokeWeight(2); // Thicker
    fill(255, 0, 0);
    int diffX = MOUSE_X_DIFF;
    int diffY = MOUSE_Y_DIFF;
    if (_scaleRawDims>0) {
      // image(puntero,xPos*w, yPos*h, 20, 20);
      rect(xPos*w, yPos*h, CELLSIZE, CELLSIZE);

      diffX = MOUSE_X_DIFF - YOLO_X_DIFF;
      diffY = MOUSE_Y_DIFF - YOLO_Y_DIFF;
      fill(255, 255, 0);
      //   rect(xPos*w- diffX, yPos*h- diffY, CELLSIZE, CELLSIZE);
    } else {

      diffX = MOUSE_X_DIFF - YOLO_X_DIFF;
      diffY = MOUSE_Y_DIFF - YOLO_Y_DIFF;
      fill(255, 255, 0);
      rect(xPos*w- diffX, yPos*h- diffY, CELLSIZE, CELLSIZE);
      rect(xPos*w, yPos*h, CELLSIZE, CELLSIZE);
    }

    //mirar si el blob coincide cn el punto
    if (maze.isCreated()&&gameScreen==1) {

      //  println("y",yPos,anterior_y);
      //  println("x",xPos,anterior_x);
      if (isOverPlayer((int)(xPos*w), (int)(yPos*h), true)) {
        //experimento para que no mueva en diagonal

        /*if (int(yPos*h) <= anterior_y) {
          if (anterior_x>int(xPos*w)) {
            if ((anterior_y-int(yPos*h)>anterior_x-int(xPos*w)) && !maze.getHorWall(player.x, player.y)) {
              player.y -=1;
              println("arriba");
            } else if (!maze.getVerWall(player.x, player.y)) {
              player.x -=1;
              println("izquierda");
            }
          } else {

            if ((anterior_y-int(yPos*h)>int(xPos*w)-anterior_x)&& !maze.getHorWall(player.x, player.y)) {
              player.y -=1;
              println("arriba");
            } else if (!maze.getVerWall(player.x, player.y)) {
              player.x -=1;
              println("izquierda");
            }
          }
        } else if (int(yPos*h) >anterior_y) {
          if (int(xPos*w)>anterior_x) { 
            if ((int(yPos*h)-anterior_y>int(xPos*w)-anterior_x) && !maze.getHorWall(player.x, player.y+1)) {
              player.y +=1;
              println("abajo");
            } else if (!maze.getVerWall(player.x+1, player.y)) {
              player.x +=1;
              println("derecha");
            }
          } else {

            if ((int(yPos*h)-anterior_y>anterior_x-int(xPos*w))&& !maze.getHorWall(player.x, player.y)) {
              player.y +=1;
              println("abajo");
            } else if (!maze.getVerWall(player.x, player.y)) {
              player.x +=1;
              println("derecha");
            }
          }
        }

        if (int(xPos*w) <= anterior_x ) {

          if (anterior_y>int(yPos*h)) {
            if ((anterior_x-int(xPos*w)>anterior_y-int(yPos*h))&& !maze.getVerWall(player.x, player.y)) {
              player.x -=1;
              println("izquierda");
            } else if (!maze.getHorWall(player.x, player.y)) {
              player.y -=1;
              println("arriba");
            }
          } else {

            if ((anterior_x-int(xPos*w)>int(yPos*h)-anterior_y)&& !maze.getVerWall(player.x, player.y)) {
              player.x -=1;
              println("izquierda");
            } else if (!maze.getHorWall(player.x, player.y)) {
              player.y -=1;
              println("arriba");
            }
          }
        } else if (int(xPos*w) > anterior_x) {

          if (int(yPos*h)>anterior_y) {
            if ((int(xPos*w)-anterior_x>int(yPos*h)-anterior_y)&& !maze.getVerWall(player.x+1, player.y)) {
              player.x +=1;
              println("derecha");
            } else if (!maze.getHorWall(player.x, player.y+1)) {
              player.y +=1;
              println("abajo");
            }
          } else {

            if ((int(xPos*w)-anterior_x>anterior_y-int(yPos*h))&& !maze.getVerWall(player.x+1, player.y)) {
              player.x +=1;
              println("derecha");
            } else if (!maze.getHorWall(player.x, player.y+1)) {
              player.y +=1;
              println("abajo");
            }
          }
        }*/


        //codigo correcto pero en diagonal pero con comparacion para evitar flicker
         
         println("encima");
         println(anterior_y);
         
         if(int(yPos*h) <= anterior_y && !maze.getHorWall(player.x,player.y)&&(anterior_x-int(yPos*h)<anterior_y-int(xPos*w))) {
         player.y -=1;
         println("arriba");
         }
         
         else if(int(yPos*h) >anterior_y && !maze.getHorWall(player.x,player.y + 1)) {
         player.y +=1;
         println("abajo");
         }
         
         if(int(xPos*w) <= anterior_x  && !maze.getVerWall(player.x,player.y)&&(anterior_x-int(yPos*h)>anterior_y-int(xPos*w))) {
         player.x -=1;
         println("izquierda");
         }
         
         else if(int(xPos*w) > anterior_x && !maze.getVerWall(player.x+1,player.y)) {
         player.x +=1;
         println("derecha");
         }
         
         // println(maze.getHorWall(player.x,player.y),maze.getVerWall(player.x,player.y) );
         // println(maze.getHorWall(player.x,player.y+1),maze.getVerWall(player.x+1,player.y) );
         
        // }
         
      }
      anterior_x = int(xPos*w);
      anterior_y = int(yPos*h);
    } else if (gameScreen == 0) {
      if (isOverStart((int)(xPos*w), (int)(yPos*h), true)) {
        if (timer.second()>5) {
          gameScreen = 1;
          active_game = GAME_NORMAL;
        }
      } else {
        timer.restart();
      }
    } else if (maze.isCreated()&&active_game==2) {
      //  image(imgMask,xPos*w,yPos*h);
    }



    //Draw Info
    if (_bDrawInfo) {
      fill(0, 200, 0, 250);
      pushMatrix();
      translate(60, 0, 0);
      displayBlobInfo(w, h);
      popMatrix();
    }
  }
}
