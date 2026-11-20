extends Node

@warning_ignore_start("unused_signal")

# Stat changes
signal change_players_health(c: int)
signal change_enemies_health(c: float)
signal change_players_break_value(c: float) 

# Attacks
signal parried_enemy(succes: bool) 

# Break Attacks. 
signal attack_break(attk: Array, caster: Actor)
signal clear_all_attack_breaks()
signal attack_break_end(caster: Actor) 
signal attack_basic(attk_dir: Constants.DIR, attacker: Node2D) 
signal attack_break_completed(score: int) 

# Contact points
signal _player_contact_enemy 
signal _enemy_contact_player

signal pause_game(paused: bool)

# UI / Indicators
signal spawn_score_indicator(dir: Constants.DIR)

# Game management
signal level_over
signal someone_died(actor: Actor) 
