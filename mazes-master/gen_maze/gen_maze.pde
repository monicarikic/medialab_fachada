class CellPos {
  int x, y;
  
  CellPos(int x, int y) {
    this.x = x;
    this.y = y;
  }
}

int MAZE_SIZE;
float CELLSIZE;
float WALLSIZE;

int s = 10;

boolean showsol;

CellPos currcell;
ArrayList<CellPos> cellstack;
boolean[][] horwalls;
boolean[][] verwalls;
boolean[][] visited;

ArrayList<CellPos> solpath;

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

void domaze() {
  for (int i = 0; i < MAZE_SIZE; i++) {
    for (int j = 0; j < MAZE_SIZE; j++) {
      visited[i][j] = false;
      verwalls[i][j] = true;
      horwalls[i][j] = true;
    }
  }
  
  for (int i = 0; i < MAZE_SIZE; i++) {
    visited[i][0] = true;
    visited[0][i] = true;
    visited[MAZE_SIZE - 1][i] = true;
    visited[i][MAZE_SIZE - 1] = true;
    
    verwalls[i][MAZE_SIZE] = true;
    horwalls[MAZE_SIZE][i] = true;
  }
  
  while(cellstack.size() > 0) {
    ArrayList<CellPos> neighbours = unvisited_n(currcell);
    
    if (currcell.x == MAZE_SIZE - 2 & currcell.y == MAZE_SIZE - 2) {
      solpath = new ArrayList<CellPos>(cellstack);
      solpath.add(currcell);
    }
    
    if (neighbours.size() > 0) {
      cellstack.add(0, currcell);
      currcell = neighbours.get((int)random(neighbours.size()));
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
  }  
}

void setup() {
  size(800, 800);
  
  showsol = false;

  MAZE_SIZE = s;
  CELLSIZE = 800 / (MAZE_SIZE * 1.0);
  WALLSIZE = CELLSIZE / 10.0;
  
  visited = new boolean[MAZE_SIZE][MAZE_SIZE];
  cellstack = new ArrayList<CellPos>();
  solpath = new ArrayList<CellPos>();
  verwalls = new boolean[MAZE_SIZE][MAZE_SIZE + 1];
  horwalls = new boolean[MAZE_SIZE + 1][MAZE_SIZE];
  currcell = new CellPos(1, 1);
  cellstack.add(currcell);
  
  domaze();
}

void draw() {
  background(0);
  
  stroke(255, 0, 0);
  fill(255, 0, 0);
  
  if (showsol) {
    for (CellPos cp: solpath) {
      rect(cp.x * CELLSIZE, cp.y * CELLSIZE, CELLSIZE, CELLSIZE);
    }
  }
  
  fill(0, 255, 255);
  stroke(0, 255, 255);
  
  for (int i = 0; i < MAZE_SIZE; i++) {
    for (int j = 0; j < MAZE_SIZE; j++) {
      if (verwalls[i][j]) {
        rect(i * CELLSIZE, j * CELLSIZE, WALLSIZE, CELLSIZE);
      }
      if (horwalls[i][j]) {
        rect(i * CELLSIZE, j * CELLSIZE, CELLSIZE, WALLSIZE);
      }
    }
  }
  
  for (int i = 0; i < MAZE_SIZE; i++) {
    if (horwalls[MAZE_SIZE][i]) {
      rect(MAZE_SIZE * CELLSIZE, i * CELLSIZE, CELLSIZE, WALLSIZE);
    }
    if (verwalls[i][MAZE_SIZE]) {
      rect(i * CELLSIZE, MAZE_SIZE * CELLSIZE, WALLSIZE, CELLSIZE);
    }
  }
}

void keyPressed() {
  switch(keyCode) {
    case ' ':
      //s++;
      s = 20;
      println(s - 2);
      setup();
      break;
    case 'X':
      showsol = !showsol;
      break;
  }
}