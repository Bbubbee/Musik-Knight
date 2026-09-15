extends Actor
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
	
	Events.attack_break.connect(_on_player_break_attack)


# NOTE: Used in animations. 
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


func got_hit(dmg: float):
	var state: String = state_machine.current_state.name.to_lower()

	if state == "broken":
		health_component.health -= dmg
	else: 
		health_component.health -= dmg/2


func _on_health_component_die():
	self.queue_free()
	

func _on_player_break_attack(_attk: Array, caster: Actor): 
	if caster is Enemy: return 
	
	print("player broke attack")
	call_deferred("safe_transition")


func safe_transition():
	pass
