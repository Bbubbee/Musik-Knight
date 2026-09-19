
"""
	READ ME
	
	Requirements: 
		* Set this scene as a Global.
"""

extends CanvasLayer

@onready var animator = $Animator

# @param - target > the file path to the target string
# @param - transition_type > the type of transition. Based on list of animations. 
func change_scene(target: String, transition_type: String = "dissolve") -> void:
	animator.play(transition_type)
	await animator.animation_finished
	get_tree().change_scene_to_file(target) 
	
	animator.play_backwards(transition_type)
