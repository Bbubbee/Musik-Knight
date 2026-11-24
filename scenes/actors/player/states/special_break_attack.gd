extends PlayerState

@onready var break_bar: BreakBar = $BreakBar
@onready var break_menu: BreakMenu = $BreakMenu


var attack_breaks = [
		[
			ArrowAttackData.new().init([0, 1, 3], 0.5, false, 0.0, 700, 16),
			ArrowAttackData.new().init([0, 1], 0.5, false, 0.0, 700, 16),
			ArrowAttackData.new().init([2], 0.25, false, 0.0, 700, 16),
			ArrowAttackData.new().init([1, 2, 0], 0.5, false, 0.0, 700, 16),
		],
		[
			ArrowAttackData.new().init([0], 0.25, false, 0.0, 700, 16),
			ArrowAttackData.new().init([0], 0.25, false, 0.0, 700, 16),
			ArrowAttackData.new().init([3], 0.25, false, 0.0, 700, 16),
			ArrowAttackData.new().init([0], 0.25, false, 0.0, 700, 16),
			ArrowAttackData.new().init([1], 0.25, true, 0.5, 700, 16),
			ArrowAttackData.new().init([2], 0.25, false, 0.0, 700, 16),
			ArrowAttackData.new().init([2], 0.15, false, 0.0, 700, 16),
		],
	]
	

func enter(_enter_params = null):
	if not break_bar.can_break_attack: 
		transition.emit(self, "idle")
		return
	
	attack_break()

func attack_break():	
	Events.clear_all_attack_breaks.emit()
	break_menu.choose_break_ability()
	var _ability = await break_menu.option_chosen
	
	break_bar.reset_break_bar()
	Events.attack_break.emit(attack_breaks.pick_random(), actor, Constants.BREAK_TYPE.SPECIAL) 
	
	# The special attack break has been completed by the player. 
	# Determine the outcome of the 
	var _score = await Events.attack_break_completed
	
	if _ability == "Heal": 
		Events.change_players_health.emit(75)
	elif _ability == "Buff":
		actor.stats.add_buff(StatBuff.new(Stats.BuffableStats.ATTACK, 1.65, StatBuff.BuffType.MULTIPLY))
	elif _ability == "Damage":
		Events.change_enemies_health.emit(-80)
	elif _ability == "Debuff":
		Events.change_enemies_health.emit(-80)

	
	# Resume playing from the special break attack.
	Events.pause_game.emit(false) 
	transition.emit(self, "idle") 
	
	

		
