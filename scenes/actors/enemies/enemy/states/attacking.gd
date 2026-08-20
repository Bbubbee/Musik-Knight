extends State

@onready var attack_timer: Timer = $AttackTimer

func enter(_enter_params = null):
	var rand_dir = Constants.get_rand_dir()
	actor.attacked_player.emit(rand_dir)
	
	actor.attack_dir_sprite.visible = true
	actor.attack_dir_sprite.rotation_degrees = Constants.get_rotation_from_dir(rand_dir)
	attack_timer.start()
	

func _on_attack_timer_timeout() -> void:
	actor.attack_dir_sprite.visible = false
	transition.emit(self, "thinking")
