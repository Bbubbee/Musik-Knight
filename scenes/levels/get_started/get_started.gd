extends Node2D

@onready var arrows = $Arrows

const ARROW = preload("uid://u8nduxgvfxdr")

var lanes: Array[int]

func _ready():
	lanes = ScreenCalculator.get_lanes(Vector2(0, 0), 4) 
	
	
	for x in range(4):
		var a: Arrow = ARROW.instantiate()
		a.position.x = lanes[x]
		a.position.y = 0
		arrows.add_child(a) 
