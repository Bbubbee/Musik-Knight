extends State


func enter(_enter_params = null):
	var rand_dir = Constants.get_rand_dir()
	actor._attack_dir = rand_dir
	actor.animation_player.play("attack_"+Constants.get_string_from_dir(rand_dir))
	
	# Spawn a break attack arrow.
	
