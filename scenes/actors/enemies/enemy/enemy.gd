extends Node2D
class_name Enemy

signal attacked_player

@onready var state_machine: StateMachine = $StateMachine

func _ready() -> void:
	state_machine.init(self)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dev_enemy_atk_2"):
		attacked_player.emit()
	


	
