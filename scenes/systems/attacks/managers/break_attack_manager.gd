extends Node2D

var lanes 

const ARROW = preload("uid://u8nduxgvfxdr")
@onready var arrows: Node2D = $Arrows


func _ready():
	lanes = ScreenCalculator.get_lanes(Vector2(0, 0), 4) 
	Events.attack_break.connect(_on_attack_break) 
	
## Initiate an attack break. [attk]
func _on_attack_break(attacks: Array, caster: Actor = null) -> void:		
	
	# If player attack breaks, clear any existing attack breaks/arrows. 
	if caster is Player: 
		if arrows.get_child_count() > 0:
			for a in arrows.get_children():
				a.queue_free()
	
	for attack: ArrowAttackData in attacks:
		for arrow in attack.arrows:

			var x_pos: float = lanes[arrow] 
			var y_pos: float 
			
			y_pos = -30
			
			# Create the arrow. 
			var arrow_object: Arrow = ARROW.instantiate()
			arrow_object.position.y = y_pos
			arrow_object.position.x = x_pos
			arrows.add_child(arrow_object) 
			arrow_object.init(arrow, caster, attack) 
			
		await get_tree().create_timer(attack.time_until_next_attack).timeout
	
	# WARNING: Game will crash if arrow is actioned whilst the caster is freed.
	Events.attack_break_end.emit(caster) 
			
			
	
