extends PlayerState

@export var attack_controller: AttackController

# Buff: 
#StatBuff.new(Stats.BuffableStats.ATTACK, 2, StatBuff.BuffType.MULTIPLY)

func init() -> void:
	actor.player_attack_basic.finished_attacking.connect(_on_attack_finished)
	
	if attack_controller:
		attack_controller.attack_finished.connect(_on_attack_finished)


func enter(_enter_params = null):
	var dir = _enter_params
	var current_combo = actor.combo_manager.add_new_attack(dir) 
	
	var damage_to_deal: float = actor.stats.current_attack
	print(actor.stats.current_attack)
	if current_combo: damage_to_deal = damage_to_deal * 3
	attack_controller.attack(dir, damage_to_deal)


func _on_attack_finished():
	if actor.player_state_machine.current_state != self: return
	Events.change_players_break_value.emit(4)
	transition.emit(self, "idle") 
	
