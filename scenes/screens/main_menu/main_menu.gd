extends Node2D


func _on_start_button_pressed() -> void:
	SceneTransition.change_scene("res://scenes/levels/get_started/main.tscn", "dissolve")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"): 
		_on_start_button_pressed() 
