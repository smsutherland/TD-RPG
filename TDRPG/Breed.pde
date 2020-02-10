public class Breed{
	PImage texture;
	int maxHealth;
	int speed;
	int damage;
	
	Breed(JSONObject data){
		texture = loadImage(data.getString("textureFilename"));
		maxHealth = data.getInt("maxHealth");
		speed = data.getInt("speed");
		damage = data.getInt("damage");
	}
	
	PImage texture(){
		return texture;
	}
	
	int maxHealth(){
		return maxHealth;
	}
	
	int speed(){
		return speed;
	}
	
	int damage(){
		return damage;
	}
}