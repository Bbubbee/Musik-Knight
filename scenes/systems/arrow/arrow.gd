extends RigidBody2D
class_name Arrow

@onready var sprite: Sprite2D = $Sprite
@onready var physics_shape: CollisionShape2D = $PhysicsShape

var speed: float
var direction: int
var damage: int
var move_direction: int
var caster: Actor


func init(d: int, c: Actor, s: float = 325, dmg: int = 5):
	self.speed = s
	self.direction = d  # NOTE: The lane the arrow is in determines it's "direction".
	self.damage = dmg
	self.caster = c 
	
	# Initialise arrow based on wether the caster is a player or enemy.
	if c is Player: 
		self.move_direction = -1
		self.modulate = Color.AQUAMARINE
	elif c is Enemy:
		self.move_direction = 1 
		self.modulate = Color.INDIAN_RED
		

	# Set rotation of sprite based on the lane they are in.
	match d:
		0:
			sprite.rotation_degrees = 270
		1: 
			sprite.rotation_degrees = 0
		2: 
			sprite.rotation_degrees = 180
		3: 
			sprite.rotation_degrees = 90
	
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
