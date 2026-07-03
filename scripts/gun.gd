extends Node3D

@export var bullet: PackedScene
@export var orbit_radius: float = 0.5

@onready var muzzle = $Muzzle
@onready var fire_timer = $FireRateTimer

var player: Node3D

func _ready():
	player = get_parent()

func _physics_process(_delta):
	_handle_aiming()
	
	if Input.is_action_pressed("shoot") and fire_timer.is_stopped():
		shoot()

#GUN
func _handle_aiming():
	var camera = get_viewport().get_camera_3d()
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var dir = camera.project_ray_normal(mouse_pos)
	var plane = Plane(Vector3.UP, player.global_transform.origin.y)
	var mouse_world_pos = plane.intersects_ray(from, dir)
	
	#GUN ORBIT AXIS PLAYER
	if mouse_world_pos != null:
		var player_to_mouse = mouse_world_pos - player.global_transform.origin
		player_to_mouse.y = 0
		global_transform.origin = player.global_transform.origin + (player_to_mouse.normalized() * orbit_radius)
		look_at(mouse_world_pos, Vector3.UP)
		rotation.x = 0
		rotation.z = 0

#SHOOTING
func shoot():
	if bullet == null:
		return
		
	var bullet = bullet.instantiate()
	get_tree().root.add_child(bullet)
	bullet.global_transform = muzzle.global_transform
	fire_timer.start()
