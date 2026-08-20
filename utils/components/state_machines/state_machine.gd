extends Node
class_name StateMachine

var states: Dictionary = {}
var current_state: State 
var disabled: bool = false 

@export var initial_state : State

var finished_transitioning: bool = true 
	
## Readies the state machine. 
func _ready(): 
	# Prepares all states. 
	for child in get_children(): 
		if child is State: 
			states[child.name.to_lower()] = child
			child.transition.connect(on_child_transition)


## Call this in the actor of the state machine. 
## Connects the actor to the states. Sets inital state. 
func init(actor):
	for child in get_children(): 
		if child is State: 
			child.actor = actor
	
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


## State transition. 
## Note: You can't change states from the enter function! 
func on_child_transition(state: State, new_state_name: String, enter_params = null) -> void: 
	finished_transitioning = false
	
	if state != current_state: 
		finished_transitioning = true
		return
	
	# Checks if the new state is invalid. 
	var new_state = states.get(new_state_name.to_lower())
	if not new_state: 
		finished_transitioning = true		
		return
	
	# Leave the current state and go to the next. 
	if current_state: current_state.exit()
	new_state.enter(enter_params)
	current_state = new_state
	
	finished_transitioning = true


## Safe forced transition. 
func force_transition(new_state_name: String, enter_params = null): 	
	# Warning. Ensure finished_transitioning is set to true so this doesn't loop
	# forever. It does so above. 
	var backup = 50
	while not finished_transitioning:
		print("force transition is looping")
		backup -= 1 
		if backup < 0:
			break
	
	current_state.transition.emit(current_state, new_state_name, enter_params)
		
		
		
	
	
	
	
