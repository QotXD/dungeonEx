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
		
#MAP BLOCKS
func build_room():
	voxel_data = []
	var width = 10
	var height = 5
	var depth = 10
	
	for x in range(width):
		voxel_data.append([])
		for y in range(height):
			voxel_data[x].append([])
			for z in range(depth):
				# Floor stays the same
				var is_floor = (y == 0)
				
				# ONLY make walls where X is 0 or Z is 0
				var is_wall = (x == 0 or z == 0)
				if is_floor or is_wall:
					voxel_data[x][y].append(1)
				else:
					voxel_data[x][y].append(0)

#RENDER BLOCKS
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
