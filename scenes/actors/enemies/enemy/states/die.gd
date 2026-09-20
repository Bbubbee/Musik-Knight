extends State


func enter(_enter_params = null):
	Events.someone_died.emit(actor) 
	
	actor.animation_player.play("death") 
	actor.pixel_progress_bar.hide()
	await get_tree().create_timer(5).timeout
	actor.queue_free()
	


# WARNING: If an attack break is pressed past the temp timer, it will crash.
# You can check for an attack break to end here if you like.
