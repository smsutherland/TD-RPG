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
JSONArray currentMapData;
JSONObject currentLevelData;

CallbackListener moveToLevelInfo = new CallbackListener() {
	public void controlEvent(CallbackEvent e){
		println("Opening level info for " + e.getController().getName());
		currentLevelData = loadJSONObject(LEVEL_DATA).getJSONObject(e.getController().getName());
		screenState = 3;
		clearController();
	}
};

void setup(){
	//surface.setResizable(true);
	surface.setSize(WINDOW_WIDTH, WINDOW_HEIGHT);
	surface.setLocation(20, 20);
	
	cp5 = new ControlP5(this);
}

void draw(){
	
	if(toRemove.size() > 0){
		cp5.remove(toRemove.get(toRemove.size() - 1));
		toRemove.remove(toRemove.size() - 1);
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
	
	background(currentBackground);
}

void startMenu(){
	if(initialize){
		initialize = false;
		currentBackground = loadImage(START_MENU_BACKGROUND);
		
		PImage startButton = loadImage(PLAY_BUTTON);
		cp5.addButton("Play_Button").setPosition(100, 400).setImages(startButton, startButton, startButton).updateSize();
		currentControllers.add("Play_Button");
		
		
		PImage settingsButton = loadImage(SETTINGS_BUTTON);
		cp5.addButton("Settings_Button").setPosition(100, 450).setImages(settingsButton, settingsButton, settingsButton).updateSize();
		currentControllers.add("Settings_Button");
		
		PImage exitButton = loadImage(EXIT_BUTTON);
		cp5.addButton("Exit_Button").setPosition(100, 500).setImages(exitButton, exitButton, exitButton).updateSize();
		currentControllers.add("Exit_Button");
	}
	
}

void settingsMenu(){
	if(initialize){
		initialize = false;
		currentBackground = loadImage(SETTINGS_MENU_BACKGROUND);
		
		PImage backButton = loadImage(BACK_BUTTON);
		cp5.addButton("Settings_Back").setPosition(100, 600).setImages(backButton, backButton, backButton).updateSize();
		currentControllers.add("Settings_Back");
	}
}

void mapMenu(){
	if(initialize){
		JSONArray mapValues;
		mapValues = loadJSONArray(MAP_DATA);
		currentMapData = mapValues.getJSONArray(0);
		currentBackground = loadImage(currentMapData.getJSONObject(0).getString("background"));
		for(int i = 1; i < currentMapData.size(); i++){
			JSONObject currentObject = currentMapData.getJSONObject(i);
			if(currentObject.getBoolean("unlocked")){
				cp5.addButton(currentObject.getString("name")).setPosition(currentObject.getInt("xPos"), currentObject.getInt("yPos")).setSize(50, 50).onPress(moveToLevelInfo);
				currentControllers.add(currentObject.getString("name"));
			}
		}
		
		PImage backButton = loadImage(BACK_BUTTON);
		cp5.addButton("Map_Back").setPosition(100, 600).setImages(backButton, backButton, backButton).updateSize();
		currentControllers.add("Map_Back");
		PImage nextButton = loadImage(NEXT_BUTTON);
		cp5.addButton("Map_Next").setPosition(1050, 600).setImages(nextButton, nextButton, nextButton).updateSize();
		currentControllers.add("Map_Next");
		
		initialize = false;
	}
}

void levelInfo(){
	
}

void removeController(String controllerName){
	toRemove.add(controllerName);
	currentControllers.remove(controllerName);
}

void clearController(){
	toRemove.addAll(currentControllers);
	currentControllers.clear();
}

public void controlEvent(ControlEvent e){
	println(e.getController().getName());
}

public void Play_Button(){
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

