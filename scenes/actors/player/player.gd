extends Actor
class_name Player


@onready var arrow_detector_area: Area2D = $ArrowDetectorArea
@onready var player_state_machine: PlayerStateMachine = $PlayerStateMachine
@onready var health_component: Node = $HealthComponent

func _ready() -> void:
	Events.change_players_health.connect(_on_change_players_health)
	player_state_machine.init(self)
	

func _on_change_players_health(change: int):
	health_component.health += change


@onready var player_atk_basic: PlayerAtkBasic = $PlayerAtkBasic


func _on_health_component_die() -> void:
	self.queue_free()
