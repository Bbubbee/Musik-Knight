extends Actor
class_name Player

@onready var explosion_particle: GPUParticles2D = $ExplosionParticle
@onready var arrow_detector_area: Area2D = $ArrowDetectorArea
@onready var player_state_machine: PlayerStateMachine = $PlayerStateMachine
@onready var health_component: Node = $HealthComponent
@onready var combo_visualiser: Control = $ComboVisualiser
@onready var combo_manager: ComboManager = $ComboManager
@onready var player_attack_basic: PlayerAttackBasic = $PlayerAttackBasic


func _ready() -> void:
	Events.change_players_health.connect(_on_change_players_health)
	Events.level_over.connect(_on_level_over)
	player_state_machine.init(self)
	

func _on_change_players_health(change: int):
	health_component.health += change


func _on_health_component_die() -> void:
	Events.someone_died.emit(self) 
	self.queue_free()


func _on_combo_manager_combo_completed(_combo: Array) -> void:
	explosion_particle.emitting = true


func _on_level_over():
	var state = player_state_machine.current_state 
	state.transition.emit(state, "gameend")
