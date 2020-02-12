public class Tower{
	int xPos;
	int yPos;
	int range;
	Enemy target;
	int cooldown;

	Tower(){
		xPos = yPos = 0;
		range = 0;
	}

	Tower(int xPos_, int yPos_){
		xPos = xPos_;
		yPos = yPos_;
		range = 150;
	}

	public void update(){
		if(cooldown > 0){
			cooldown--;
		}

		if(cooldown <= 0){
			fire();
		}
	}
	
	public void render(){
		circle(xPos, yPos, 25);
	}

	public void tryToTarget(Enemy e, int[] enemyPos){
		if(target != null){
			if(e.position() > target.position()){
				if(inRange(enemyPos)){
					target = e;
				}
			}
		}
		if(inRange(enemyPos)){
			target = e;
		}
	}

	private boolean inRange(int[] enemyPos){
		return dist(xPos, yPos, enemyPos[0], enemyPos[1]) <= range;
	}

	private void fire(){
		if(target != null){
			target.hurt(50);
			cooldown += 30;
		}
	}
}