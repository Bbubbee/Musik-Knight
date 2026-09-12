extends State

@onready var break_attacks = [
		[
			ArrowAttackData.new().init([0], 0.25, true, 3),
			ArrowAttackData.new().init([2, 3], 0.5),
			ArrowAttackData.new().init([3], 0.5),
		]
]

# The problem is, it ceases to exist! 

func _ready() -> void:
	Events.attack_break_end.connect(_on_attack_break_end)
	

func enter(_enter_params = null):
	actor.animation_player.play("special_attack") 
	attack_break()


func attack_break():
	var attk_break = break_attacks.pick_random()
	
	Events.attack_break.emit(attk_break, actor) 
	
	


func _on_attack_break_end(caster: Actor):
	if caster == actor: 
		await get_tree().create_timer(1).timeout
		transition.emit(self, "thinking") 
