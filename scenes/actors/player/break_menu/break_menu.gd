extends Node2D
class_name BreakMenu

@onready var canvas_layer: CanvasLayer = $CanvasLayer

var enabled: bool 

signal option_chosen(choice: String) 


func _ready() -> void:
	canvas_layer.hide()

func choose_break_ability():
	enabled = true
	Events.pause_game.emit(true) 
	canvas_layer.show()

func return_break_ability(temp_ability: String):
	option_chosen.emit(temp_ability)
	canvas_layer.hide()
	enabled = false

func _input(event: InputEvent) -> void:
	if not enabled: return
	
	if event.is_action_pressed("arrow_left"):
		return_break_ability("Heal")

	if event.is_action_pressed("arrow_up"):
		return_break_ability("Poison")

	if event.is_action_pressed("arrow_right"):
		return_break_ability("Damage")

	if event.is_action_pressed("arrow_down"):
		return_break_ability("Debuff")
