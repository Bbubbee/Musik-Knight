extends Node2D
class_name Level

@warning_ignore_start("unused_signal")

signal change_level(level_path: String, enter_params)


func init(enter_params): 
	if enter_params: 
		print("Hey! I have enter params.")
