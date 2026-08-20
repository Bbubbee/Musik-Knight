extends Node


enum DIR {
	LEFT,
	UP,
	DOWN,
	RIGHT
}

func get_rand_dir() -> DIR:
	return randi_range(DIR.LEFT, DIR.RIGHT) as DIR

func get_string_from_dir(dir: DIR) -> String:
	match dir:
		DIR.LEFT: 
			return "left" 
		DIR.UP: 
			return "up" 
		DIR.DOWN: 
			return "down" 
		DIR.RIGHT: 
			return "right" 
	return "null direction"


func get_rotation_from_dir(dir: DIR):
	match dir:
		DIR.LEFT:
			return 270
		DIR.UP: 
			return 0
		DIR.DOWN:
			return 180
		DIR.RIGHT:  
			return 90
	
	return 270
