extends Node2D
class_name Enemy

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var character_sprite: Sprite2D = $CharacterSprite
@onready var state_machine: StateMachine = $StateMachine

var _attack_dir: Constants.DIR

@onready var health_component = $HealthComponent

var parried_counter: int  # The number of times the enemy has been parried.
@export var break_limit: int = 4  # The number of times needed to be parried to be broken.


func _ready() -> void:
	state_machine.init(self)


func set_contact(contacting: bool):
	Events._enemy_contact_player.emit(contacting, self._attack_dir)
	

func got_parried():
	# TEMP: Handle parry. Either go to parried or broken state.
	# WARNING: could potentially transition within enter.
	self.parried_counter += 1 
	var state = state_machine.current_state
	if self.parried_counter >= break_limit:
		state.transition.emit(state, "broken")
	else:
		state.transition.emit(state, "parried")


func got_hit():
	var state: String = state_machine.current_state.name.to_lower()
	
	if state == "broken":
		health_component.health -= 8
	else: 
		health_component.health -= 1


func _on_health_component_die():
	self.queue_free()
