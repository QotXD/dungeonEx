extends StaticBody3D

@export var max_health := 1.0
@export var drop_chance := 0.8 # 1.0 = always drop, 0.5 = 50% etc
@export var coin_scene: PackedScene
@export var health_scene: PackedScene
@export var coin_drop_chance := 0.6 # coin drop = 60%, health is whatever is left eg 40%

var health := max_health

func take_damage(amount: float, source_position: Vector3 = Vector3.ZERO) -> void:
	health -= amount
	if health <= 0:
		break_box()
		
func break_box() -> void:
	if randf() <= drop_chance:
		var drop_scene: PackedScene
		if randf() <= coin_drop_chance:
			drop_scene = coin_scene
		else:
			drop_scene = health_scene
		
		if drop_scene:
			var drop = drop_scene.instantiate()
			get_parent().add_child(drop)
			drop.global_position = global_position
	queue_free()
