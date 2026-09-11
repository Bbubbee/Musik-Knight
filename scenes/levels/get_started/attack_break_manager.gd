extends Node2D

var lanes 

const ARROW = preload("uid://u8nduxgvfxdr")
@onready var arrows: Node2D = $Arrows


func _ready():
	lanes = ScreenCalculator.get_lanes(Vector2(0, 0), 4) 
	Events.attack_break.connect(_on_attack_break) 
	
## Initiate an attack break. [attk]
func _on_attack_break(attk: Array, caster: Actor = null) -> void:	
	
	if not caster: 
		caster = Actor.new()
	
	# Spawn an arrow for each part of the attack.
	for x: Array in attk:
		# Multi attack: 
		if x[0] is Array: for y in x[0]: spawn_arrow(y, caster)
		# Singular attack:
		else: spawn_arrow(x[0], caster)
			
		# Wait a given amount of time until the next attack.
		await get_tree().create_timer(x[1]).timeout
		# NOTE: Should this be recursive? 
	
	Events.attack_break_end.emit(caster) 
	
	
## Spawns an arrow in a lane. The arrow will spawn.
func spawn_arrow(lane: int, caster: Actor):
	var x_pos: int = lanes[lane] 
	var y_pos: int 
	
	# Change the move direction of the attack based on the caster.
	if caster is Player: 
		y_pos = get_viewport().get_visible_rect().size.y
		
	elif caster is Enemy:
		y_pos = -30

	# Create the arrow. 
	var arrow: Arrow = ARROW.instantiate()
	arrow.position.y = y_pos
	arrow.position.x = x_pos
	arrows.add_child(arrow) 
	arrow.init(lane, caster) 
