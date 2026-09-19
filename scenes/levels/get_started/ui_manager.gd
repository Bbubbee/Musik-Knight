extends CanvasLayer

var level_running: bool = true

func _ready() -> void:
	Events.someone_died.connect(_on_someone_died)
	self.hide()


func _on_someone_died(_actor: Actor): 
	self.show()
	level_running = false
	print("Someone died", str(_actor)) 
	
	Events.level_over.emit()


func _on_play_again_button_pressed() -> void:
	SceneTransition.change_scene("res://scenes/levels/get_started/main.tscn", "dissolve_black")


func _input(event: InputEvent) -> void:
	if level_running: return
	
	if event.is_action_pressed("ui_accept"): 
		_on_play_again_button_pressed() 
