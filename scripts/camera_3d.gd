extends Camera3D
@export var target: Node3D
@export var offset := Vector3(10, 10, 10)

func _process(_delta):
	if target:
		global_position = target.global_position + offset
