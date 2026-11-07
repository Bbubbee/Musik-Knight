extends Node2D
class_name AttackController

signal attack_finished

@onready var animator: AnimationPlayer = $Animator

# Wether or not the attack is contacting a target.
var _is_contacting: bool
var _direction_attacking: Constants.DIR
var _on_cooldown: bool
var damage: float 

"""
	
"""
func attack(dir: Constants.DIR, d: float):
	_direction_attacking = dir
	_on_cooldown = true
	damage = d 

	
	if dir == Constants.DIR.LEFT:
		animator.play("attack_left")
	elif dir == Constants.DIR.RIGHT:
		animator.play("attack_right")
	elif dir == Constants.DIR.UP:
		animator.play("attack_up")
	elif dir == Constants.DIR.DOWN:
		animator.play("attack_down")


func set_contact(c: bool):
	_is_contacting = c
	
	Events._player_contact_enemy.emit(c, _direction_attacking, damage)
	

func _on_animator_animation_finished(_anim_name: StringName) -> void:
	attack_finished.emit() 
	animator.play("RESET")
