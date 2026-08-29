extends State

@onready var animation_player = $"../../AnimationPlayer"
@onready var parried_timer = $ParriedTimer

func enter(_enter_params = null):
	animation_player.play("parried")
	parried_timer.start(0.6)
	actor.parried_counter += 1 


func process(_delta: float):
	if actor.parried_counter > actor.break_limit: 
		transition.emit(self, "broken")


func _on_parried_timer_timeout():
	transition.emit(self, "thinking") 
