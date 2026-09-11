extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if not body is Arrow: return
	
	var a = body as Arrow 
	a.damage_player()
