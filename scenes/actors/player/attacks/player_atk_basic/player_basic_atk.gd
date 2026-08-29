extends Node2D
class_name PlayerAtkBasic


@onready var animator: AnimationPlayer = $Animator
@onready var sprite: Sprite2D = $Sprite


# Wether or not the attack is contacting a target.
var _is_contacting: bool

# The direction this attack is going.
var _direction_attacking: Constants.DIR

func attack(dir: Constants.DIR):
	_direction_attacking = dir
	
	
	# TEMP: Sprite's default direction is left. 
	var r: int = 0
	match dir:
		Constants.DIR.LEFT:
			r = 0
		Constants.DIR.UP: 
			r = 90
		Constants.DIR.DOWN:
			r = 270
		Constants.DIR.RIGHT: 
			r = 180
			
	#sprite.rotation_degrees = Constants.get_rotation_from_dir(_direction_attacking)
	sprite.rotation_degrees = r
	
	
	animator.play("attack")


func set_contact(c: bool):
	_is_contacting = c
