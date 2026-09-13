extends Area2D

const ARROW_INDICATOR = preload("uid://doubj6sf6gxhr")

@onready var arrow_detector_shape: CollisionShape2D = $ArrowDetectorShape
@onready var lanes = ScreenCalculator.get_lanes(Vector2(0, 0), 4) 
@onready var folder_arrow_indicators: Node2D = $FolderArrowIndicators

var held_arrows: Array[int]

func _ready() -> void:
	# Position the arrow detector. 
	var screen_size = get_viewport().get_visible_rect().size
	arrow_detector_shape.global_position.x = screen_size.x/2
	arrow_detector_shape.shape.size.x = screen_size.x - 50
	
	# Spawn in arrow indicators for each lane.
	for x in range(4):
		var arrow_sprite = ARROW_INDICATOR.instantiate() 
		folder_arrow_indicators.add_child(arrow_sprite)
		arrow_sprite.init(x, lanes[x])
		
	
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
	
	
	# NOTE: Changed all "elif" to "if" to handle concurrent presses. 
	if Input.is_action_just_released("arrow_left"):
		release_arrow(0)
	if Input.is_action_just_released("arrow_up"):
		release_arrow(1)
	if Input.is_action_just_released("arrow_down"):
		release_arrow(2)
	if Input.is_action_just_released("arrow_right"):
		release_arrow(3)
	
	
func release_arrow(dir: int):
	held_arrows.erase(dir) 
	
	for a in folder_arrow_indicators.get_children():
		if a.dir == dir: 
			# TODO: How come every direction is 0!?
			print(a.dir)
			a.release_arrow()
	
	# Check all indicators? But we need reference of what is held here anyways so. 

## An arrow has been pressed. Check if any arrows are in the detector area. 
## @param: dir - the direction of the arrow pressed. 
func press_arrow(dir: int = 0) -> void:
	# Indicate that a directional arrow has been pressed. 
	folder_arrow_indicators.get_child(dir).press_arrow()
	
	# Check if the detector is colliding with anything. If not, return. 
	if not self.has_overlapping_bodies(): return
	
	# TODO: Only handle the arrows that are closest to the players detector area.
	
	# An Arrow has been pressed. Check if it's the correct direction.
	# WARNING: Doesn't check for only Arrow bodies.
	for arrow: Arrow in self.get_overlapping_bodies():		
		
		# Check if the arrow pressed matches the direction of the arrow.
		if not arrow.direction == dir: continue
		
		## HELD ARROWS:
		if arrow.is_held:
			print('hold me day')
			held_arrows.append(dir) 
			folder_arrow_indicators.get_child(dir).hold_arrow()
		
			continue
		
		## NOT HELD ARROWS:	
		
		# Handle Scoring: 
		
		# Check the distance of the center of the arrow to the center of the detector area.
		var detector_pos_y = arrow_detector_shape.global_position.y
		
		# Grab the position of the center (only y pos).
		var arrow_pos_y = arrow.physics_shape.global_position.y
		
		var dist = abs(detector_pos_y - arrow_pos_y)
		#print("Distance: " + str(dist))
		
		var max_dist = arrow.physics_shape.shape.radius/2 + arrow_detector_shape.shape.size.y/2
		#print("Furthest distance: " + str(max_dist))
		
		# Get points based on how close it is to 0. (max is 106 TEMP)
		if dist < max_dist*0.35:
			Events.spawn_score_indicator.emit(dir, "PERFECT!")
			
		elif dist < max_dist*0.5:
			Events.spawn_score_indicator.emit(dir, "Great!")

		elif dist < max_dist*0.75:
			Events.spawn_score_indicator.emit(dir, "Good")
		
		# Clear the arrow.
		arrow.remove_arrow()



		
		
