extends Node
class_name PlayerStateMachine

var states: Dictionary = {}
var current_state: PlayerState 
var disabled: bool = false 

@export var initial_state : PlayerState

var finished_transitioning: bool = true 
	
## Readies the state machine. 
func _ready(): 
	# Prepares all states. 
	for child in get_children(): 
		if child is PlayerState: 
			states[child.name.to_lower()] = child
			child.transition.connect(on_child_transition)


## Call this in the actor of the state machine. 
## Connects the actor to the states. Sets inital state. 
func init(actor):
	for child in get_children(): 
		if child is PlayerState: 
			child.actor = actor
			child.init() 
	
	# Sets initial state. 
	if initial_state: 
		current_state = initial_state
		current_state.enter(null)

				
func _process(delta: float) -> void:
	if disabled: return
	if current_state: current_state.process(delta)


func _physics_process(delta: float) -> void:
	if disabled: return
	if current_state: current_state.physics_process(delta)


func _input(event: InputEvent) -> void:
	if disabled: return
	if current_state: current_state.on_input(event) 


## PlayerState transition. 
## Note: You can't change states from the enter function! 
var is_transitioning := false
var _queued_transition: Dictionary = {}

func on_child_transition(state: PlayerState, new_state_name: String, enter_params = null) -> void:
	if state != current_state:
		return

	var new_state = states.get(new_state_name.to_lower())
	if not new_state:
		return

	if is_transitioning:
		# Something inside enter()/exit() asked for another transition.
		# Don't process it now — just remember the latest request.
		_queued_transition = {"name": new_state_name, "params": enter_params}
		return

	is_transitioning = true

	if current_state:
		current_state.exit()
	current_state = new_state
	new_state.enter(enter_params)

	is_transitioning = false

	if not _queued_transition.is_empty():
		var q = _queued_transition
		_queued_transition = {}
		on_child_transition(current_state, q.name, q.params)



	
	
	
	
