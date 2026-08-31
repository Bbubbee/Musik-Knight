extends Node2D
class_name Enemy

signal attacked_player(dir: Constants.DIR)
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var character_sprite: Sprite2D = $CharacterSprite
@onready var state_machine: StateMachine = $StateMachine
var parriable: bool = false

var _attack_dir: Constants.DIR

@onready var health_component = $HealthComponent

var parried_counter: int  # The number of times the enemy has been parried.
var break_limit: int = 4  # The number of times 

func _ready() -> void:
	state_machine.init(self)


# Used in animator. 
# Sets wether an enemies attack is parriable or not.
func set_parriable():
	parriable = not parriable


func set_contact(contacting: bool):
	parriable = contacting
	Events._enemy_contact_player.emit(contacting, self._attack_dir)



func got_parried():
	parriable = not parriable
	
	# WARNING: could potentially transition within enter.
	var state = state_machine.current_state
	state.transition.emit(state, "parried")


func got_hit():
	var state: String = state_machine.current_state.name.to_lower()
	
	if state == "broken":
		health_component.health -= 6
	else: 
		health_component.health -= 1


func _on_health_component_die():
	self.queue_free()
