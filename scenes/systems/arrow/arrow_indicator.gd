extends Sprite2D

var dir: Constants.DIR
@onready var animator: AnimationPlayer = $Animator

var is_held: bool = false


func init(d: Constants.DIR, pos_x):
	self.rotation_degrees = Constants.get_rotation_from_dir(d)
	self.global_position.x = pos_x
	self.dir = d


func press_arrow():
	animator.play("RESET")
	animator.play("flash_green")


func hold_arrow():
	is_held = true 
	animator.play("change_green")


func release_arrow():
	is_held = false
	animator.play("change_white")
