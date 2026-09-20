extends Node2D
class_name BreakBar

@onready var pixel_progress_bar: PixelProgressBar = $PixelProgressBar

@export var starting_value: float = 100


var can_break_attack: bool = false
var break_max_value: float = 100.0
var break_value: float = 0.0:
	set = set_break_value


func set_break_value(val):
	break_value = clamp(val, 0, break_max_value)
	pixel_progress_bar.set_value(break_value)
	
	if break_value >= break_max_value:
		can_break_attack = true


func _ready() -> void:
	pixel_progress_bar.value = 0
	pixel_progress_bar.max_value = break_max_value
	
	Events.change_players_break_value.connect(_on_change_players_break_value)


func _on_change_players_break_value(c: float):
	break_value += c
