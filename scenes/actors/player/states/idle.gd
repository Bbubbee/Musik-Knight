extends PlayerState

func physics_process(_delta: float) -> void:
	# NOTE: Changed all "elif" to "if" to handle concurrent presses. 
	if Input.is_action_just_pressed("left"):
		attack_basic(0)
	if Input.is_action_just_pressed("up"):
		attack_basic(1)
	if Input.is_action_just_pressed("down"):
		attack_basic(2)
	if Input.is_action_just_pressed("right"):
		attack_basic(3)


func attack_basic(dir: int = 0): 
	if not actor.player_atk_basic._on_cooldown: 
		transition.emit(self, "attack", dir)




func on_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		transition.emit(self, "breakattack")
		
