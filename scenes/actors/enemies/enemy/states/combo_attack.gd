extends State

var temp_combo = [0, 0, 3]
var temp_i: int = 0


func enter(_enter_params = null):
	actor.attack(temp_combo[temp_i])


func _on_animation_player_animation_finished(_anim_name):
	if not actor.state_machine.current_state == self: return
	
	temp_i += 1
	
	if temp_i >= temp_combo.size(): transition.emit(self, "thinking")
	else: actor.attack(temp_combo[temp_i])
	
	# TODO: Make it so that, after parry, it continues with the current combo.

	
func exit():
	temp_i = 0
	
