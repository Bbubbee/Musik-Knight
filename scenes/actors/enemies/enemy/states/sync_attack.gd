extends State

# Sync between basic and arrow attack.


var timer: float = 0.0
@export var attack_timer: float = 0.5
var attack_timer_done: bool = false
@export var break_attack_timer: float = 0.1
var break_attack_timer_done: bool = false


func enter(_enter_params = null):
	# Choose random direction to attack.
	var rand_dir = Constants.get_rand_dir() 
	actor._attack_dir = rand_dir
	
	# Test syncing with a timer first. 


func physics_process(_delta: float):
	timer += _delta 
	
	if timer >= attack_timer and not attack_timer_done:
		attack_timer_done = true
		actor.animation_player.play("attack_"+Constants.get_string_from_dir(actor._attack_dir))
		
		
	if timer >= break_attack_timer and not break_attack_timer_done:
		break_attack_timer_done = true
		
		var opposite_dir = Constants.get_opposite_dir(actor._attack_dir)
		var break_attack = [ArrowAttackData.new().init([opposite_dir], 0.8, false, 0.0, 1000)]
		Events.attack_break.emit(break_attack, actor)
		

func exit():
	timer = 0 
	attack_timer_done = false
	break_attack_timer_done = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if not actor.state_machine.current_state == self: return
	
	if not anim_name.contains("attack"):
		return
		
	transition.emit(self, "thinking")


#func _on_sync_timer_timeout() -> void:
