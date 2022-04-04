extends Area2D



func _on_DashPowerup_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		queue_free()
