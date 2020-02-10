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

	void render(PVector position){
		imageMode(CENTER);
		image(breed.texture(), position.x, position.y);
	}

	void move(){
		position += breed.speed();
	}
}