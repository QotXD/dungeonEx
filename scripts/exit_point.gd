extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		var world = get_tree().get_first_node_in_group("world")
		var current_area = get_parent()
		if current_area.next_area_path == "":
			return
		var next_scene = load(current_area.next_area_path)
		world.load_area(next_scene)
