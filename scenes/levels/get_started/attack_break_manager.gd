extends Node2D

var lanes 

const ARROW = preload("uid://u8nduxgvfxdr")
@onready var arrows: Node2D = $Arrows


func _ready():
	lanes = ScreenCalculator.get_lanes(Vector2(0, 0), 4) 
	Events.attack_break.connect(_on_attack_break) 
	
## Initiate an attack break. [attk]
func _on_attack_break(attacks: Array, caster: Actor = null) -> void:		
	
	for attack: ArrowAttackData in attacks:
		for arrow in attack.arrows:

			var x_pos: float = lanes[arrow] 
			var y_pos: float 
			
			# Change the spawn location of the arrow based if player or enemy.
			if caster is Player: y_pos = get_viewport().get_visible_rect().size.y
			elif caster is Enemy: y_pos = -30
			
			# Create the arrow. 
			var arrow_object: Arrow = ARROW.instantiate()
			arrow_object.position.y = y_pos
			arrow_object.position.x = x_pos
			arrows.add_child(arrow_object) 
			arrow_object.init(arrow, caster, attack) 
			
		await get_tree().create_timer(attack.time_until_next_attack).timeout
	
	Events.attack_break_end.emit(caster) 
			
			
	
