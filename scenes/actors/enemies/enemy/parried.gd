extends State

@onready var animation_player = $"../../AnimationPlayer"
@onready var parried_timer = $ParriedTimer

func enter(_enter_params = null):
	animation_player.play("parried")
	parried_timer.start(0.6)


func _on_parried_timer_timeout():
	transition.emit(self, "thinking") 
