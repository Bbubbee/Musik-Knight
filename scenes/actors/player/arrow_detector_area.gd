extends Area2D

@onready var arrow_detector_shape: CollisionShape2D = $ArrowDetectorShape



	
func _physics_process(_delta: float) -> void:
	
	# NOTE: Changed all "elif" to "if" to handle concurrent presses. 
	if Input.is_action_just_pressed("arrow_left"):
		press_arrow(0)
	if Input.is_action_just_pressed("arrow_up"):
		press_arrow(1)
	if Input.is_action_just_pressed("arrow_down"):
		press_arrow(2)
	if Input.is_action_just_pressed("arrow_right"):
		press_arrow(3)


## An arrow has been pressed. Check if any arrows are in the detector area. 
## @param: dir - the direction of the arrow pressed. 
func press_arrow(dir: int = 0) -> void:
	# Check if detector is colliding with anything. If not, return. 
	if not self.has_overlapping_bodies(): return
	
	# An arrow has been pressed and it matches the direction pressed. 
	# Clear that arrow. 
	for arrow: Arrow in self.get_overlapping_bodies():
		arrow._on_good_zone_area_triggered(dir)
		# Check the distance of the center of the arrow to the center of the detector area.
		
		#print(center_of_detector - arrow.center)
		var detector_pos_y = arrow_detector_shape.global_position.y
		
		# Grab the position of the center (only y pos).
		var arrow_pos_y = arrow.physics_shape.global_position.y
		
		var dist = abs(detector_pos_y - arrow_pos_y)
		print("Distance: " + str(dist))
		
		var max_dist = arrow.physics_shape.shape.radius/2 + arrow_detector_shape.shape.size.y/2
		print("Furthest distance: " + str(max_dist))
		
		# Get points based on how close it is to 0. (max is 106 TEMP)
	
		if dist < max_dist*0.35:
			print("PERFECT!")
			Events.spawn_score_indicator.emit(dir, "PERFECT!")
			
		elif dist < max_dist*0.5:
			print("Great!") 
			Events.spawn_score_indicator.emit(dir, "Great!")

		elif dist < max_dist*0.75:
			print("Good")
			Events.spawn_score_indicator.emit(dir, "Good")



		
		
