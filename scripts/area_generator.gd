@tool
extends Node3D

@export var voxel_block: PackedScene

@export var regenerate: bool = false:
	set(value):
		if value and is_inside_tree():
			build_room()
			generate_blocks()
		regenerate = false

var voxel_data = []

func _ready():
	if not Engine.is_editor_hint():
		build_room()
		generate_blocks()

func build_room():
	voxel_data = []
	for x in range(10):
		voxel_data.append([])
		for y in range(1):
			voxel_data[x].append([])
			for z in range(10):
				voxel_data[x][y].append(1)

func generate_blocks():
	for child in get_children():
		child.free()
	for x in range(voxel_data.size()):
		for y in range(voxel_data[x].size()):
			for z in range(voxel_data[x][y].size()):
				if voxel_data[x][y][z] == 0:
					continue
				var block = voxel_block.instantiate()
				add_child(block)
				block.owner = get_tree().edited_scene_root
				block.position = Vector3(x, y, z)
