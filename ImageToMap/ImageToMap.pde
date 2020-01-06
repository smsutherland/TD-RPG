void setup() {
  selectInput("Select a file to process:", "fileSelected");
}

void fileSelected(File selection) {
	if (selection == null) {
		println("Window was closed or the user hit cancel.");
	} else {
		println("User selected " + selection.getAbsolutePath());
		PImage mapImage = loadImage(selection.getAbsolutePath());
		if(mapImage != null){
			mapImage.loadPixels();
			
			boolean[] colors = new boolean[mapImage.width*mapImage.height];
			int i = 0;
			for(color c : mapImage.pixels){
				if(c == color(255,255,255)){
					colors[i] = true;
				}else{
					colors[i] =false;
				}
				i++;
			}
			
			byte[] powers = {byte(1), byte(2), byte(4), byte(8), byte(16), byte(32), byte(64), byte(128)};
			
			byte[] bytes = new byte[colors.length/8 + 1];
			for(i = 0; i < colors.length; i++){
				int byteIndex = i/8;
				int bitIndex = i%8;
				if(colors[i]){
					bytes[byteIndex] += powers[bitIndex];
				}
			}
			
			saveBytes("result.bin", bytes);
		}
	}
}
