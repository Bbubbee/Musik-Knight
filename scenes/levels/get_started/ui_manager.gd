extends CanvasLayer

var level_running: bool = true
@onready var outcome_label: Label = $VBoxContainer/CenterContainer/OutcomeLabel

func _ready() -> void:
	Events.someone_died.connect(_on_someone_died)
	self.hide()


func _on_someone_died(actor: Actor): 
	
	# Change outcome label based on who won.
	if actor is Enemy:
		outcome_label.text = "You Won!"
	else: 
		outcome_label.text = "You Lost!"
	
	self.show()
	level_running = false
	
	Events.level_over.emit()


func _on_play_again_button_pressed() -> void:
	SceneTransition.change_scene("res://scenes/levels/get_started/main.tscn", "dissolve_black")


func _input(event: InputEvent) -> void:
	if level_running: return
	
	if event.is_action_pressed("ui_accept"): 
		_on_play_again_button_pressed() 
