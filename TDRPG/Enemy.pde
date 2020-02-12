public class Enemy{
	Breed breed;
	int health;
	int position;
	
	Enemy(String breedName){		
		breed = breed(breedName);
		if(breed != null){
			health = breed.maxHealth();
		}else{
			health = 0;
		}
		position = 0;
	}

	void render(int[] position){
		imageMode(CENTER);
		image(breed.texture(), position[0], position[1]);
	}

	void move(){
		position += breed.speed();
	}

	int position(){
		return position;
	}

	void hurt(int damage){
		health -= damage;
	}

	boolean isDead(){
		return health <= 0;
	}
}