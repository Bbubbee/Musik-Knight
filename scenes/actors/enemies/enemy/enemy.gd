extends Node2D
class_name Enemy

signal attacked_player(dir: Constants.DIR)
@onready var attack_dir_sprite: Sprite2D = $AttackDirSprite

@onready var state_machine: StateMachine = $StateMachine

func _ready() -> void:
	state_machine.init(self)
	attack_dir_sprite.visible = false


func got_parried():
	pass


		
	


	
