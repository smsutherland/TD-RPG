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
	removeItterate();
	
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
		
		addButton("Map_Back", 100, 600, BACK_BUTTON);
		addButton("Map_Next", 1050, 600, NEXT_BUTTON);
		
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

