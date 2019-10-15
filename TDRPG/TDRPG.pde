<<<<<<< HEAD
import controlP5.*;

final int WINDOW_WIDTH = 1200;
final int WINDOW_HEIGHT = 700;

int screenState = 0;
/*
0 = Start Menu
*/
boolean initializeStartMenu = true;
PImage startMenuBackground;

=======
>>>>>>> Moving the definition of window height/width to the definitions file
void setup(){
	size(1200, 700);
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
