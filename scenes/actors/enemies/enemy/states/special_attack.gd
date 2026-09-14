extends State

@onready var break_attacks = [
	[
		ArrowAttackData.new().init([1], 0.35, true, 0.65),
		ArrowAttackData.new().init([3], 0.7),
		ArrowAttackData.new().init([0], 0.4),
	],
	[
		ArrowAttackData.new().init([0], 0.2,),
		ArrowAttackData.new().init([3], 0.6),
		ArrowAttackData.new().init([0], 0.3),
	],
	[ 
		ArrowAttackData.new().init([3], 0.45),
		ArrowAttackData.new().init([0], 0.8),
		ArrowAttackData.new().init([2], 0.55),
		ArrowAttackData.new().init([2], 0.55),
	]

]

func _ready() -> void:
	Events.attack_break_end.connect(_on_attack_break_end)
	

func enter(_enter_params = null):
	actor.animation_player.play("special_attack") 
	attack_break()


func attack_break():
	var attk_break = break_attacks.pick_random()
	
	Events.attack_break.emit(attk_break, actor) 
	
	
func _on_attack_break_end(caster: Actor):
	if not actor.state_machine.current_state == self:
		return
	
	if caster == actor: 
		await get_tree().create_timer(1).timeout
		transition.emit(self, "thinking") 
