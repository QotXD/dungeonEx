extends Node3D

@export var next_area_path: String = ""

var enemies_remaining := 0
var room_cleared := false

func _ready():
	var enemies = get_tree().get_nodes_in_group("enemy").filter(func(e): return is_ancestor_of(e))
	enemies_remaining = enemies.size()
	for enemy in enemies:
		enemy.died.connect(_on_enemy_died)
	check_clear_state()

func _on_enemy_died() -> void:
	enemies_remaining -= 1
	check_clear_state()
	
func check_clear_state() -> void:
	if enemies_remaining <= 0 and not room_cleared:
		room_cleared = true
		for child in get_children():
			if child.has_method("set_locked"):
				child.set_locked(false)
