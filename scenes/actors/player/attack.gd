extends PlayerState


func init() -> void:
	actor.player_atk_basic.finished_attacking.connect(_on_attack_finished)


func enter(_enter_params = null):
	var dir = _enter_params
	actor.attacked_enemy.emit(dir)
	actor.player_atk_basic.attack(dir) 


func _on_attack_finished():
	transition.emit(self, "idle") 
