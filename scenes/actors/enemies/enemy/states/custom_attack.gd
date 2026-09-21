extends State



func _ready() -> void:
	Events._enemy_contact_player.connect(_on_enemy_contact_player) 


func enter(_enter_params = null):
	var rand_dir = Constants.get_rand_dir()
	actor._attack_dir = rand_dir
	actor.animation_player.play("attack_"+Constants.get_string_from_dir(rand_dir))


func _on_enemy_contact_player(contacting: bool, _dir: Constants.DIR, _dmg: float):
	if not actor.state_machine.current_state == self: return
	
	if not contacting: return

	var break_attack = [ 
		ArrowAttackData.new().init([3], 0.45, false, 0.0, 600),
		ArrowAttackData.new().init([0], 0.8, false, 0.0, 600),
	]
	Events.attack_break.emit(break_attack, actor)
	
	
	# Await the end of the attack break that was just issued. 
	#var caster: Actor = await Events.attack_break_end
	#if caster == actor:
		#transition.emit(self, "thinking")


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	if not actor.state_machine.current_state == self: return
	
	transition.emit(self, "thinking")
	
