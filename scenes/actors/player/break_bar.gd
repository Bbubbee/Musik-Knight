extends Node2D
class_name BreakBar

var can_break_attack: bool = false

@onready var pixel_progress_bar: PixelProgressBar = $PixelProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pixel_progress_bar.value = 0


func _on_arrow_detector_area_arrow_pressed(grade: int) -> void:
	pixel_progress_bar.value += 5*grade
	
	if pixel_progress_bar.value >= pixel_progress_bar.max_value:
		can_break_attack = true
