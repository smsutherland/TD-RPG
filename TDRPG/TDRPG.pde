import controlP5.*;
ControlP5 cp5;

int screenState = 0;
/*
0 = Start Menu
1 = Settings Menu
*/

String[] toRemove = new String[20];

boolean initialize = true;
PImage currentBackground;

void setup(){
	surface.setResizable(true);
	surface.setSize(WINDOW_WIDTH, WINDOW_HEIGHT);
	
	cp5 = new ControlP5(this);
}

void draw(){
	
	if(toRemove[0] != null){
		cp5.remove(toRemove[0]);
		for(int i = 1; i < toRemove.length; i++){
			toRemove[i - 1] = toRemove[i];
		}
		toRemove[toRemove.length - 1] = null;
	}
	
	switch(screenState){
		case 0:
		startMenu();
		break;
		case 1:
		settingsMenu();
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
		
		PImage settingsButton = loadImage(SETTINGS_BUTTON);
		cp5.addButton("Settings_Button").setPosition(100, 450).setImages(settingsButton, settingsButton, settingsButton).updateSize();
		
		PImage exitButton = loadImage(EXIT_BUTTON);
		cp5.addButton("Exit_Button").setPosition(100, 500).setImages(exitButton, exitButton, exitButton).updateSize();
	}
	
}

void settingsMenu(){
	if(initialize){
		initialize = false;
		currentBackground = loadImage(SETTINGS_MENU_BACKGROUND);
		
		PImage backButton = loadImage(BACK_BUTTON);
		cp5.addButton("Settings_Back").setPosition(100, 600).setImages(backButton, backButton, backButton).updateSize();
	}
}

void removeController(String controllerName){
	for(int i = 0; i < toRemove.length; i++){
		if(toRemove[i] == null){
			toRemove[i] = controllerName;
			break;
		}
	}
}

public void controlEvent(ControlEvent e){
	println(e.getController().getName());
}

public void Play_Button(){
	
}

public void Settings_Button(){
	screenState = 1;
	initialize = true;
	removeController("Play_Button");
	removeController("Settings_Button");
	removeController("Exit_Button");
}

public void Exit_Button(){
	exit();
}

public void Settings_Back(){
	screenState = 0;
	initialize = true;
	removeController("Settings_Back");
}