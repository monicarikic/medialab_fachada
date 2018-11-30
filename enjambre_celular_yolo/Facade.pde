//-----------------------------------
void drawFacadeContourInside()
{
  //left line
  line(40 + OFFSET_X, 72 + OFFSET_Y, 40 + OFFSET_X, 196 + OFFSET_Y);

  //bottom
  line(40 + OFFSET_X, 196 + OFFSET_Y, 231 + OFFSET_X, 196 + OFFSET_Y);

  //right side
  line(231 + OFFSET_X, 72 + OFFSET_Y, 231 + OFFSET_X, 196 + OFFSET_Y);

  // steps
  //flat left
  line(40 + OFFSET_X, 72 + OFFSET_Y, 76 + OFFSET_X, 72 + OFFSET_Y);

  //vert
  line(76 + OFFSET_X, 72 + OFFSET_Y, 76 + OFFSET_X, 56 + OFFSET_Y);

  // hor
  line(76 + OFFSET_X, 56 + OFFSET_Y, 112 + OFFSET_X, 56 + OFFSET_Y);

  //vert
  line(112 + OFFSET_X, 56 + OFFSET_Y, 112 + OFFSET_X, 40 + OFFSET_Y);

  //top
  line(112 + OFFSET_X, 40 + OFFSET_Y, 159 + OFFSET_X, 40 + OFFSET_Y);

  //vert right side
  line(159 + OFFSET_X, 40 + OFFSET_Y, 159 + OFFSET_X, 56 + OFFSET_Y);

  //hors
  line(160 + OFFSET_X, 56 + OFFSET_Y, 195 + OFFSET_X, 56 + OFFSET_Y);

  //  vert
  line(195 + OFFSET_X, 56 + OFFSET_Y, 195 + OFFSET_X, 72 + OFFSET_Y);

  //hor
  line(196 + OFFSET_X, 72 + OFFSET_Y, 231 + OFFSET_X, 72 + OFFSET_Y);

}
