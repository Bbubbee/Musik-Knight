extends Node2D
class_name Player

signal attacked_enemy

@onready var arrow_detector_area: Area2D = $ArrowDetectorArea
@onready var pixel_progress_bar: TextureProgressBar = $PixelProgressBar

func _ready() -> void:
	Events.change_players_health.connect(_on_change_players_health)
	

func _on_change_players_health(change: int):
	pixel_progress_bar.deplete(change)


func _physics_process(_delta: float) -> void:
	
	# NOTE: Changed all "elif" to "if" to handle concurrent presses. 
	if Input.is_action_just_pressed("left"):
		press_arrow(0)
		attack_basic(0)
	if Input.is_action_just_pressed("up"):
		press_arrow(1)
		attack_basic(1)
	if Input.is_action_just_pressed("down"):
		press_arrow(2)
		attack_basic(2)
	if Input.is_action_just_pressed("right"):
		press_arrow(3)
		attack_basic(3)


## An arrow has been pressed. Check if any arrows are in the detector area. 
## @param: dir - the direction of the arrow pressed. 
func press_arrow(dir: int = 0) -> void:
	# Check if detector is colliding with anything. If not, return. 
	if not arrow_detector_area.has_overlapping_areas(): return
	
	# An arrow has been pressed and it matches the direction pressed. 
	# Clear that arrow. 
	for arrow: ArrowArea in arrow_detector_area.get_overlapping_areas():
		arrow.triggered.emit(dir) 
	
func attack_basic(dir: int = 0): 
	attacked_enemy.emit()







# TEMP: Break attack
func temp_attack_break():	
	var attk_break = [
		[[0, 1, 3], 0.5],
		[[0, 1], 0.5],
		[2, 0.25],
		[[1, 2, 0], 0.5]
	]
	Events.attack_break.emit(attk_break, "p") 

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		temp_attack_break()

	
