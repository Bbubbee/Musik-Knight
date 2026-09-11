extends Node2D

var test_attack_break = [
	[0, 0.25],
	[1, 0.25],
	[2, 0.25],
	[3, 0.25]
]


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dev_enemy_atk"): 
		print('test')
		Events.attack_break.emit(test_attack_break)
