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

var damage: float 

func attack(dir: Constants.DIR, d: float):
	_direction_attacking = dir
	_on_cooldown = true
	self.damage = d
	
	
	# TEMP: Sprite's default direction is left. 
	var r: int = 0
	match dir:
		Constants.DIR.LEFT:
			r = 0
			sprite.position = Vector2(-100, 0)
			sprite.flip_v = false
		Constants.DIR.UP: 
			r = 90
			sprite.position = Vector2(0, -100)
			
		Constants.DIR.DOWN:
			r = 270
			sprite.position = Vector2(0, 100)
			
		Constants.DIR.RIGHT: 
			r = 180
			sprite.position = Vector2(100, 0)
			sprite.flip_v = true

			
	#sprite.rotation_degrees = Constants.get_rotation_from_dir(_direction_attacking)
	sprite.rotation_degrees = r
	
	animator.play("attack")


# Sets wether the attack is making contact with a target based on the animation.
# NOTE: Used in animations.
func set_contact(c: bool):
	_is_contacting = c
	
	Events._player_contact_enemy.emit(c, _direction_attacking, damage)


func _on_animator_animation_finished(anim_name: StringName) -> void:
	if not anim_name == "attack": return
	
	finished_attacking.emit()
	_on_cooldown = false
	
