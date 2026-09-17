extends Node2D



func _ready() -> void:
	Events.someone_died.connect(_on_someone_died)


func _on_someone_died(_actor: Actor): 
	print("Someone died", str(_actor)) 
	
	Events.level_over.emit()
