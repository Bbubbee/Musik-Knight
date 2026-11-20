extends Actor
class_name Player

@onready var explosion_particle: GPUParticles2D = $ExplosionParticle
@onready var arrow_detector_area: Area2D = $ArrowDetectorArea
@onready var player_state_machine: PlayerStateMachine = $PlayerStateMachine
@onready var health_component: Node = $HealthComponent
@onready var combo_visualiser: Control = $ComboVisualiser
@onready var combo_manager: SequenceManager = $SequenceManager
@onready var player_attack_basic: PlayerAttackBasic = $PlayerAttackBasic

@export var stats: Stats 


func _ready() -> void:
	Events.change_players_health.connect(_on_change_players_health)
	Events.level_over.connect(_on_level_over)
	player_state_machine.init(self)
	
	#print(stats.current_attack)
	
	var new_buff = StatBuff.new(
			Stats.BuffableStats.ATTACK, 
			2, 
			StatBuff.BuffType.MULTIPLY
		)
	
	#print(new_buff.stat)
	
	stats.add_buff(new_buff) 
	
	
	#print(stats.current_attack)

	
	
	

func _on_change_players_health(change: int):
	health_component.health += change


func _on_health_component_die() -> void:
	Events.someone_died.emit(self) 
	self.queue_free()


func _on_sequence_manager_sequence_completed(_combo: Array) -> void:
	explosion_particle.emitting = true


func _on_level_over():
	var state = player_state_machine.current_state 
	state.transition.emit(state, "gameend")
