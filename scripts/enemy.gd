extends CharacterBody3D

@onready var player = $Player

const SPEED = 1.33
const JUMP_VELOCITY = 4.0

const FALL_GRAVITY_MULT = 1.2
const LOW_JUMP_GRAVITY_MULT = 3.2

const MAX_HEALTH = 3
var health = MAX_HEALTH

const DAMAGE = 3.5
const ATTACK_SPEED = 1.0
const CRITICAL_DAMAGE = 2.0
const CRITICAL_CHANCE = 1.0

func take_damage(amount: float) -> void:
	health -= amount
	print("Enemy took damage, health: ", health)
	
	if health <= 0:
		die()

#death
func die() -> void:
	queue_free()


func _ready():
	#check for player group
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor():
		velocity += get_gravity() * FALL_GRAVITY_MULT * delta
	else:
		velocity.y = 0

	# movement
	if player and is_instance_valid(player):
		var target_pos = player.global_position
		target_pos.y = global_position.y 
		
		var distance = global_position.distance_to(target_pos)
		
		if distance > 0.5:
			look_at(target_pos, Vector3.UP)
			var direction = (target_pos - global_position).normalized()
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = 0
			velocity.z = 0
	else:
		velocity.x = 0
		velocity.z = 0

	move_and_slide()
