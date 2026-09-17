extends Actor
class_name Enemy

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var character_sprite: Sprite2D = $CharacterSprite
@onready var state_machine: StateMachine = $StateMachine
@onready var pixel_progress_bar: PixelProgressBar = $PixelProgressBar

var _attack_dir: Constants.DIR

@onready var health_component = $HealthComponent

var parried_counter: int  # The number of times the enemy has been parried.
@export var break_limit: int = 4  # The number of times needed to be parried to be broken.


func _ready() -> void:
	state_machine.init(self)
	
	Events.attack_break.connect(_on_player_break_attack)
	Events.change_enemies_health.connect(_on_change_enemies_health)
	Events.parried_enemy.connect(_on_got_parried)
	Events.level_over.connect(_on_level_over)


# NOTE: Used in animations. 
func set_contact(contacting: bool):
	Events._enemy_contact_player.emit(contacting, self._attack_dir)
	

func _on_got_parried():
	# TEMP: Handle parry. Either go to parried or broken state.
	# WARNING: could potentially transition within enter.
	self.parried_counter += 1 
	var state = state_machine.current_state
	if self.parried_counter >= break_limit:
		state.transition.emit(state, "broken")
	else:
		state.transition.emit(state, "parried")


func _on_health_component_die():
	var state = state_machine.current_state
	state.transition.emit(state, "die")

func _on_player_break_attack(_attk: Array, caster: Actor): 
	if caster is Enemy: return 
	
	var state = state_machine.current_state
	state.transition.emit(state, "broken")


func _on_change_enemies_health(change: float):
	var state: String = state_machine.current_state.name.to_lower()

	if state == "broken":
		health_component.health += change
	else: 
		health_component.health += change/2


func _on_level_over():
	var state = state_machine.current_state
	state.transition.emit(state, "idle") 
