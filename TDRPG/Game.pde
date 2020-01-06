public class Game{
	private PImage background;
	private Tower[][] grid;
	boolean placingTower = false;
	
	Game(){
		background = null;
		grid = new Tower[19][14];
	}
	
	Game(String backgroundFilename){
		background = loadImage(backgroundFilename);
		grid = new Tower[19][14];
	}
	
	Game(PImage background_){
		background = background_;
		grid = new Tower[19][14];
	}
	
	void initializeGame(){
		
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
	}
	
	void update(){
		if(placingTower){
			checkForTowerPlacement();
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
			grid[x][y] = new Tower();
		}
	}
}