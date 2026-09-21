extends State


@onready var animation_player = $"../../AnimationPlayer"


func enter(_enter_params = null):
	var rand_dir = Constants.get_rand_dir()
	actor._attack_dir = rand_dir
	animation_player.play("attack_"+Constants.get_string_from_dir(rand_dir))
	
	
func _on_animation_player_animation_finished(_anim_name):
	if not actor.state_machine.current_state == self: return
	actor.parried_counter -= 1
	transition.emit(self, "thinking")
