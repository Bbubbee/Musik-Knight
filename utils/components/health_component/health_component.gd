extends Node

"""
	This health component can work in tandem with a PixelProgressBar.
	It will update it accordingly should it be linked to the export
	variable below.
"""

# Optional
@export var pixel_progress_bar: PixelProgressBar

@export var max_health: float = 100
@onready var health: float = max_health:
	set = set_health

signal die

func _ready():
	if pixel_progress_bar:
		pixel_progress_bar.max_value = max_health
		pixel_progress_bar.value = max_health


func set_health(val: float):
	health = clamp(val, 0, max_health)
	
	if pixel_progress_bar:
		pixel_progress_bar.set_value(health)
	
	if health <= 0:
		die.emit()
	
	
