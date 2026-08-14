extends Node2D

@onready var arrows = $Arrows

const ARROW = preload("uid://u8nduxgvfxdr")

var lanes: Array[int]

func _ready():
	lanes = ScreenCalculator.get_lanes(Vector2(0, 0), 4) 
	
	
func _on_arrow_spawner_timer_timeout() -> void:
	spawn_arrow()
	

func spawn_arrow():
	# Spawn a singular random arrow.
	var d = randi_range(0, 3) 
	var x_pos: int
	
	x_pos = lanes[d] 
	
	var arrow: Arrow = ARROW.instantiate()
	arrow.position.y = -30
	arrow.position.x = x_pos
	arrows.add_child(arrow) 
	arrow.init(d) 
	
