extends Node


signal change_players_health(c: int)


# Attacks
signal attack_break(attk: Array, caster: Actor, is_held: bool)
signal attack_break_end(caster: Actor) 
signal attack_basic(attk_dir: Constants.DIR, attacker: Node2D) 

signal _player_contact_enemy 
signal _enemy_contact_player

# UI / Indicators
signal spawn_score_indicator(dir: Constants.DIR)
