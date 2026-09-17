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
		current_combo = []
		combo_timer.stop()
		combo_completed.emit(current_combo)
		
	# Reset the combo only if there are no matches.
	if not combo_matches:
		combo_timer.stop()
		
		# When a combo fails, check if the newest input can be the start of the next combo.
		if current_combo.size() > 1:
			current_combo = []
			add_new_attack(dir)  # WARNING: Recursion.
		else:
			combo_timer.stop()
			current_combo = []

	# NOTE: Shorter shorter combo timer for extended combos.
	# E.g.: [0, 3, 0] => [0, 3, 0, 3] 
	
	# BUG: NOTE that there are still bugs with this. 
	# E.g. u, d, u, u, d doesn't work. Should trigger u, u, d
	# IDK this should be intended behaviuor. 
	# IDK if the above where it checks if the latest input could start a new combo
	# should be intended behaviour.
	# NOTE: To revert it, just remove the if/else statement and resent the current combo
	# size and stop the combo timer.
	

	
func _on_combo_timer_timeout() -> void:
	for c in test_combos:
		if current_combo == c: 
			combo_completed.emit(current_combo)

	current_combo = []
	pass
	
	
