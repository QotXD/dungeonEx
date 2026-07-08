extends Area3D

@export var speed: float = 10.0 
@export var lifetime: float = 3.0 

const BULLET_DAMAGE = 1.0

func _ready():
	get_tree().create_timer(lifetime).timeout.connect(queue_free)
	#body_entered.connect(_on_body_entered)

func _physics_process(delta):
	global_transform.origin += -global_transform.basis.z * speed * delta

#no self damage
func _on_body_entered(body):
	if body.is_in_group("Player"):
		return
		
	# enemy damage
	if body.has_method("take_damage"):
		body.take_damage(BULLET_DAMAGE) 
		

	queue_free()
