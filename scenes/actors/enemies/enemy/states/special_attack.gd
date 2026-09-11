extends State

var break_attacks = [
	[
		[[0, 1], 0.5],
		[1, 0.25],
		[[2, 3], 0.25],
		[1, 0.5]
	],
	
	[
		[0, 0.5],
		[[0, 1], 0.5],
		[2, 0.25],
		[1, 0.5]
	],
	
	[
		[0, 0.25],
		[1, 0.25],
		[2, 0.25],
		[3, 0.25]
	]
]

func _ready() -> void:
	Events.attack_break_end.connect(_on_attack_break_end)
	

func enter(_enter_params = null):
	actor.animation_player.play("special_attack") 
	attack_break()

func attack_break():
	# Code basic special attack combo.
	var attk_break = break_attacks.pick_random()
	
	Events.attack_break.emit(attk_break, actor) 


func _on_attack_break_end(caster: Actor):
	if caster == actor: 
		await get_tree().create_timer(1).timeout
		transition.emit(self, "thinking") 
		


	
