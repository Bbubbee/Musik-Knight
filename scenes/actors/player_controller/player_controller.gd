extends Node2D
@onready var detector_area: Area2D = $DetectorArea


func _physics_process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("left"):
		press_arrow(0)
	elif Input.is_action_just_pressed("up"):
		press_arrow(1)
	elif Input.is_action_just_pressed("down"):
		press_arrow(2)
	elif Input.is_action_just_pressed("right"):
		press_arrow(3)


func press_arrow(dir: int = 0):
	# Check if area is colliding with anything. If not, return. 
	if not detector_area.has_overlapping_bodies(): 
		print("No bodies interacting")
		return
	
	for arrow: Arrow in detector_area.get_overlapping_bodies():
		if dir == arrow.direction:
			arrow.queue_free()
	
	
	
