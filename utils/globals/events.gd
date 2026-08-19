extends Node


signal change_players_health(c: int)


# Attacks
signal attack_break(attk: Array, caster: String)
signal attack_basic(attk_dir: Constants.DIR, attacker: Node2D) 
