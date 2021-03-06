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
    //textAlign(LEFT);
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
       image(puntero,xPos*w + OFFSET_X, yPos*h + OFFSET_Y, 20, 20);
      //rect(xPos*w, yPos*h, CELLSIZE, CELLSIZE);

      diffX = MOUSE_X_DIFF - YOLO_X_DIFF;
      diffY = MOUSE_Y_DIFF - YOLO_Y_DIFF;
      fill(255, 255, 0);
      //   rect(xPos*w- diffX, yPos*h- diffY, CELLSIZE, CELLSIZE);
    } else {

      diffX = MOUSE_X_DIFF - YOLO_X_DIFF;
      diffY = MOUSE_Y_DIFF - YOLO_Y_DIFF;
      fill(255, 255, 0);
      //rect(xPos*w- diffX, yPos*h- diffY, CELLSIZE, CELLSIZE);
     // rect(xPos*w, yPos*h, CELLSIZE, CELLSIZE);
      image(puntero,xPos*w, yPos*h, 20, 20);
    }
     int posX = (int)Math.floor(xPos*w);
     int posY = (int)Math.floor(yPos*h);

     playerInteraction(posX,posY,true);
     if(maze.isCreated()&&active_game==2){
       pos_mask_x = posX -33;
       pos_mask_y = posY;
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
