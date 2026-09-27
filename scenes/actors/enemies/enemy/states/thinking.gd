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
	# TEMP: control the states using debugger.
	if not Debugger.attack_pattern == null:
		transition.emit(self, Debugger.attack_pattern)
	
	
	# Decide what to do.
	var decision = randi_range(0, 100) 
	
	# Attack.
	if decision <= 75:
		transition.emit(self, "syncattack") 
	
	# Attack.
	if decision <= 90:
		transition.emit(self, "syncattack") 

	# Special (Break) attack.
	elif decision <= 100: 
		transition.emit(self, "syncattack") 


"""
	How should an enemy think? 
	When should a decision be made? Timer? 
	Should the player determine decisions made? 
		Say it's getting hit a lot, it will start attacking instead of idling. 
	
	What decisions can be made?:
		1. Basic atack
		2. Basic string
		3. Break attaack
		4. Idle 
"""
