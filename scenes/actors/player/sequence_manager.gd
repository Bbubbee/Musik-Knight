extends Node
class_name SequenceManager

signal sequence_completed(sequence: Array) 

@onready var sequence_timer: Timer = $ComboTimer

var current_sequence: Array = [] 

var test_sequences = [
	[0, 3, 0],
	[1, 1, 2],
	[2, 1, 2, 2],
	[0, 3, 0, 3]
]


func add_new_attack(dir: int):
	current_sequence.append(dir)
	sequence_timer.start(1)
	
	var sequence_matches: bool = false
	var can_continue: bool = false

	for c in test_sequences:
		# Check if the current sequence is greater than this sequence.
		if current_sequence.size() > c.size():
			continue
		
		# Slice the sequence to compare.
		var sliced_sequence = c.slice(0, current_sequence.size()) 

		# Compare the sliced sequence to the current sequence.
		if sliced_sequence == current_sequence:
			sequence_matches = true
			
			# Check if the sequence can still be extended.
			if current_sequence.size() < c.size():
				can_continue = true
		
	# Execute sequence only if there is a match, and it can't continue. 
	if sequence_matches and not can_continue: 
		var save_current_sequence = current_sequence
		current_sequence = []
		sequence_timer.stop()
		sequence_completed.emit(current_sequence)
		return save_current_sequence
		
	# Reset the sequence only if there are no matches.
	if not sequence_matches:
		sequence_timer.stop()
		
		# When a sequence fails, check if the newest input can be the start of the next sequence.
		if current_sequence.size() > 1:
			current_sequence = []
			add_new_attack(dir)  # WARNING: Recursion.
		else:
			sequence_timer.stop()
			current_sequence = []
	
	return []

	# NOTE: Shorter shorter sequence timer for extended sequences.
	# E.g.: [0, 3, 0] => [0, 3, 0, 3] 
	
	# BUG: NOTE that there are still bugs with this. 
	# E.g. u, d, u, u, d doesn't work. Should trigger u, u, d
	# IDK this should be intended behaviuor. 
	# IDK if the above where it checks if the latest input could start a new sequence
	# should be intended behaviour.
	# NOTE: To revert it, just remove the if/else statement and resent the current sequence
	# size and stop the sequence timer.
	
	
func _on_sequence_timer_timeout() -> void:
	for c in test_sequences:
		if current_sequence == c: 
			sequence_completed.emit(current_sequence)

	current_sequence = []
	pass
	
	
