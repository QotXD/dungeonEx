extends Area3D

@export var speed: float = 10.0 
@export var lifetime: float = 3.0 

func _ready():
	get_tree().create_timer(lifetime).timeout.connect(queue_free)
	body_entered.connect(_on_body_entered)

func _physics_process(delta):
	global_transform.origin += -global_transform.basis.z * speed * delta

func _on_body_entered(body):
	if body.is_in_group("Player"):
		return
		
	# add enemy damaging here
	# if body.has_method("take_damage"):
	#     body.take_damage(10) 
	

	queue_free()
