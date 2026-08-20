extends Node

@export var max_health: float = 5.0
@onready var health: float = max_health:
	set = set_health

signal die


func set_health(val: float):
	health = clamp(val, 0, max_health)
	
	if health >= 0:
		die.emit()
