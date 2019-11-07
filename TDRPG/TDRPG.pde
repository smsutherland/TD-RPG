import controlP5.*;
ControlP5 cp5;

int screenState = 0;
/*
0 = Start Menu
1 = Settings Menu
2 = Map Menu
3 = Level Info
*/

ArrayList<String> toRemove = new ArrayList<String>();
ArrayList<String> currentControllers = new ArrayList<String>();

boolean initialize = true;
PImage currentBackground;
PImage levelBackground;
JSONArray currentMapData;
JSONObject currentLevelData;

PFont title;
PFont smallTitle;
PFont subTitle;

CallbackListener moveToLevelInfo = new CallbackListener() {
	public void controlEvent(CallbackEvent e){
		println("Opening level info for " + e.getController().getName());
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
	noStroke();
	title = createFont("Times New Roman", 32);
	smallTitle = createFont("Times New Roman", 24);
	
	
	cp5 = new ControlP5(this);
}

void draw(){
	removeItterate();
	
	if(currentBackground != null){
		background(currentBackground);	
	}
	
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
	}
}

void startMenu(){
	if(initialize){
		initialize = false;
		currentBackground = loadImage(START_MENU_BACKGROUND);
		
		addButton("Play_Button", 100, 400, PLAY_BUTTON);
		addButton("Settings_Button", 100, 450, SETTINGS_BUTTON);
		addButton("Exit_Button", 100, 500, EXIT_BUTTON);
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
		for(int i = 1; i < currentMapData.size(); i++){
			JSONObject currentObject = currentMapData.getJSONObject(i);
			if(currentObject.getBoolean("unlocked")){
				cp5.addButton(currentObject.getString("name")).setPosition(currentObject.getInt("xPos"), currentObject.getInt("yPos")).setSize(50, 50).onPress(moveToLevelInfo);
				currentControllers.add(currentObject.getString("name"));
				for(int j = 0; j < toRemove.size(); j++){
					String buttonName = toRemove.get(j);
					println(currentObject.getString("name") + ", " + toRemove.get(j));
					if(buttonName.equals(currentObject.getString("name"))){
						toRemove.remove(j);
						println("Removed " + currentObject.getString("name") + " from the toRemove list");
					}
				}
			}
		}
		
		addButton("Map_Back", 100, 600, BACK_BUTTON);
		if(currentMapData.getJSONObject(0).getInt("screen number") < loadJSONArray(MAP_DATA).size() - 1){
			addButton("Map_Next", 1050, 600, NEXT_BUTTON);		
		}
		
		initialize = false;
	}
}

void levelInfo(){
	if(initialize){
		levelBackground = loadImage(currentLevelData.getString("background"));
		initialize = false;
		addButton("Level_Info_Back", WINDOW_WIDTH/5, WINDOW_HEIGHT*4/5, BACK_BUTTON);
		addButton("Level_Info_Play", WINDOW_WIDTH*4/5 - 50, WINDOW_HEIGHT*4/5, NEXT_BUTTON);
	}
	rectMode(CORNER);
	noStroke();
	fill(100, 100, 100, 255/2);
	rect(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT);
	
	stroke(0);
	strokeWeight(2);
	rectMode(CENTER);
	fill(255);
	rect(WINDOW_WIDTH/2, WINDOW_HEIGHT*2/5, WINDOW_WIDTH*3/5, WINDOW_HEIGHT*3/5);
	
	imageMode(CENTER);
	image(levelBackground, WINDOW_WIDTH/2, WINDOW_HEIGHT*2/5, WINDOW_WIDTH*3/5, WINDOW_HEIGHT*3/5);
	
	textFont(title);
	if(currentLevelData.getString("name").length() > 10){
		textFont(smallTitle);
	}
	fill(0);
	textAlign(CENTER, CENTER);
	text(currentLevelData.getString("name"), WINDOW_WIDTH/2, WINDOW_HEIGHT*3/4, WINDOW_WIDTH*1/2, WINDOW_HEIGHT/10);
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
	if(!initialize){
			if(toRemove.size() > 0){
			cp5.remove(toRemove.get(toRemove.size() - 1));
			println("Removed controller " + toRemove.get(toRemove.size() - 1));
			toRemove.remove(toRemove.size() - 1);
		}
	}
}

void addButton(String name, int x, int y, String imageName){
	PImage buttonImage = loadImage(imageName);
	cp5.addButton(name).setPosition(x, y).setImages(buttonImage, buttonImage, buttonImage).updateSize();
	currentControllers.add(name);
	for(int i = 0; i < toRemove.size(); i++){
		String buttonName = toRemove.get(i);
		if(buttonName.equals(name)){
			toRemove.remove(i);
		}
	}
}

void addButton(String name, int x, int y){
	cp5.addButton(name).setPosition(x, y);
	currentControllers.add(name);
	for(int i = 0; i < toRemove.size(); i++){
		String buttonName = toRemove.get(i);
		if(buttonName.equals(name)){
			toRemove.remove(i);
		}
	}
}

public void controlEvent(ControlEvent e){
	println(e.getController().getName());
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