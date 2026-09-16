extends Node

signal combo_completed(combo: Array) 

@onready var combo_timer: Timer = $ComboTimer

var current_combo: Array = [] 

var test_combos = [
	[0, 3, 0],
	[1, 1, 2],
	[2, 1, 2, 2],
	[0, 3, 0, 3]
]


func add_new_attack(dir: int):
	current_combo.append(dir)
	combo_timer.start(1)
	
	var combo_matches: bool = false
	var can_continue: bool = false

	for c in test_combos:
		# Check if the current combo is greater than this combo.
		if current_combo.size() > c.size():
			continue
	
		# Slice the combo to compare.
		var sliced_combo = c.slice(0, current_combo.size()) 

		# Compare the sliced combo to the current combo.
		if sliced_combo == current_combo:
			combo_matches = true
			
			# Check if the combo can still be extended.
			if current_combo.size() < c.size():
				can_continue = true
		
	# Execute combo only if there is a match, and it can't continue. 
	if combo_matches and not can_continue: 
		print("Execute combo: ", str(current_combo))
		current_combo = []
		combo_timer.stop()
		combo_completed.emit(current_combo)
		
		
	# Reset the combo only if there are no matches.
	if not combo_matches:
		print("Reset combo")
		combo_timer.stop()
		current_combo = []
		
		# NOTE: If a combo fails, should check if can continue.
		# Go backwards in the array, compare against the current combo. For example.
	
	# NOTE: Shorter shorter combo timer for extended combos.
	# E.g.: [0, 3, 0] => [0, 3, 0, 3] 
	

	
func _on_combo_timer_timeout() -> void:
	for c in test_combos:
		if current_combo == c: 
			print("Execute this combo: ", str(current_combo))
			combo_completed.emit(current_combo)
			
		
	current_combo = []
	print("Reset combo")
	pass
	
	
