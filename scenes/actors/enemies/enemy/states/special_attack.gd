extends State

func enter(_enter_params = null):
	actor.animation_player.play("special_attack") 
	attack_break()


func physics_process(_delta: float):
	await get_tree().create_timer(2.0).timeout
	transition.emit(self, "thinking") 
	
	
func attack_break():
	# Code basic special attack combo.
	var attk_break = [
		[0, 0.5],
		[[0, 1], 0.5],
		[2, 0.25],
		[1, 0.5]
	]
	
	Events.attack_break.emit(attk_break, "e") 
