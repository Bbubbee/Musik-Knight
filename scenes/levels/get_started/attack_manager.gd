extends Node2D

@onready var arrows = $Arrows

@export var player: Player
@export var enemy: Enemy 

const ARROW = preload("uid://u8nduxgvfxdr")

var lanes: Array[int]

func _ready():
	lanes = ScreenCalculator.get_lanes(Vector2(0, 0), 4) 
	
	Events.attack_break.connect(_on_attack_break) 
	Events._player_contact_enemy.connect(_on_player_contact_enemy) 
	Events._enemy_contact_player.connect(_on_enemy_contact_player) 
	
 
	
	
## Initiate an attack break. [attk]
func _on_attack_break(attk: Array, caster: String) -> void:	
	# Spawn an arrow for each part of the attack.
	for x: Array in attk:
		# Multi attack: 
		if x[0] is Array: for y in x[0]: spawn_arrow(y, caster)
		# Singular attack:
		else: spawn_arrow(x[0], caster)
			
		# Wait a given amount of time until the next attack.
		await get_tree().create_timer(x[1]).timeout
		# NOTE: Should this be recursive? 
	
	
## Spawns an arrow in a lane. The arrow will spawn.
func spawn_arrow(lane: int, caster: String):
	var x_pos: int = lanes[lane] 
	var y_pos: int 
	
	# Change the move direction of the attack based on the caster.
	if caster == "p": 
		y_pos = get_viewport().get_visible_rect().size.y
		
	elif caster == "e":
		y_pos = -30

	# Create the arrow. 
	var arrow: Arrow = ARROW.instantiate()
	arrow.position.y = y_pos
	arrow.position.x = x_pos
	arrows.add_child(arrow) 
	arrow.init(lane, caster) 


## An arrow has entered the players damage area.
## Damage the player. 
func _on_damage_player_area_body_entered(body: Node2D) -> void:
	# The body is not an arrow.
	if body is not Arrow: return
	
	# The body is an arrow.
	var arrow = body as Arrow 
	
	# Only damage the player if the caster of the arrow is an enemy.
	# Prevents the player from damaging themselves.
	if arrow.caster == "e": 
		arrow.damage_player()


@onready var enemy_attk_indi: Sprite2D = $DevIndicator/EnemyAttkIndi
@onready var player_attk_indi: Sprite2D = $DevIndicator/PlayerAttkIndi


var players_last_attack: Constants.DIR = Constants.DIR.NONE
var enemies_last_attack: Constants.DIR = Constants.DIR.NONE



"""
	The player's attack has contacted the enemy. 
		@param: contacting:
			FYI, this is called twice. Once when the animation first makes contact,
			another time when it exits contact. 
"""
func _on_player_contact_enemy(contacting: bool, dir: Constants.DIR):
	# Rotate the attack indicator to match the attack direction.
	player_attk_indi.rotation_degrees = Constants.get_rotation_from_dir(dir) 
	
	# The player has started contacting the enemy.
	if contacting:
		player_attk_indi.visible = true
		players_last_attack = dir 
		
		# Attempt a parry. 
		if not enemies_last_attack == Constants.DIR.NONE:
			# Check if correct parry direction. 
			if dir == Constants.get_opposite_dir(enemies_last_attack):
				handle_successful_parry()
	
	# The player has ended contact with the enemy.
	else:
		player_attk_indi.visible = false
		# The player deals scratch damage to the enemy.
		# NOTE: This is needed so that we don't damage the enemy after succesfully parrying.
		if not players_last_attack == Constants.DIR.NONE: 
			players_last_attack = Constants.DIR.NONE
			
			if enemy: 
				enemy.got_hit()



	
func _on_enemy_contact_player(contacting: bool, dir: Constants.DIR):
	enemy_attk_indi.rotation_degrees = Constants.get_rotation_from_dir(dir)
	
	# The enemy's attack has started contact with the player. 
	if contacting:
		enemy_attk_indi.visible = true
		enemies_last_attack = dir 
		
		# There is an attack to parry. 
		if not players_last_attack == Constants.DIR.NONE:
			# The parry was succesful.
			if dir == Constants.get_opposite_dir(players_last_attack):
				handle_successful_parry()
	
	# The enemy's attack has ended contact with the player. 	
	else:
		enemy_attk_indi.visible = false
		enemies_last_attack = Constants.DIR.NONE
		Events.change_players_health.emit(-16)

# If a parry is successful, there are a variety of actions that must take place.
func handle_successful_parry():
	# Remove all attacks. 
	enemies_last_attack = Constants.DIR.NONE	
	players_last_attack = Constants.DIR.NONE
	
	# Hide dev indicators. 
	enemy_attk_indi.visible = false	
	player_attk_indi.visible = false
	
	# Tell the enemy they got parried. 
	enemy.got_parried()	
	
