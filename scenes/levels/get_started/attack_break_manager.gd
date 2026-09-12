extends Node2D

var lanes 

const ARROW = preload("uid://u8nduxgvfxdr")
@onready var arrows: Node2D = $Arrows


func _ready():
	lanes = ScreenCalculator.get_lanes(Vector2(0, 0), 4) 
	Events.attack_break.connect(_on_attack_break) 
	
## Initiate an attack break. [attk]
func _on_attack_break(attk: Array, caster: Actor = null) -> void:		
	# Spawn an arrow for each part of the attack.
	for attk_segment: Array in attk:
		
		# Get held if it exists. This is if the arrow should be held down.
		var held: bool = false
		if Utils.does_index_exist_in_arr(attk_segment, 2): held = attk_segment[2]
		
		# Get held duration if it exists. 
		var held_duration: float = 0.0
		if Utils.does_index_exist_in_arr(attk_segment, 3): held_duration = attk_segment[3]
		
		# Multi attack:
		if attk_segment[0] is Array: 
			for y in attk_segment[0]: 
				spawn_arrow(y, caster, held, held_duration)
		# Singular attack:
		else: spawn_arrow(attk_segment[0], caster, held, held_duration)
			
		# Wait a given amount of time until the next attack.
		await get_tree().create_timer(attk_segment[1]).timeout
	
	Events.attack_break_end.emit(caster) 
	
	
## Spawns an arrow in a lane. The arrow will spawn.
func spawn_arrow(lane: int, caster: Actor, is_held: bool = false, held_duration: float = 0.0):
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
	arrow.init(lane, caster, is_held, held_duration) 
