extends Node2D

@onready var arrows = $Arrows

@export var player: Player
@export var enemy: Enemy 

const ARROW = preload("uid://u8nduxgvfxdr")

var lanes: Array[int]

func _ready():
	lanes = ScreenCalculator.get_lanes(Vector2(0, 0), 4) 
	
	Events.attack_break.connect(_on_attack_break) 
	
	# Initialise the player and enemy.
	if player and enemy:
		if player.has_signal("attacked_enemy"):
			player.attacked_enemy.connect(_on_player_attacked_enemy)
		if enemy.has_signal("attacked_player"):
			enemy.attacked_player.connect(_on_enemy_attacked_player)
	
	
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
		

func _on_enemy_attacked_player(dir: Constants.DIR) -> void:
	if not player: return
	
	# Start parry window.
	player.got_attacked_basic()

	
func _on_player_attacked_enemy(dir: Constants.DIR) -> void:
	if not enemy: return
	
	# If no parry window, just deal damage normally.
	if not enemy.parriable:
		print("scratched enemy")
		enemy.got_hit() 
		return
		
	# There is a parry window. Attemp to parry. If incorrect parry, 
	# just deal scratch damage
	if dir == Constants.get_opposite_dir(enemy._attack_dir):
		enemy.got_parried()
		
	else:
		enemy.got_hit() 
		
		
"""
	New System: 
		
		Enemy and Player = 2 signals:
			1. Indicate contact 
			2. Indicate end of contact
		
		If contact period overlaps, then attempt a parry.
"""
