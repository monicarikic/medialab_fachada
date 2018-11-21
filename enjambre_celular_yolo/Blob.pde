class Blob {
  float xPos;
  float yPos;
  int id;
  int time;
  //float probability;
  float wRawBlob;
  float hRawBlob;
  //TODO velx, vely

  float anterior_x = 0;
  float anterior_y = 0;

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
    if (_scaleRawDims>0) {
      image(puntero,xPos*w, yPos*h, 20, 20);
    }
    else{
      image(puntero,xPos*w, yPos*h, 20, 20);
    }

    //mirar si el blob coincide cn el punto
    if (maze.isCreated()&&gameScreen==1) {

      if (isOverPlayer((xPos*w),(yPos*h),true)) {
        println("esta encima del player");
        if(yPos*h<anterior_mouse_y&& !maze.getHorWall(player.x,player.y)) {
          player.y -=1;
        }else if(yPos*h>anterior_mouse_y&& !maze.getHorWall(player.x,player.y+1)) {
          player.y +=1;
        }
        if(xPos*w<anterior_x&& !maze.getVerWall(player.x,player.y)) {
          player.x -=1;
        }else if(xPos*w>anterior_x& !maze.getVerWall(player.x+1,player.y)) {
          player.x +=1;
        }
      }
      else if(gameScreen == 0){
        if(isOverStart((xPos*w),(yPos*h),true)){
          if(timer.second()>5){
            gameScreen = 1;
            active_game = GAME_NORMAL;
          }
        }
        else{
          timer.restart();
        }
      }
      else if (maze.isCreated()&&active_game==2) {
              //  image(imgMask,xPos*w,yPos*h);
      }

    }
    anterior_x = xPos;
    anterior_y = yPos;
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
