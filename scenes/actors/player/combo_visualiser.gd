extends Control

@onready var h_box: HBoxContainer = $HBox
const ARROW_UP = preload("uid://cx1irex1h1ea2")


func _ready() -> void:
	pass


func show_combo(combo: Array[Constants.DIR]):
	#print(combo)
	for c in h_box.get_children():
		h_box.remove_child(c)
	
	for c in combo:
		var t = TextureRect.new()
		t.texture = ARROW_UP
		h_box.add_child(t) 
		#t.scale = Vector2(0.25, 0.25)
		t.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		t.offset_transform_enabled = true
		t.offset_transform_rotation = deg_to_rad(Constants.get_rotation_from_dir(c))
		
