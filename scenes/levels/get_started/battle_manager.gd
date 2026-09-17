extends Node2D

func _ready():
	Events._player_contact_enemy.connect(_on_player_contact_enemy) 
	Events._enemy_contact_player.connect(_on_enemy_contact_player) 


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
func _on_player_contact_enemy(contacting: bool, dir: Constants.DIR, dmg: float):
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
			

			Events.change_enemies_health.emit(-dmg) 

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
	# Deal damage to the player.
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
	Events.parried_enemy.emit()
	
