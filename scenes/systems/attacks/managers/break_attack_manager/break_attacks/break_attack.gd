extends Node2D
class_name BreakAttack

signal done_spawning(break_attack: BreakAttack, cancelled: bool)  # All arrow attacks of this break attack is done spawning.
signal return_outcome(break_attack: BreakAttack, s: int)  # The outcomes is the score of the arrows that were pressed during a break attack. 

const ARROW = preload("uid://u8nduxgvfxdr")

@onready var arrows: Node2D = $Arrows
@onready var timer: Timer = $Timer

var lanes 
var caster: Actor 
var type: Constants.BREAK_TYPE
var score: int


func _ready():
	lanes = ScreenCalculator.get_lanes(Vector2(0, 0), 4) 

func start(
		attacks: Array, 
		c: Actor = null, 
		t: Constants.BREAK_TYPE = Constants.BREAK_TYPE.BASIC
	):
	self.caster = c
	self.type = t
	
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
			arrow_object.arrow_removed.connect(_on_arrow_removed)
			arrow_object.init(arrow, caster, attack) 
		
		# Wait a given time before spwaning the next arrow. 
		timer.start(attack.time_until_next_attack)
		await timer.timeout
	
	# Finished spwaning all arrows. 
	done_spawning.emit(self, true)
	

func cancel(): 
	done_spawning.emit(self, false) 
	return_outcome.emit(self, score)
	self.queue_free()


# Track each arrow that is removed. 
func _on_arrow_removed(a: Arrow, s: int):	
	score += s  # Increase the score.
	
	arrows.remove_child(a)  # Remove arrow. 
	
	# All arrows have been removed.
	# Emit the outcome. 
	if arrows.get_child_count() <= 0: 
		return_outcome.emit(self, score) 
