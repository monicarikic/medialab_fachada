public class Maze{
  CellPos currcell;
  ArrayList<CellPos> cellstack;
  boolean[][] horwalls;
  boolean[][] verwalls;
  boolean[][] visited;
  boolean whiledraw;

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

  static void setup(){
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

  static boolean getHorWall(int x,int y){
    return horwals[x][y];
  }

  static boolean getVerWall(int x,int y){
    return verwals[x][y];
  }

  static boolean drawing(){
    return whiledraw;
  }
}
