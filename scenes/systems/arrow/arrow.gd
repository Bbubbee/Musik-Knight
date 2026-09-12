extends RigidBody2D
class_name Arrow

@onready var sprite: Sprite2D = $Sprite
@onready var held_sprite: Sprite2D = $HeldSprite
@onready var physics_shape: CollisionShape2D = $PhysicsShape

var speed: float
var direction: int
var damage: float
var move_direction: int
var caster: Actor

"""
	Could make arrow data?
	New script
	
	var arrows: []
	var 
"""


func init(
		d: int, 
		c: Actor, 
		attack_data: ArrowAttackData
	):
		
	self.direction = d
		
	self.speed = attack_data.speed
	self.damage = attack_data.damage
	self.caster = c 
	
	# Initialise arrow based on wether the caster is a player or enemy.
	if c is Player: 
		self.move_direction = -1
		self.modulate = Color.AQUAMARINE
	elif c is Enemy:
		self.move_direction = 1 
		self.modulate = Color.INDIAN_RED
	
	# TEST: is held
	if attack_data.is_held:
		self.modulate = Color.GREEN_YELLOW
		held_sprite.visible = true
		
		# Position the held arrow a certain distance away based on time held.
		# d = s/t
		held_sprite.position.y = -(attack_data.held_duration * 60)
	
	else:
		held_sprite.visible = false

		
		
		

	# Set rotation of sprite based on the lane they are in.
	match d:
		0:
			sprite.rotation_degrees = 270
			held_sprite.rotation_degrees = 270
		1: 
			sprite.rotation_degrees = 0
			held_sprite.rotation_degrees = 0
		2: 
			sprite.rotation_degrees = 180
			held_sprite.rotation_degrees = 180
		3: 
			sprite.rotation_degrees = 90
			held_sprite.rotation_degrees = 90
	
	# Move the arrow. 
	self.linear_velocity.y = speed*move_direction
			
			
## An ArrowArea was triggered.
## Check if the correct direction was pressed.
## If so, clear this arrow.
## @param: The arrow direction that was triggered. 
func _on_good_zone_area_triggered(d: int) -> void:
	if d == direction:
		queue_free()


func damage_player(): 
	Events.change_players_health.emit(damage)
	self.queue_free()
