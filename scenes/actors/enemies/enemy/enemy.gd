extends Actor
class_name Enemy

@export var break_limit: int = 4  # The number of times needed to be parried to be broken.
@export var parry_refresh_length: float = 6
@export var attack_damage: float = 30

@onready var parry_refresh_timer: Timer = $ParryRefreshTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var character_sprite: Sprite2D = $CharacterSprite
@onready var state_machine: StateMachine = $StateMachine
@onready var pixel_progress_bar: PixelProgressBar = $PixelProgressBar
@onready var health_component = $HealthComponent

var _attack_dir: Constants.DIR
var parried_counter: int:  # The number of times the enemy has been parried.
	set(val):
		parried_counter = max(0, val) 
var is_dead: bool = false


func _ready() -> void:
	state_machine.init(self)
	
	Events.attack_break.connect(_on_player_break_attack)
	Events.change_enemies_health.connect(_on_change_enemies_health)
	Events.parried_enemy.connect(_on_got_parried)
	Events.level_over.connect(_on_level_over)


# NOTE: Used in animations. 
func set_contact(contacting: bool):
	Events._enemy_contact_player.emit(contacting, self._attack_dir, self.attack_damage)
	

func _on_got_parried(success: bool):
	# TEMP: Handle parry. Either go to parried or broken state.
	# WARNING: could potentially transition within enter.
	if success:
		self.parry_refresh_timer.start(parry_refresh_length)
		self.parried_counter += 1 
		var state = state_machine.current_state
		if self.parried_counter >= break_limit:
			state.transition.emit(state, "broken")
		else:
			state.transition.emit(state, "parried")


func _on_health_component_die():
	is_dead = true
	var state = state_machine.current_state
	state.transition.emit(state, "die")


func _on_player_break_attack(_attk: Array, caster: Actor): 
	if caster is Enemy: return 
	
	var state = state_machine.current_state
	state.transition.emit(state, "broken")


func _on_change_enemies_health(change: float):
	if is_dead: return
	
	var state: String = state_machine.current_state.name.to_lower()

	if state == "broken":
		health_component.health += change
	else: 
		health_component.health += change/2


# The level is over. 
# Go to the idle state. 
# This is likely to be called if the enemy slays the player.
func _on_level_over():
	if is_dead: return
	print(state_machine.current_state)
	var state = state_machine.current_state
	state.transition.emit(state, "idle") 


func _on_parry_refresh_timer_timeout() -> void:
	parry_refresh_timer.start(parry_refresh_length)
	self.parried_counter -= 1
	
