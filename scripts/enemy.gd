extends CharacterBody3D

@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("player")
@onready var Hitbox: Area3D = $Hitbox

const SPEED = 1.33
const JUMP_VELOCITY = 4.0

const FALL_GRAVITY_MULT = 1.2
const LOW_JUMP_GRAVITY_MULT = 3.2

const MAX_HEALTH = 3.0
var health = MAX_HEALTH

# COMBAT STATS
const DAMAGE = 3.0
const ATTACK_SPEED = 1.0
const CRITICAL_DAMAGE = 2.0
const CRITICAL_CHANCE = 1.0
@export var knockback_force: float = 9.0


# 1. Fires INSTANTLY on frame 0 of contact
func _on_hitbox_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if body.has_method("damage"):
			body.damage(DAMAGE, global_position, knockback_force)

# 2. Backup check for continuous contact (standing against enemy)
func check_and_deal_damage() -> void:
	if not Hitbox:
		return

	for body in Hitbox.get_overlapping_bodies():
		if body.is_in_group("player"):
			if body.has_method("damage"):
				body.damage(DAMAGE, global_position, knockback_force)

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * FALL_GRAVITY_MULT * delta
	else:
		velocity.y = 0

	# Movement / Chasing
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
	
	# Continuous damage check while standing inside hitbox
	check_and_deal_damage()

# Enemy receives damage
func take_damage(amount: float) -> void:
	health -= amount
	print("Enemy took damage, health: ", health)
	
	if health <= 0:
		die()

# Death
signal died
func die() -> void:
	died.emit()
	queue_free()
