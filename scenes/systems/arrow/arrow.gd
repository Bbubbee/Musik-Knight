extends Node2D
class_name Arrow

@onready var sprite: Sprite2D = $Sprite

var speed: float
var direction: int



func init(d: int, s: float = 100):
	speed = s
	direction = d
	
	# Set direction of sprite. 
	match d:
		0:
			sprite.rotation_degrees = 270
		1: 
			sprite.rotation_degrees = 0
		2: 
			sprite.rotation_degrees = 180
		3: 
			sprite.rotation_degrees = 90
			
	
	
