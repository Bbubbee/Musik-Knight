extends TextureProgressBar
class_name PixelProgressBar

func _ready():
	value = max_value

var is_active: bool = false

func deplete(change: float): 
	value -= change

func replenish(change: float): 
	value += change
