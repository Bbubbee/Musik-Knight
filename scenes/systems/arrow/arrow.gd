extends RigidBody2D
class_name Arrow

@onready var sprite: Sprite2D = $Sprite
@onready var held_sprite: Sprite2D = $HeldSprite
@onready var physics_shape: CollisionShape2D = $PhysicsShape
@onready var line_2d: Line2D = $Line2D
@onready var explosion_particle: GPUParticles2D = $ExplosionParticle

var speed: float
var direction: int
var damage: float
var move_direction: int
var caster: Actor
var is_held: bool 
var is_currently_held: bool 
var held_duration: float
var held_distance: float
var is_active: bool = true
var arrow_attack_data: ArrowAttackData


func _ready() -> void:
	line_2d.visible = false


func init(
		d: int, 
		c: Actor, 
		attack_data: ArrowAttackData
	):
		
		
	self.direction = d
	self.caster = c 
	
	# Attack Arrow Data. 
	# TODO: Leave all data to the arrow_attack_data variable.
	self.arrow_attack_data = attack_data
	self.speed = attack_data.speed
	self.damage = -attack_data.damage
	self.is_held = attack_data.is_held
	self.held_duration = attack_data.held_duration
	
	self.move_direction = 1 
	
	
	# Initialise arrow based on wether the caster is a player or enemy.
	if c is Player: 
		self.modulate = Color.AQUAMARINE
	elif c is Enemy:
		self.modulate = Color.MEDIUM_VIOLET_RED
	
	# If the arrow is to be held.
	if attack_data.is_held:
		held_sprite.visible = true
		
		# Position the held arrow a certain distance away based on time held.
		self.held_distance = self.speed * self.held_duration
		held_sprite.position.y = -held_distance
		
		# Handle connecting line between held arrows.
		line_2d.visible = true
		line_2d.set_point_position(1, Vector2(0, -held_distance))
		
		# Handle changed area shape to accomodate held arrow.
		# NOTE: New shape had to be created. Editing the current shape edited the 
		# shape shared by all Arrow instances. 
		var new_shape = CapsuleShape2D.new()
		new_shape.radius = physics_shape.shape.radius
		new_shape.height = physics_shape.shape.height + held_distance
		physics_shape.shape = new_shape
		physics_shape.position.y = -held_distance/2

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
	self.linear_velocity.y = self.speed*move_direction


func remove_arrow(pos_y: float = 0.0):
	# NOTE: Position is a shit way of spawning explosion particles where the arrow was pressed.
	# I'm lazy.
	if pos_y == 0.0: 
		pos_y = self.position.y
	
	# Disables the arrow. Prevents the arrow from being clicked until it's 
	# finished running it' code.
	if not is_active: return
	is_active = false
	
	# Damage the enemy if the arrow was cast by the player.
	# NOTE: You might want to take care of this logic elsewhere.
	if caster is Player: 
		Events.change_enemies_health.emit(damage) 
	
	explosion_particle.global_position.y = pos_y
	explosion_particle.emitting = true 
	
	sprite.hide()
	held_sprite.hide()
	line_2d.hide()
	
	await explosion_particle.finished
	
	self.queue_free()
	


func damage_player(): 
	Events.change_players_health.emit(damage)
	self.queue_free()


func handle_held_press():
	is_currently_held = true 
	self.modulate = Color.LAWN_GREEN
	

	
