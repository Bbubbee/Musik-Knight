extends Node2D
@onready var detector_area: Area2D = $DetectorArea


func _physics_process(_delta: float) -> void:
	
	# NOTE: Changed all "elif" to "if" to handle concurrent presses. 
	if Input.is_action_just_pressed("left"):
		press_arrow(0)
	if Input.is_action_just_pressed("up"):
		press_arrow(1)
	if Input.is_action_just_pressed("down"):
		press_arrow(2)
	if Input.is_action_just_pressed("right"):
		press_arrow(3)


"""
	An arrow has been pressed. Check if any arrows are in the detector area. 
	@param: dir - the direction of the arrow pressed. 
"""
func press_arrow(dir: int = 0) -> void:
	# Check if detector is colliding with anything. If not, return. 
	if not detector_area.has_overlapping_areas(): 
		print("No bodies interacting")
		return
	
	# An arrow has been pressed and it matches the direction pressed. 
	# Clear that arrow. 
	for arrow: ArrowArea in detector_area.get_overlapping_areas():
		arrow.triggered.emit(dir) 
	
	
	
