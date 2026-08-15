extends Node2D

@onready var arrows = $Arrows

const ARROW = preload("uid://u8nduxgvfxdr")

var lanes: Array[int]


func _ready():
	lanes = ScreenCalculator.get_lanes(Vector2(0, 0), 4) 
	
	
func _on_arrow_spawner_timer_timeout() -> void:
	temp_spawn_arrow()
	

func temp_spawn_arrow():
	# Spawn a singular random arrow.
	var d = randi_range(0, 3) 
	var x_pos: int
	
	x_pos = lanes[d] 
	
	var arrow: Arrow = ARROW.instantiate()
	arrow.position.y = -30
	arrow.position.x = x_pos
	arrows.add_child(arrow) 
	arrow.init(d) 


func spawn_arrow(d: int):

	var x_pos: int = lanes[d] 
	
	var arrow: Arrow = ARROW.instantiate()
	arrow.position.y = -30
	arrow.position.x = x_pos
	arrows.add_child(arrow) 
	arrow.init(d) 


func _on_enemy_attack(attk: Array) -> void:
	# Spawn an arrow for each part of the attack.
	for x: Array in attk:
		# Multi attack: 
		if x[0] is Array: for y in x[0]: spawn_arrow(y)
		# Singular attack:
		else: spawn_arrow(x[0])
			
		# Wait a given amount of time until the next attack.
		await get_tree().create_timer(x[1]).timeout
		# NOTE: Should this be recursive? 
		
	# Make custom data types for attacks.
