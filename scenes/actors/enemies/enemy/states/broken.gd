extends State

@export var broken_duration: int = 4
@onready var broken_timer = $BrokenTimer


func enter(_enter_params = null):
	actor.parried_counter = 0
	actor.animation_player.play("broken") 
	
	# If has enter params, the broken state is indefinite until advised otherwise. 
	# If not, become unbroken after a given duration.
	if _enter_params: 
		return
		
	broken_timer.start(broken_duration)


func _on_broken_timer_timeout():
	transition.emit(self, "thinking") 
	
	
