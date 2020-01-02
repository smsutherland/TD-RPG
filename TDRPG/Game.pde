public class Game{
	private PImage background;
	private Tower[][] grid;
	
	Game(){
		background = null;
		grid = new Tower[19][14];
	}
	
	Game(String backgroundFilename){
		background = loadImage(backgroundFilename);
		grid = new Tower[19][14];
	}
	
	void initializeGame(){
		currentBackground = background;
	}
	
	void render(){
		
	}
	
	void update(){
		
	}
}