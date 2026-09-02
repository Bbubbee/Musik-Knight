extends State

@onready var animation_player = $"../../AnimationPlayer"
@onready var thinking_timer = $ThinkingTimer

@export var thinking_length: float = 1

func enter(_enter_params = null):
	animation_player.play("idle")
	thinking_timer.start(thinking_length)


func physics_process(_delta: float):
	# The enemy has been parried a number of times.
	# They have become broken. 
	if actor.parried_counter >= actor.break_limit: 
		transition.emit(self, "broken") 





func on_input(event: InputEvent) -> void:
	if event.is_action_pressed("dev_enemy_atk_2"):
		transition.emit(self, "specialattack") 
		


func _on_thinking_timer_timeout():
	transition.emit(self, "attack") 
