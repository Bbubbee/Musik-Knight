extends Node

@warning_ignore_start("unused_signal")

# Stat changes
signal change_players_health(c: int)
signal change_enemies_health(c: float)
signal change_players_break_meter(c: float) 

# Attacks
signal attack_break(attk: Array, caster: Actor)
signal attack_break_end(caster: Actor) 
signal attack_basic(attk_dir: Constants.DIR, attacker: Node2D) 
signal parried_enemy

# Contact points
signal _player_contact_enemy 
signal _enemy_contact_player

# UI / Indicators
signal spawn_score_indicator(dir: Constants.DIR)

# Game management
signal level_over
signal someone_died(actor: Actor) 
