extends Area3D

@onready var door_blocker: StaticBody3D = $DoorBlocker

var locked := true

func _ready():
	set_locked(true)
	
func set_locked(value: bool) -> void:
	locked = value
	door_blocker.visible = value
	door_blocker.get_node("CollisionShape3D").disabled = not value

func _on_body_entered(body: Node3D) -> void:
	if locked:
		return
	if body.is_in_group("player"):
		var world = get_tree().get_first_node_in_group("world")
		var current_area = get_parent()
		print("Exit triggered. next_area_path = '", current_area.next_area_path, "'")
		if current_area.next_area_path == "":
			return
		var next_scene = load(current_area.next_area_path)
		world.load_area(next_scene)
