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

func _input(event: InputEvent) -> void:
	if not enabled: return
	
	if event.is_action_pressed("arrow_left"):
		option_chosen.emit()
		canvas_layer.hide()
		enabled = false
		print("Heal!")
		
	if event.is_action_pressed("arrow_up"):
		option_chosen.emit()
		canvas_layer.hide()
		enabled = false
		print("Poison!")
		

	if event.is_action_pressed("arrow_right"):
		option_chosen.emit()
		canvas_layer.hide()
		enabled = false
		print("Damage!")
		
	if event.is_action_pressed("arrow_down"):
		option_chosen.emit()
		canvas_layer.hide()
		enabled = false
		print("Debuff!")
