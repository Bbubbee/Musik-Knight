extends PlayerState

func _ready() -> void:
	Events.attack_break_end.connect(_on_attack_break_end)
	

func enter(_enter_params = null):
	attack_break()

func attack_break():	
	
	# The enemy should be stunned during the players attack break.
	# How should this be done? 
	# Enemy wait for the signal? 
	# Attack manager do something about it? 
	
	var attk_break = [
		[
			ArrowAttackData.new().init([0, 1, 3], 0.5),
			ArrowAttackData.new().init([0, 1], 0.5),
			ArrowAttackData.new().init([2], 0.25),
			ArrowAttackData.new().init([1, 2, 0], 0.5),
		],
		[
			ArrowAttackData.new().init([0], 0.25),
			ArrowAttackData.new().init([2, 3], 0.5),
			ArrowAttackData.new().init([3], 0.5),
		],
	].pick_random()
	Events.attack_break.emit(attk_break, actor) 


func _on_attack_break_end(caster: Actor):
	if caster == actor: 
		await get_tree().create_timer(1).timeout
		transition.emit(self, "idle") 
		
