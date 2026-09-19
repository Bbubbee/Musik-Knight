extends Area2D

const ARROW_INDICATOR = preload("uid://doubj6sf6gxhr")

signal arrow_pressed(grade: int) 

@onready var arrow_detector_shape: CollisionShape2D = $ArrowDetectorShape
@onready var lanes = ScreenCalculator.get_lanes(Vector2(0, 0), 4) 
@onready var folder_arrow_indicators: Node2D = $FolderArrowIndicators

var held_arrows: Array[Arrow]

func _ready() -> void:
	# Position the arrow detector. 
	var screen_size = get_viewport().get_visible_rect().size
	arrow_detector_shape.global_position.x = screen_size.x/2
	arrow_detector_shape.shape.size.x = screen_size.x - 50
	
	# Spawn in arrow indicators for each lane.
	# These inidicate when an arrow has been pressed.
	for a_i in range(4):
		var arrow_sprite = ARROW_INDICATOR.instantiate() 
		folder_arrow_indicators.add_child(arrow_sprite)
		arrow_sprite.init(a_i, lanes[a_i])
		
	
func _physics_process(_delta: float) -> void:
	
	# NOTE: Changed all "elif" to "if" to handle concurrent presses. 
	if Input.is_action_just_pressed("arrow_left"):
		press_lane(0)
	if Input.is_action_just_pressed("arrow_up"):
		press_lane(1)
	if Input.is_action_just_pressed("arrow_down"):
		press_lane(2)
	if Input.is_action_just_pressed("arrow_right"):
		press_lane(3)
	
	# Checks if a lane has been released. 
	if Input.is_action_just_released("arrow_left"):
		release_lane(0)
	if Input.is_action_just_released("arrow_up"):
		release_lane(1)
	if Input.is_action_just_released("arrow_down"):
		release_lane(2)
	if Input.is_action_just_released("arrow_right"):
		release_lane(3)
	

# Release the arrow if it is being held.
# NOTE: A lane can only be held if it is holding down a held arrow. 
func release_lane(dir: int):
	# Release arrow indicator.
	var arrow_indicator = folder_arrow_indicators.get_child(dir)
	if not arrow_indicator.is_held: return
	arrow_indicator.release_arrow()
	
	# Remove arrow from list of held arrows.
	if held_arrows.is_empty(): return
	# Release any arrows being held.
	for arrow: Arrow in held_arrows:
		if not arrow.direction == dir: continue
		arrow.remove_arrow(arrow_detector_shape.global_position.y)
		held_arrows.erase(arrow)


# An arrow has been pressed. Check if any arrows are in the detector area. 
func press_lane(dir: int = 0) -> void:
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
		if arrow.is_held and not arrow.is_currently_held:
			folder_arrow_indicators.get_child(dir).hold_arrow()
			arrow.handle_held_press()
			held_arrows.append(arrow) 
			continue
		
		## NOT HELD ARROWS:	
		
		# Handle Scoring: 
		var detector_pos_y = arrow_detector_shape.global_position.y
		
		# Grab the position of the center (only y pos).
		var arrow_pos_y = arrow.physics_shape.global_position.y
		
		var dist = abs(detector_pos_y - arrow_pos_y)
	
		var max_dist = arrow.physics_shape.shape.radius/2 + arrow_detector_shape.shape.size.y/2
		
		# Get points based on how close it is to 0. (max is 106 TEMP)
		var grade: int # TEMP: Increase break meter based on how close to 0 the press is.
		if dist < max_dist*0.35:
			Events.spawn_score_indicator.emit(dir, "PERFECT!")
			grade = 3
			
		elif dist < max_dist*0.5:
			Events.spawn_score_indicator.emit(dir, "Great!")
			grade = 2

		elif dist < max_dist*0.75:
			Events.spawn_score_indicator.emit(dir, "Good")
			grade = 1
		
		if arrow.caster is Enemy:
			arrow_pressed.emit(grade) 
		# Clear the arrow.
		arrow.remove_arrow()


# Checks if a body exited is a held arrow.
func _on_body_exited(body: Node2D) -> void:
	# Return if body is NOT an Arrow, and NOT held.
	if not body is Arrow: return 
	var held_arrow = body as Arrow
	if not held_arrow.is_held: return
	
	release_lane(held_arrow.direction)
