extends Node2D

var lanes: Array[float]

func _ready() -> void:
	Events.spawn_score_indicator.connect(_on_spawn_score_indi)
	lanes = ScreenCalculator.get_lanes(Vector2(0, 0), 4) 

	

func _on_spawn_score_indi(dir: Constants.DIR, score: String):
	var x_pos: float = lanes[dir] 
	var my_label = Label.new()
	my_label.text = score
	my_label.add_theme_font_size_override("font_size", 42)
	
	add_child(my_label)
	my_label.position = Vector2(x_pos-my_label.size.x/2, 1000) 
	
	await get_tree().create_timer(0.35).timeout
	my_label.queue_free()
	
