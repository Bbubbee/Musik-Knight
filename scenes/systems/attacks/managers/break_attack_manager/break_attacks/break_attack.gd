extends Node2D
class_name BreakAttack

var lanes 

const ARROW = preload("uid://u8nduxgvfxdr")

signal completed 

@onready var timer: Timer = $Timer

var caster: Actor 

func _ready():
	lanes = ScreenCalculator.get_lanes(Vector2(0, 0), 4) 

func start(attacks: Array, c: Actor = null):
	self.caster = c
	
	for attack: ArrowAttackData in attacks:
		for arrow in attack.arrows:

			var x_pos: float = lanes[arrow] 
			var y_pos: float 
			
			y_pos = -30
			
			# Create the arrow. 
			var arrow_object: Arrow = ARROW.instantiate()
			arrow_object.position.y = y_pos
			arrow_object.position.x = x_pos
			self.add_child(arrow_object) 
			arrow_object.init(arrow, caster, attack) 
		
		# Wait a given time before spwaning the next arrow. 
		#await get_tree().create_timer(attack.time_until_next_attack).timeout
		timer.start(attack.time_until_next_attack)
		await timer.timeout
	completed.emit()
	
	

func cancel(): 
	pass
