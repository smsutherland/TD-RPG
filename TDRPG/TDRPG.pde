import controlP5.*;
import java.util.Map;
ControlP5 cp5;

int screenState = 0;
/*
0 = Start Menu
1 = Settings Menu
2 = Map Menu
3 = Level Info
4 = In Game
*/

ArrayList<String> toRemove = new ArrayList<String>();
ArrayList<String> currentControllers = new ArrayList<String>();

boolean initialize = true;
PImage currentBackground;
PImage levelBackground;
JSONArray currentMapData;
JSONObject currentLevelData;
boolean hard = false;
Game activeGame = null;

Map<String, Breed> breeds = new HashMap<String, Breed>();
String[] breedId;

PFont title;
PFont smallTitle;
PFont subTitle;

CallbackListener moveToLevelInfo = new CallbackListener() {
	public void controlEvent(CallbackEvent e){
		currentLevelData = loadJSONObject(LEVEL_DATA).getJSONObject(e.getController().getName());
		screenState = 3;
		initialize = true;
		clearController();
	}
};

void setup(){
	//surface.setResizable(true);
	surface.setSize(WINDOW_WIDTH, WINDOW_HEIGHT);
	surface.setLocation(20, 20);
	frameRate(30);
	noStroke();
	title = createFont("Times New Roman", 32);
	smallTitle = createFont("Times New Roman", 24);
	subTitle = createFont("Times New Roman", 24);
	
	
	cp5 = new ControlP5(this);
}

void draw(){
	removeItterate();
	
	if(currentBackground != null){
		background(currentBackground);	
	}
	
	drawScreen();
}

void drawScreen(){
	switch(screenState){
	case 0:
		startMenu();
		break;
	case 1:
		settingsMenu();
		break;
	case 2:
		mapMenu();
		break;
	case 3:
		levelInfo();
		break;
	case 4:
		inGame();
		break;
	}
}

void startMenu(){
	if(initialize){
		initialize = false;
		currentBackground = loadImage(START_MENU_BACKGROUND);
		
		addButton("Play_Button", 100, 350, PLAY_BUTTON);
		addButton("Settings_Button", 100, 420, SETTINGS_BUTTON);
		addButton("Exit_Button", 100, 490, EXIT_BUTTON);
	}
}

void settingsMenu(){
	if(initialize){
		initialize = false;
		currentBackground = loadImage(SETTINGS_MENU_BACKGROUND);
		
		addButton("Settings_Back", 100, 600, BACK_BUTTON);
	}
}

void mapMenu(){
	if(initialize){
		currentBackground = loadImage(currentMapData.getJSONObject(0).getString("background"));
		
		addLevelButtons();

		addButton("Map_Back", 100, 600, BACK_BUTTON);
		if(currentMapData.getJSONObject(0).getInt("screen number") < loadJSONArray(MAP_DATA).size() - 1){
			addButton("Map_Next", 1050, 600, NEXT_BUTTON);		
		}
		
		initialize = false;
	}
}

void addLevelButtons(){
	for(int i = 1; i < currentMapData.size(); i++){
		JSONObject currentLevelButtonData = currentMapData.getJSONObject(i);
		
		if(currentLevelButtonData.getBoolean("unlocked")){
			addThisLevelButton(currentLevelButtonData);
		}
	}
}

void addThisLevelButton(JSONObject thisLevel){
	try{
		
		cp5.addButton(thisLevel.getString("name"))
		.setPosition(thisLevel.getInt("xPos"), thisLevel.getInt("yPos"))
		.setSize(50, 50)
		.onPress(moveToLevelInfo);
		
		currentControllers.add(thisLevel.getString("name"));
		undoRemove(thisLevel.getString("name"));
	}
	catch(Exception e){println(e);}
}

void levelInfo(){
	if(initialize){
		levelBackground = loadImage("Level Data/" + currentLevelData.getString("name") + "/background.png");
		addButton("Level_Info_Back", WINDOW_WIDTH/5, WINDOW_HEIGHT*4/5, BACK_BUTTON);
		addButton("Level_Info_Play", WINDOW_WIDTH*4/5 - 50, WINDOW_HEIGHT*4/5, NEXT_BUTTON);
		
		cp5.addRadioButton("Difficulty").setPosition(WINDOW_WIDTH*3/5 + 100, WINDOW_HEIGHT*4/5).setSize(40, 20).setItemsPerRow(1).addItem("Normal", 0).addItem("Hard", 1).setNoneSelectedAllowed(false).activate(0);
		currentControllers.add("Difficulty");
		initialize = false;
	}
	levelInfoDrawShade();

	levelInfoDrawOutline();

	imageMode(CENTER);
	image(levelBackground, WINDOW_WIDTH/2, WINDOW_HEIGHT*2/5, WINDOW_WIDTH*3/5, WINDOW_HEIGHT*3/5);
	
	levelInfoDrawText();
}

void levelInfoDrawShade(){
	rectMode(CORNER);
	noStroke();
	fill(#646464, 255/2);
	rect(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT);
}

void levelInfoDrawOutline(){
	stroke(0);
	strokeWeight(2);
	rectMode(CENTER);
	fill(#ffffff);
	rect(WINDOW_WIDTH/2, WINDOW_HEIGHT*2/5, WINDOW_WIDTH*3/5, WINDOW_HEIGHT*3/5);
}

void levelInfoDrawText(){
	textFont(title);
	if(currentLevelData.getString("name").length() > 10){
		textFont(smallTitle);
	}
	fill(#000000);
	textAlign(CENTER, CENTER);
	text(currentLevelData.getString("name"), WINDOW_WIDTH/2, WINDOW_HEIGHT*3/4, WINDOW_WIDTH*1/2, WINDOW_HEIGHT/10);
	
	textFont(subTitle);
	textAlign(CORNER);
	text("Highscore: " + currentLevelData.getInt("highscore"), WINDOW_WIDTH*3/10, WINDOW_HEIGHT*17/20);
}

void inGame(){
	if(initialize){
		addButton("Add_Tower", WINDOW_WIDTH*4/5 + 20, 20);
		addButton("Quit", WINDOW_WIDTH*4/5 + 100, 20);
		addButton("Next_Round", WINDOW_WIDTH*4/5 + 20, 60);
		activeGame = new Game(currentLevelData.getString("name"));
		levelBackground = null;
		initialize = false;
	}
	fill(#66461b);
	rectMode(CORNER);
	rect(950, 0, 250, WINDOW_HEIGHT);
	fill(#000000);
	line(950, WINDOW_HEIGHT/5, WINDOW_WIDTH, WINDOW_HEIGHT/5);
	
	activeGame.update();
	activeGame.render();
}

void removeController(String controllerName){
	toRemove.add(controllerName);
	currentControllers.remove(controllerName);
}

void clearController(){
	toRemove.addAll(currentControllers);
	currentControllers.clear();
}

void removeItterate(){
	if(toRemove.size() > 0){
		cp5.remove(toRemove.get(toRemove.size() - 1));
		toRemove.remove(toRemove.size() - 1);
	}
}

void addButton(String name, int x, int y, String imageName){
	PImage buttonImage = loadImage(imageName);
	cp5.addButton(name).setPosition(x, y).setImages(buttonImage, buttonImage, buttonImage).updateSize();
	currentControllers.add(name);
	undoRemove(name);
}

void addButton(String name, int x, int y){
	cp5.addButton(name).setPosition(x, y);
	currentControllers.add(name);
	undoRemove(name);
}

void undoRemove(String dontRemove){
	for(int i = 0; i < toRemove.size(); i++){
		String buttonName = toRemove.get(i);
		if(buttonName.equals(dontRemove)){
			toRemove.remove(i);
		}
	}
}

public void controlEvent(ControlEvent e){
	try{
		println(e.getController().getName());
	}catch(Exception ex){println(ex);}
}

public void Play_Button(){
	JSONArray mapValues = loadJSONArray(MAP_DATA);
	currentMapData = mapValues.getJSONArray(0);
	screenState = 2;
	initialize = true;
	clearController();
}

public void Settings_Button(){
	screenState = 1;
	initialize = true;
	clearController();
}

public void Exit_Button(){
	exit();
}

public void Settings_Back(){
	screenState = 0;
	initialize = true;
	clearController();
}

public void Map_Back(){
	if(currentMapData.getJSONObject(0).getInt("screen number") > 0){
		JSONArray mapValues = loadJSONArray(MAP_DATA);
		currentMapData = mapValues.getJSONArray(currentMapData.getJSONObject(0).getInt("screen number") - 1);
	}else{
		screenState = 0;
	}
	initialize = true;	
	clearController();	
}

public void Map_Next(){
	JSONArray mapValues = loadJSONArray(MAP_DATA);
	currentMapData = mapValues.getJSONArray(currentMapData.getJSONObject(0).getInt("screen number") + 1);
	clearController();
	initialize = true;
}

public void Level_Info_Back(){
	screenState = 2;
	initialize = true;
	clearController();
}

public void Difficulty(int difficulty){
	if(difficulty == 0){
		hard = false;
	}else{
		hard = true;
	}
}

public void Level_Info_Play(){
	screenState = 4;
	initialize = true;
	clearController();
}

public void Add_Tower(){
	activeGame.startPlacingTower();
}

public void Quit(){
	screenState = 0;
	initialize = true;
	clearController();
}

public void Next_Round(){
	activeGame.startRound();
}

Breed breed(String breedName){
	if(breeds.size() == 0){
		loadBreeds();
	}
	return breeds.get(breedName);
}

void loadBreeds(){
	if(breeds.size() == 0){
		JSONArray breedsInJSON = loadJSONArray(BREEDS_DATA);
		int numBreeds = breedsInJSON.size();
		breedId = new String[numBreeds];
		for(int i = 0; i < numBreeds; i++){
			JSONObject thisBreed = breedsInJSON.getJSONObject(i);
			breeds.put(thisBreed.getString("name"), new Breed(thisBreed));
			breedId[i] = thisBreed.getString("name");
		}
	}
}