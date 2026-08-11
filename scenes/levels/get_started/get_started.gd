extends Node2D

@onready var arrows = $Arrows

func _ready():
	ScreenCalculator.get_lanes(Vector2(0, 0), 4) 
	
