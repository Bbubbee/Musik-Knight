extends Sprite2D

var dir: Constants.DIR
@onready var animator: AnimationPlayer = $Animator


func init(d: Constants.DIR, pos_x):
	self.rotation_degrees = Constants.get_rotation_from_dir(d)
	self.global_position.x = pos_x
	self.dir = dir


func press_arrow():
	animator.play("RESET")
	animator.play("flash_green")


func hold_arrow():
	animator.play("change_green")

func release_arrow():
	animator.play("change_white")
