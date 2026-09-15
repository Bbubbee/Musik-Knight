extends PlayerState

@onready var explosion_particle: GPUParticles2D = $ExplosionParticle


func init() -> void:
	actor.player_atk_basic.finished_attacking.connect(_on_attack_finished)


func enter(_enter_params = null):
	var dir = _enter_params
	actor.player_atk_basic.attack(dir, 5) 
	

func _on_attack_finished():
	transition.emit(self, "idle") 
