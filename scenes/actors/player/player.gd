extends Node2D
class_name Player

signal attacked_enemy
signal _is_attack_contacting_enemy(bool)

@onready var arrow_detector_area: Area2D = $ArrowDetectorArea
@onready var pixel_progress_bar: TextureProgressBar = $PixelProgressBar
@onready var player_state_machine: PlayerStateMachine = $PlayerStateMachine

func _ready() -> void:
	Events.change_players_health.connect(_on_change_players_health)
	player_state_machine.init(self)
	

func _on_change_players_health(change: int):
	pixel_progress_bar.deplete(change)


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


## An arrow has been pressed. Check if any arrows are in the detector area. 
## @param: dir - the direction of the arrow pressed. 
func press_arrow(dir: int = 0) -> void:
	# Check if detector is colliding with anything. If not, return. 
	if not arrow_detector_area.has_overlapping_areas(): return
	
	# An arrow has been pressed and it matches the direction pressed. 
	# Clear that arrow. 
	for arrow: ArrowArea in arrow_detector_area.get_overlapping_areas():
		arrow.triggered.emit(dir) 


@onready var player_atk_basic: PlayerAtkBasic = $PlayerAtkBasic

	
# NOTE: Needed. Used in attack manager
func got_attacked_basic():
	pass
	
