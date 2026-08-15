extends Node2D

signal attack(a: Array)

	
func special_attack():
	# Code basic special attack combo.
	var special_atk = [
		[0, 0.5],
		[[0, 1], 0.5],
		[2, 0.25],
		[1, 0.5]
	]
	
	attack.emit(special_atk) 

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dev_enemy_atk"):
		special_attack()
	
