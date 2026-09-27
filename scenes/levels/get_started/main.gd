extends Level

func _ready() -> void:
	if self.has_signal("change"):
		print("hae change level")
