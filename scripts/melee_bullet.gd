extends Area3D

@export var lifetime: float = 0.15
const MELEE_DAMAGE = 2.0

func _ready():
	get_tree().create_timer(lifetime).timeout.connect(queue_free)

func _on_body_entered(body):
	print("Melee hit something: ", body.name)
	if body.is_in_group("player"):
		return
	if body.has_method("take_damage"):
		print("Damaging: ", body.name)
		body.take_damage(MELEE_DAMAGE)
