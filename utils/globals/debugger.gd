extends Node

@export_category("Enemy") 
# WARNING: Must match attack states of enemy. 
@export_enum("Attack", "SpecialAttack") var attack_pattern: String
