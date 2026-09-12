extends Actor
class_name Player


@onready var arrow_detector_area: Area2D = $ArrowDetectorArea
@onready var player_state_machine: PlayerStateMachine = $PlayerStateMachine
@onready var health_component: Node = $HealthComponent
@onready var combo_visualiser: Control = $ComboVisualiser

func _ready() -> void:
	Events.change_players_health.connect(_on_change_players_health)
	player_state_machine.init(self)
	combos.sort_custom(func(a, b): return a.size() > b.size())
	

func _on_change_players_health(change: int):
	health_component.health += change


@onready var player_atk_basic: PlayerAtkBasic = $PlayerAtkBasic


func _on_health_component_die() -> void:
	self.queue_free()
	

var combos = [
	[3, 0, 1, 2],
	[0, 3, 0],
	[2, 1, 2, 2],
	[1, 2]
]

var combo_string: Array[Constants.DIR] = []

@onready var possible_combos

#func add_combo_string(_dir: Constants.DIR) -> bool:
	#for combo in combos:
		#if combo_string.size() < combo.size():
			#continue
#
		#var recent_inputs = combo_string.slice(
			#combo_string.size() - combo.size()
		#)
	#return false




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



#
#func add_combo_string_old(dir: Constants.DIR) -> bool:
	#current_inputs.append(dir)
#
	## Check longest combos first
	#for combo in combos:
		#if current_inputs.size() < combo.size():
			#continue
#
		#var recent_inputs = current_inputs.slice(
			#current_inputs.size() - combo.size()
		#)
#
		#if recent_inputs == combo:
			## Before triggering, check if this could be
			## the beginning of a longer combo.
			#for longer_combo in combos:
				#if longer_combo.size() <= combo.size():
					#continue
#
				#if current_inputs.size() >= longer_combo.size():
					#continue
#
				#var possible_start = longer_combo.slice(
					#0,
					#current_inputs.size()
				#)
#
				#if current_inputs == possible_start:
					## Don't trigger yet — wait for more input
					#return false
#
			#current_inputs.clear()
			#return true
#
	#return false
	#
	#var index = combo_string.size()
	#combo_string.append(dir)  # Add new combo dir. 
	#
	## Check each combo.
	#for c in combos:
		## Check each index of the combo string and each combo.
		## If it matches, add combo into possible combos.
		#if combo_string[index] == c[index]:
			#possible_combos.append(dir) 
	#
	#return false 
	#combo_string.append(dir) 
	#combo_visualiser.show_combo(combo_string)
	#
	#
	#var combo_string_continue: bool = false
	#
	## Check if the combo string can be continued.
	#for c in combos:
		#if array_contains_array(c, combo_string):
			#combo_string_continue = true
	#
	## End the combo if the newest attack does not increase the combo.
	#if not combo_string_continue: 
		#
		## If the combo is NOT increased, check if there exists a combo with the combo string.
		## [3, 0, 3, 0] (0, 3, 0 should work)
		#for x in combo_string.size():
			#combo_string.pop_front()
			#
			## Compare the reduced combo string to each combo for any matches. 
			#for c in combos: 
				#if array_contains_array(c, combo_string):
					#return false
		#
		## If the combo is not increased, check if the newest attack matches any combo.
		#combo_string = []
		#
		#for c in combos: 
			#if dir == c[0]: 
				#combo_string.append(dir) 
				#combo_visualiser.show_combo(combo_string)
				#return false
				#
		#combo_visualiser.show_combo(combo_string)
		#return false
	#
	## Check if the combo string matches any combo perfectly. If so, execute combo.
	#for c in combos:
		#if c == combo_string:
			#combo_string = []
			#combo_visualiser.show_combo(combo_string)
			#return true
	#
		#
	#
	#return false
	#
	## BUG: [3, 0, 3, 0] (0, 3, 0 should work)
	## Combo within combo - first combo failed but internal one can continue.
	#
