extends Node2D
class_name Enemy

signal attacked_player(dir: Constants.DIR)

@onready var state_machine: StateMachine = $StateMachine
var parriable: bool = false

var _attack_dir: Constants.DIR


func _ready() -> void:
	state_machine.init(self)


func set_parriable():
	parriable = not parriable


func got_parried():
	var name = state_machine.current_state.name.to_lower()
	print("Parried! State = " + str(name))
	parriable = not parriable
	
	var state = state_machine.current_state
	state.transition.emit(state, "thinking")


		
	


	
