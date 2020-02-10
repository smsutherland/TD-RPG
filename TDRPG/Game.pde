public class Game{
	private String levelName;
	private PImage background;
	private Tower[][] grid;
	private boolean placingTower = false;
	private ArrayList<Enemy> enemyList = new ArrayList<Enemy>();
	private int[][] path;
	
	BufferedReader schedule;
	
	Game(){
		levelName = "Nameless";
		background = null;
		grid = new Tower[19][14];
		schedule = null;
		path = null;
	}
	
	Game(String levelName_){
		levelName = levelName_;
		background = loadImage("Level Data/" + levelName + "/background.png");
		grid = new Tower[19][14];
		path = loadPath();
	}
	
	void render(){
		imageMode(CORNER);
		image(background, 0, 0);
		for(int x = 0; x < 19; x++){
			for(int y = 0; y < 14; y++){
				if(grid[x][y] != null){
					grid[x][y].drawAt(x*50, y*50);
				}
			}
		}
		
		if(placingTower){
			for(int x = 0; x < 19; x++){
				for(int y = 0; y < 14; y++){
					drawGridSquare(x, y);
				}
			}
		}
		
		for(int i = 0; i < enemyList.size(); i++){
			Enemy e = enemyList.get(i);
			PVector position = getPathPosition(e);
			if(position != null){
				//e.render(position, getPathDirection(e));
				e.render(position);
			}else{
				enemyList.remove(e);
				i--;
			}
		}
	}
	
	void update(){
		if(placingTower){
			checkForTowerPlacement();
		}
		
		addNextEnemy();
		
		for(Enemy e : enemyList){
			e.move();
		}
	}
	
	void startPlacingTower(){
		placingTower = true;
	}
	
	private void drawGridSquare(int x, int y){
		x *= 50;
		y *= 50;
		noFill();
		strokeWeight(1.5);
		square(x, y, 50);
	}
	
	private void checkForTowerPlacement(){
		if(mousePressed && mouseButton == LEFT){
			if(mouseX < 950){
				int x = mouseX/50;
				int y = mouseY/50;
				placeTower(x, y);
				placingTower = false;
			}
		}
	}
	
	private void placeTower(int x, int y){
		if(grid[x][y] == null){
			byte mapData[] = loadBytes("Level Data/" + levelName + "/mapPlacement.bin");
			byte relevantByte = mapData[(x + y*GAME_GRID_WIDTH)/8];
			byte[] powers = {byte(1), byte(2), byte(4), byte(8), byte(16), byte(32), byte(64), byte(128)};
			int bit = (x + y*GAME_GRID_WIDTH)%8;
			if((relevantByte & powers[bit]) != byte(0)){
				grid[x][y] = new Tower();
			}
		}
	}
	
	private void addNextEnemy(){
		if(frameCount%60 == 0){
			enemyList.add(new Enemy("Square Bear"));
		}
	}

	private int[][] loadPath(){
		BufferedReader reader = createReader("Level Data/" + levelName + "/mapPath.txt");
		String line;
		try{
			line = reader.readLine();
		}catch (IOException e){
			return null;
		}
		int numPoints = int(line);
		int[][] toReturn = new int[numPoints][2];
		for(int i = 0; i < numPoints; i++){	
			try{
				line = reader.readLine();
			}catch (IOException e){
				break;
			}
			String[] pieces = split(line, ',');
			toReturn[i][0] = int(pieces[0]);
			toReturn[i][1] = int(pieces[1]);
		}
		return toReturn;
	}

	private PVector getPathPosition(Enemy e){
		int enemyDistance = e.position;
		float totalDistance = 0;
		for(int i = 1; i < path.length; i++){
			float currentDistance = 50*dist(path[i-1][0], path[i-1][1], path[i][0], path[i][1]);
			if(totalDistance + currentDistance > enemyDistance){
				float remainderDistance = enemyDistance - totalDistance;
				int x = int(lerp(50*path[i-1][0], 50*path[i][0], remainderDistance/currentDistance)) + 25;
				int y = int(lerp(50*path[i-1][1], 50*path[i][1], remainderDistance/currentDistance)) + 25;
				return new PVector(x, y);
			}else{
				totalDistance += currentDistance;
			}
		}
		
		return null;
	}

/* 	private float getPathDirection(Enemy e){

	} */
}