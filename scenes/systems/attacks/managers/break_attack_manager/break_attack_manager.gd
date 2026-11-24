extends Node2D

var lanes 
const BREAK_ATTACK = preload("uid://k2vmw5r2mhsr")

const ARROW = preload("uid://u8nduxgvfxdr")
@onready var arrows: Node2D = $Arrows


var current_break_attacks: Array[BreakAttack]


func _ready():
	lanes = ScreenCalculator.get_lanes(Vector2(0, 0), 4) 
	Events.attack_break.connect(_on_attack_break) 
	Events.clear_all_attack_breaks.connect(_on_clear_all_attack_breaks)
	

func _on_attack_break(
		attacks: Array, 
		caster: Actor = null, 
		type: Constants.BREAK_TYPE = Constants.BREAK_TYPE.BASIC
	) -> void:		
		

	# Cancel all current break attacks if a player casts a special break attack. 
	# This is already taken care of in _on_clear_all_attack_breaks fyi. 
	if caster is Player and type == Constants.BREAK_TYPE.SPECIAL:
		cancel_current_break_attacks()
		
	# Make a new break attack.
	var new_break_attack: BreakAttack = BREAK_ATTACK.instantiate()	
	current_break_attacks.append(new_break_attack)
	self.add_child(new_break_attack)
	new_break_attack.start(attacks, caster, type)
	new_break_attack.return_outcome.connect(_on_break_attack_return_outcome)
	new_break_attack.done_spawning.connect(_on_break_attack_done_spawning)


func _on_break_attack_done_spawning(break_attack: BreakAttack, success: bool):
	# Don't process this if the break type is special.
	# This must be processed once the break attack has returned an outcome. 
	if break_attack.type == Constants.BREAK_TYPE.SPECIAL: return
	
	if success: 
		Events.attack_break_end.emit(break_attack.caster)


func _on_break_attack_return_outcome(break_attack: BreakAttack, score: int):
	# Don't process this if the break type is basic. Only special break types.
	if break_attack.type == Constants.BREAK_TYPE.BASIC: return
	
	Events.attack_break_completed.emit(score) 


func _on_clear_all_attack_breaks():
	cancel_current_break_attacks()


func cancel_current_break_attacks():
	for c in current_break_attacks:
		c.cancel()
	current_break_attacks = []
