import controlP5.*;

int screenState = 0;
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
	}
}

void startMenu(){
	if(initializeStartMenu){
		initializeStartMenu = false;
		background(startMenuBackground);
	}
	
}
