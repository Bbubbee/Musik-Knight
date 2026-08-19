extends Node


enum DIR {
	LEFT,
	UP,
	DOWN,
	RIGHT
}

func get_rand_dir() -> DIR:
	return randi_range(DIR.LEFT, DIR.RIGHT) as DIR
