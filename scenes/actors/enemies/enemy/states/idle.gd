extends State


func enter(_enter_params = null):
	await actor.animation_player.animation_finished
	actor.animation_player.play("RESET") 
