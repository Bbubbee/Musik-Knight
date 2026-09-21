class_name ArrowAttackData

var arrows: Array[int]
var time_until_next_attack: float
var is_held: bool
var held_duration: float
var speed: float
var damage: float


func init(
		# Required: 
		arrs: Array[int],
		t: float, 
		
		# Not Required:
		held: bool = false, 
		held_dur: float = 0.0,
		s: float = 600.0,
		dmg: float = 38
	):	
	
	self.arrows = arrs
	self.time_until_next_attack = t
	self.is_held = held
	self.held_duration = held_dur
	self.speed = s
	self.damage = dmg

	# Needs to return self so can be newly created and intialised in the same line.
	return self
