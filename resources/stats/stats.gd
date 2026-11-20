extends Resource
class_name Stats

@warning_ignore_start("unused_signal")

const BASE_LEVEL_XP: float = 100.0

enum BuffableStats {
	MAX_HEALTH,
	ATTACK,
	DEFENSE
}

const STAT_CURVES: Dictionary[BuffableStats, Curve] = {
	BuffableStats.MAX_HEALTH: preload("uid://c74lcglcg0ygq"),
	BuffableStats.ATTACK: preload("uid://c0dqh0qbay0yp"),
	BuffableStats.DEFENSE: preload("uid://bpu75camf85yb"),
}

signal health_depleted 
signal health_changed(cur_health: float, max_health: float)

@export var base_max_health: float = 100.0 
@export var base_defense: float = 100.0
@export var base_attack: float = 35.0
@export var experience: float = 0.0: set = _on_experience_set

var level: float: 
	get(): return floor(max(1.0, sqrt(experience / BASE_LEVEL_XP) + 0.5))
var current_max_health: float = 100.0 
var current_defense: float = 100.0
var current_attack: float = 10.0
var health: float = 0.0: set = _on_health_set
var stat_buffs: Array[StatBuff]

func _on_health_set(new_val: float) -> void:
	health = clampf(new_val, 0, current_max_health)
	if health <= 0: 
		health_depleted.emit() 


func _on_experience_set(new_val: float):
	var old_level: float = level
	experience = new_val
	
	if not old_level == level:
		recalculate_stats()

func _init():
	setup_stats.call_deferred()


func add_buff(buff: StatBuff):
	stat_buffs.append(buff) 
	recalculate_stats.call_deferred()
	

func remove_buff(buff: StatBuff):
	stat_buffs.erase(buff) 
	#recalculate_stats.call_deferred()
	recalculate_stats()


func setup_stats() -> void:
	recalculate_stats()
	health = current_max_health

func recalculate_stats():
	var stat_multipliers: Dictionary = {}  # Amount to multiply included stats by.
	var stat_addends: Dictionary = {}  # Amount to add to included stats.
	
	# Add all buffs together. 
	for buff: StatBuff in stat_buffs:
		var stat_name: String = BuffableStats.keys()[buff.stat].to_lower() 
		match buff.buff_type:
			StatBuff.BuffType.ADD:
				if not stat_addends.has(stat_name):
					stat_addends[stat_name] = 0.0 
				stat_addends[stat_name] += buff.buff_amount
			
			StatBuff.BuffType.MULTIPLY:
				if not stat_multipliers.has(stat_name):
					stat_multipliers[stat_name] = 1.0 
				stat_multipliers[stat_name] += buff.buff_amount
				
				# Remove negative debuff multipliers. 
				#if stat_multipliers[stat_name] < 0.0:
					#stat_multipliers[stat_name] = 0.0 
	
	var stat_sample_pos: float = (level / 100.0) - 0.01
	current_max_health = base_max_health * STAT_CURVES[BuffableStats.MAX_HEALTH].sample(stat_sample_pos)
	current_attack = base_attack * STAT_CURVES[BuffableStats.ATTACK].sample(stat_sample_pos)
	current_defense = base_defense * STAT_CURVES[BuffableStats.DEFENSE].sample(stat_sample_pos)
	
	# Apply buffs.
	for stat_name in stat_multipliers: 
		var cur_property_name: String = str("current_" + stat_name)
		set(cur_property_name, get(cur_property_name) * stat_multipliers[stat_name] )
	
	for stat_name in stat_addends: 
		var cur_property_name: String = str("current_" + stat_name)
		set(cur_property_name, get(cur_property_name) + stat_addends[stat_name] )
																
	
	
	
	
	
	
	
	
	
	
	
	
