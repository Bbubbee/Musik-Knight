extends Node


signal change_players_health(c: int)


# Attacks
signal attack_break(attk: Array, caster: String)
signal attack_basic(attk_dir: Constants.DIR, attacker: Node2D) 

signal _player_contact_enemy 
signal _enemy_contact_player

# UI / Indicators
signal spawn_score_indicator(dir: Constants.DIR)
