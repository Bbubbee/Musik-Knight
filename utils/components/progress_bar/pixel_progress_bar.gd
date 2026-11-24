extends TextureProgressBar
class_name PixelProgressBar

@export var stats: Stats


func _ready():
	value = max_value
	
	if stats: 
		stats.health_changed.connect(_on_health_changed)
		print(stats.health_changed.get_connections())

var is_active: bool = false

func deplete(change: float): 
	value -= change

func replenish(change: float): 
	value += change

func _on_health_changed(cur_health: float, max_health: float):
	print("signal works")
