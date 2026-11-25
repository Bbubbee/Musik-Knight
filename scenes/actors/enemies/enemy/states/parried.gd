extends State

@onready var animation_player = $"../../AnimationPlayer"
@onready var parried_timer = $ParriedTimer

var previous_state: String

# _enter_params = {"previous_state": String}
func enter(_enter_params = null):
	animation_player.play("parried")
	parried_timer.start(0.6)
	
	if _enter_params: 
		previous_state = _enter_params["previous_state"]

func _on_parried_timer_timeout():
	if previous_state == "comboattack":
		transition.emit(self, "comboattack") 
	else:	
		transition.emit(self, "thinking") 
	

func exit():
	parried_timer.stop()
