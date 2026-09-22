extends Node2D


func _on_start_button_pressed() -> void:
	SceneTransition.change_scene("res://scenes/levels/get_started/main.tscn", "dissolve")
