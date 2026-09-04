extends State

func enter(_enter_params = null):
	actor.animation_player.play("RESET") 
	print("idle")


func on_input(event: InputEvent) -> void:
	if event.is_action_pressed("dev_enemy_atk_2"):
		transition.emit(self, "specialattack") 
		
