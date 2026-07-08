extends Node3D

@export var starting_area: PackedScene
@onready var area_container = $AreaContainer
@onready var player = $Player

func _ready():
	load_area(starting_area)

func load_area(area_scene: PackedScene):
	for child in area_container.get_children():
		child.queue_free()

	var area = area_scene.instantiate()
	area_container.add_child(area)

	var spawn = area.get_node("SpawnPoint")
	player.global_position = spawn.global_position
