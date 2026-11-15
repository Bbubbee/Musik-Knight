extends Node2D

var lanes 
const BREAK_ATTACK = preload("uid://k2vmw5r2mhsr")

const ARROW = preload("uid://u8nduxgvfxdr")
@onready var arrows: Node2D = $Arrows


var current_break_attack


func _ready():
	lanes = ScreenCalculator.get_lanes(Vector2(0, 0), 4) 
	Events.attack_break.connect(_on_attack_break) 
	
## Initiate an attack break. [attk]
func _on_attack_break(attacks: Array, caster: Actor = null) -> void:		
	
	var new_break_attack = BREAK_ATTACK.instantiate()
	self.add_child(new_break_attack)
	new_break_attack.start(attacks, caster)
	await new_break_attack.completed
	Events.attack_break_end.emit(caster) 
	
	#for attack: ArrowAttackData in attacks:
		#for arrow in attack.arrows:
#
			#var x_pos: float = lanes[arrow] 
			#var y_pos: float 
			#
			#y_pos = -30
			#
			## Create the arrow. 
			#var arrow_object: Arrow = ARROW.instantiate()
			#arrow_object.position.y = y_pos
			#arrow_object.position.x = x_pos
			#arrows.add_child(arrow_object) 
			#arrow_object.init(arrow, caster, attack) 
		#
		## Wait a given time before spwaning the next arrow. 
		#await get_tree().create_timer(attack.time_until_next_attack).timeout
	#
	#Events.attack_break_end.emit(caster) 
	# WARNING: Game will crash if arrow is actioned whilst the caster is freed.
	
			
			
		#if caster is Player: 
		#if arrows.get_child_count() > 0:
			#for a in arrows.get_children():
				#a.queue_free()
