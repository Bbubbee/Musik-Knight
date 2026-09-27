extends Node
class_name LevelManager

"""
	Dependencies: 
		* intial level must be String of path of level. 
			Level must of type Level (see BaseLevel) 
			
"""

@export var intial_level: String = "res://scenes/levels/get_started/main.tscn"

@onready var animator: AnimationPlayer = $LevelTransition/Animator

@onready var main_level: Node2D = $MainLevel  # Holds the current_level node.
var current_level: Level


# NOTE: Commented these 2 functions because of changes in paramater types.
func _ready() -> void:
	initialise_level(intial_level)

func initialise_level(level_path: String):
	var level_resource := load(level_path)
	if level_resource:
		current_level = level_resource.instantiate() 
		if current_level.has_signal("change_level"):
			current_level.change_level.connect(change_level)
		main_level.call_deferred('add_child', current_level)

func unload_level(): 
	if is_instance_valid(current_level): 
		current_level.queue_free()
		current_level.change_level.disconnect(change_level)
	current_level = null

func change_level(level_path: String, enter_params = null): 
	animator.play("dissolve")
	await animator.animation_finished
	unload_level()
	
	var level_resource := load(level_path)
	if level_resource:
		current_level = level_resource.instantiate() 
		current_level.change_level.connect(change_level)
		call_deferred('transition_level', enter_params)

		animator.play_backwards("dissolve")

# Call this deferred to allow all items to safely queue free,
# and all nodes to load before enter_params are initialised.
func transition_level(enter_params = null):
	main_level.add_child(current_level) 
	
	# Enter params. 
	if enter_params:
		current_level.init(enter_params) 
