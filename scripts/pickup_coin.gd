extends Area3D

@export var coin_value := 1

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and body.has_method("add_coins"):
		body.add_coins(coin_value)
		queue_free()
