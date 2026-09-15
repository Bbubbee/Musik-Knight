extends Actor
class_name Player


@onready var arrow_detector_area: Area2D = $ArrowDetectorArea
@onready var player_state_machine: PlayerStateMachine = $PlayerStateMachine
@onready var health_component: Node = $HealthComponent
@onready var combo_visualiser: Control = $ComboVisualiser

func _ready() -> void:
	Events.change_players_health.connect(_on_change_players_health)
	player_state_machine.init(self)
	

func _on_change_players_health(change: int):
	health_component.health += change


@onready var player_atk_basic: PlayerAtkBasic = $PlayerAtkBasic


func _on_health_component_die() -> void:
	self.queue_free()
	



# Checks if an array contains an array, even if one of the array's are shorter.
# The array must match one another sequentially.
func array_contains_array(arr_1: Array, arr_2: Array):
	#print("Comparing: " + str(arr_1) + " and " + str(arr_2))
	
	# Get the smallest array size.
	var size
	if arr_1.size() < arr_2.size():size = arr_1.size()
	else: size = arr_2.size()
	
	for x in range(0, size):
		if not arr_1[x] == arr_2[x]:
			return false
	
	return true
