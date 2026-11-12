extends PlayerState

@onready var break_bar: BreakBar = $BreakBar
@onready var break_menu: BreakMenu = $BreakMenu


var attack_breaks = [
		[
			ArrowAttackData.new().init([0, 1, 3], 0.5, false, 0.0, 700, 30),
			ArrowAttackData.new().init([0, 1], 0.5, false, 0.0, 700, 30),
			ArrowAttackData.new().init([2], 0.25, false, 0.0, 700, 30),
			ArrowAttackData.new().init([1, 2, 0], 0.5, false, 0.0, 700, 30),
		],
		[
			ArrowAttackData.new().init([0], 0.25, false, 0.0, 700, 30),
			ArrowAttackData.new().init([0], 0.25, false, 0.0, 700, 30),
			ArrowAttackData.new().init([3], 0.25, false, 0.0, 700, 30),
			ArrowAttackData.new().init([0], 0.25, false, 0.0, 700, 30),
			ArrowAttackData.new().init([1], 0.25, true, 0.5, 700, 30),
			ArrowAttackData.new().init([2], 0.25, false, 0.0, 700, 30),
			ArrowAttackData.new().init([2], 0.15, false, 0.0, 700, 30),
		],
	]


func _ready() -> void:
	Events.attack_break_end.connect(_on_attack_break_end)
	

func enter(_enter_params = null):
	if not break_bar.can_break_attack: 
		transition.emit(self, "idle")
		return
	
	attack_break()

func attack_break():	
	break_menu.choose_break_ability()
	print('yo')
	await break_menu.option_chosen
	
	break_bar.break_value = 0
	break_bar.can_break_attack = false
	
	Events.attack_break.emit(attack_breaks.pick_random(), actor) 


func _on_attack_break_end(caster: Actor):
	if caster == actor: 
		await get_tree().create_timer(1).timeout
		transition.emit(self, "idle") 
		
