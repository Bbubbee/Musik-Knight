extends Node2D
class_name BreakMenu

@onready var timer: Timer = $Timer

signal option_chosen 


func choose_break_ability():
	print("pause game")
	timer.start(1)


func _on_timer_timeout() -> void:
	option_chosen.emit()
