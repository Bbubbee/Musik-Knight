extends Actor
class_name Player

@onready var explosion_particle: GPUParticles2D = $ExplosionParticle
@onready var arrow_detector_area: Area2D = $ArrowDetectorArea
@onready var player_state_machine: PlayerStateMachine = $PlayerStateMachine
@onready var health_component: Node = $HealthComponent
@onready var combo_visualiser: Control = $ComboVisualiser
@onready var combo_manager: Node = $ComboManager

func _ready() -> void:
	Events.change_players_health.connect(_on_change_players_health)
	player_state_machine.init(self)
	

func _on_change_players_health(change: int):
	health_component.health += change


@onready var player_atk_basic: PlayerAtkBasic = $PlayerAtkBasic


func _on_health_component_die() -> void:
	self.queue_free()
	

func new_basic_attack(dir: int):
	combo_manager.add_new_attack(dir) 


func _on_combo_manager_combo_completed(_combo: Array) -> void:
	explosion_particle.emitting = true
