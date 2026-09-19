extends PlayerState

@export var damage: float = 200
@export var combo_damage: float = 500



func init() -> void:
	actor.player_attack_basic.finished_attacking.connect(_on_attack_finished)


func enter(_enter_params = null):
	var dir = _enter_params
	var current_combo = actor.combo_manager.add_new_attack(dir) 
	
	var damage_to_deal: float = damage
	if current_combo: damage_to_deal = combo_damage
	actor.player_attack_basic.attack(dir, damage_to_deal) 

	

func _on_attack_finished():
	if actor.player_state_machine.current_state != self: return
	transition.emit(self, "idle") 
