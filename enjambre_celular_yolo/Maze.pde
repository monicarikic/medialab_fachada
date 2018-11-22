public class Maze {
  CellPos currcell;
  ArrayList<CellPos> cellstack;
  boolean[][] horwalls;
  boolean[][] verwalls;
  boolean[][] visited;
  boolean whiledraw;
  boolean created;

  void setup(){

    created = false;
    CELLSIZE = 130 / (s * 1.0);
    MAZE_X = (int)(130 / CELLSIZE);
    MAZE_Y = (int)(130 / CELLSIZE);
    WALLSIZE = CELLSIZE / 10.0;

    visited = new boolean[MAZE_X][MAZE_Y];
    cellstack = new ArrayList<CellPos>();
    verwalls = new boolean[MAZE_X][MAZE_Y + 1];
    horwalls = new boolean[MAZE_X + 1][MAZE_Y];
    currcell = new CellPos(1, 1);
    cellstack.add(currcell);

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

  void draw(){
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
     if (created==false) {
        created = true;
        player = new Player(first_x, first_y);
        goal = new Player(MAZE_X-2,MAZE_Y-2);
      }
    }
  }

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


  void setHorWall(int x, int y, boolean value){
    horwalls[x][y] = false;
  }

  boolean getHorWall(int x,int y){
    return horwalls[x][y];
  }

  void setVerWall(int x, int y, boolean value){
    verwalls[x][y] = false;
  }
  boolean getVerWall(int x,int y){
    return verwalls[x][y];
  }

  void setDrawing(boolean aDrawing){
    whiledraw = aDrawing;
  }
  boolean isDrawing(){
    return whiledraw;
  }
  boolean isCreated(){
    return created;
  }
  ArrayList<CellPos> getCells(){
    return cellstack;
  }

  void addCell(CellPos currcell){
    cellstack.add(currcell);
  }

  void addCell(int position,CellPos currcell){
    cellstack.add(position, currcell);
  }

  void visitCell(CellPos currcell){
    visited[currcell.x][currcell.y] = true;
  }

  void removeCell(int position){
    cellstack.remove(0);
  }

  void flip(){
    boolean cell;
    for (int i = 0; i < MAZE_X; i++) {
      for (int j = 1,reverse = MAZE_Y -1; j < MAZE_Y/2; j++,reverse--) {
        cell = horwalls[i][j];
        horwalls[i][j]=horwalls[i][reverse];
        horwalls[i][reverse]=cell;
      }
    }

    for (int i = 1; i < MAZE_X; i++) {
      for (int j = 0,reverse = MAZE_Y -1; j < MAZE_Y/2; j++,reverse--) {
        cell = verwalls[i][j];
        verwalls[i][j]=verwalls[i][reverse];
        verwalls[i][reverse]=cell;
      }
    }

    println(" ");
  }

  void printMaze(){
    for (int i = 0; i < MAZE_X; i++) {
      for (int j = 0; j < MAZE_Y; j++) {
        if(horwalls[i][j]){
          print('-');
        }
        else if(verwalls[i][j]){
          print('|');
        }
        else{
          print(" ");
        }
      }
      println(" ");
    }

  }
}