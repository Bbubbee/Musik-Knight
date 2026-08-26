extends State

@onready var animation_player = $"../../AnimationPlayer"
@onready var thinking_timer = $ThinkingTimer

func enter(_enter_params = null):
	animation_player.play("idle")
	thinking_timer.start(1)


func attack_break():
	# Code basic special attack combo.
	var attk_break = [
		[0, 0.5],
		[[0, 1], 0.5],
		[2, 0.25],
		[1, 0.5]
	]
	
	Events.attack_break.emit(attk_break, "e") 


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dev_enemy_atk"):
		attack_break()
		
	if event.is_action_pressed("dev_enemy_atk_2"):
		transition.emit(self, "attacking") 
		


func _on_thinking_timer_timeout():
	transition.emit(self, "attacking") 
