extends State


func enter(_enter_params = null):
	# Attack in a random direction.
	var r_dir = Constants.get_rand_dir()
	Events.attack_basic.emit(r_dir, actor)
