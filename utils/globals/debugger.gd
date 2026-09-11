extends Node

@export_category("Enemy") 
# WARNING: Must match attack states of enemy exactly.
# Will rotate from thinking state to attack_pattern state.
# Press reset in Inspector to remove attack pattern.
@export_enum("Attack", "SpecialAttack") var attack_pattern: String
