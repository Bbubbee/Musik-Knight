extends State

@export var broken_duration: int = 4
@onready var broken_timer = $BrokenTimer


func enter(_enter_params = null):
	broken_timer.start(broken_duration)
	actor.animation_player.play("parried") 
	actor.parried_counter = 0
	actor.character_sprite.flip_h = true

func exit():
	actor.character_sprite.flip_h = false

func _on_broken_timer_timeout():
	transition.emit(self, "thinking") 
	
	
