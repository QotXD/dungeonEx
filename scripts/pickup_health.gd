extends Area3D

@export var heal_amount := 1.0

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and body.has_method("heal"):
		body.heal(heal_amount)
		queue_free()
