extends Node2D
class_name PlayerAtkBasic


@onready var animator: AnimationPlayer = $Animator
@onready var sprite: Sprite2D = $Sprite

signal finished_attacking

var _on_cooldown: bool


# Wether or not the attack is contacting a target.
var _is_contacting: bool

# The direction this attack is going.
var _direction_attacking: Constants.DIR

func attack(dir: Constants.DIR):
	_direction_attacking = dir
	_on_cooldown = true
	
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


# Sets wether the attack is making contact with a trget based on the animation.
func set_contact(c: bool):
	_is_contacting = c


func _on_animator_animation_finished(anim_name: StringName) -> void:
	if not anim_name == "attack": return
	
	finished_attacking.emit()
	_on_cooldown = false
	
