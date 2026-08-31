extends Node2D
class_name Player


@onready var arrow_detector_area: Area2D = $ArrowDetectorArea
@onready var player_state_machine: PlayerStateMachine = $PlayerStateMachine
@onready var health_component: Node = $HealthComponent

func _ready() -> void:
	Events.change_players_health.connect(_on_change_players_health)
	player_state_machine.init(self)
	

func _on_change_players_health(change: int):
	health_component.health += change


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
	if not arrow_detector_area.has_overlapping_areas(): return
	
	# An arrow has been pressed and it matches the direction pressed. 
	# Clear that arrow. 
	for arrow: ArrowArea in arrow_detector_area.get_overlapping_areas():
		arrow.triggered.emit(dir) 


@onready var player_atk_basic: PlayerAtkBasic = $PlayerAtkBasic


func _on_health_component_die() -> void:
	self.queue_free()
