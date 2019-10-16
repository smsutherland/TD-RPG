import controlP5.*;

int screenState = 0;
/*
0 = Start Menu
1 = Settings Menu
*/

boolean initializeStartMenu = true;
PImage startMenuBackground;

void setup(){
	surface.setResizable(true);
	surface.setSize(WINDOW_WIDTH, WINDOW_HEIGHT);
	startMenuBackground = loadImage(START_MENU_IMAGE);
}

void draw(){
	switch(screenState){
		case 0:
		startMenu();
		break;
		case 1:
		settingsMenu();
		break;
	}
}

void startMenu(){
	if(initializeStartMenu){
		initializeStartMenu = false;
		background(startMenuBackground);
		ControlP5 startMenuControl = new ControlP5(this);
		
		PImage startButton = loadImage(PLAY_BUTTON);
		PImage[] imgs = {startButton, startButton, startButton};
		startMenuControl.addButton("Play_Button").setPosition(100, 400).setImages(imgs).updateSize();
		
		PImage settingsButton = loadImage(SETTINGS_BUTTON);
		for(int i = 0; i < 3; i++){
			imgs[i] = settingsButton;
		}
		startMenuControl.addButton("Settings_Button").setPosition(100, 450).setImages(imgs).updateSize();
		
		PImage exitButton = loadImage(EXIT_BUTTON);
		for(int i = 0; i < 3; i++){
			imgs[i] = exitButton;
		}
		startMenuControl.addButton("Exit_Button").setPosition(100, 500).setImages(imgs).updateSize();
	}
	
}

public void controlEvent(ControlEvent e){
	println(e.getController().getName());
}

public void Play_Button(){
	
}

public void Settings_Button(){
	screenState = 1;
}

public void Exit_Button(){
	exit();
}