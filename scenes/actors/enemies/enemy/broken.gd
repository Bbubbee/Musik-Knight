extends State

@export var broken_duration: int = 4
@onready var broken_timer = $BrokenTimer


func enter(_enter_params = null):
	broken_timer.start(broken_duration)


func _on_broken_timer_timeout():
	transition.emit(self, "thinking") 
	
