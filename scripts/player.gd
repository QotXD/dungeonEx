extends CharacterBody3D

#MOVEMENT STATS
const SPEED = 5.0
const JUMP_VELOCITY = 4.0
const FALL_GRAVITY_MULT = 1.2
const LOW_JUMP_GRAVITY_MULT = 3.2

#HEALTH STATS
const MAX_HEALTH = 20
var health = MAX_HEALTH
@export var iframe_duration: float = 0.5 # Seconds invincible after hit
var is_invincible: bool = false

#KNOCKBACK
var knockback_velocity: Vector3 = Vector3.ZERO
@export var knockback_decay: float = 25.0 # How fast knockback force stops

#DAMAGE STATS
const DAMAGE = 3.5
const ATTACK_SPEED = 1.0
const CRITICAL_DAMAGE = 2.0
const CRITICAL_CHANCE = 1.0


#HEALTH
func _ready() -> void:
	update_health_ui()
	$HealthBar.max_value = MAX_HEALTH
	
	
func update_health_ui():
	set_health_label()
	set_health_bar()
	
func set_health_label() -> void:
	$HealthLabel.text = "Health: %s" % health
	
func set_health_bar() -> void:
	$HealthBar.value = health

#DAMAGE FROM ENEMIEs
func damage(amount: float, source_position: Vector3 = Vector3.ZERO, knockback_force: float = 12.0) -> void:
	if is_invincible:
		return
		
	health -= amount
	is_invincible = true
	update_health_ui()

	# Instant Knockback Force Assignment
	if source_position != Vector3.ZERO:
		var push_dir = (global_position - source_position)
		push_dir.y = 0
		push_dir = push_dir.normalized()

		# Set BOTH knockback_velocity and current velocity immediately
		knockback_velocity = push_dir * knockback_force
		velocity.x = knockback_velocity.x
		velocity.z = knockback_velocity.z

	if health <= 0:
		die()
		return
		
	await get_tree().create_timer(iframe_duration).timeout
	is_invincible = false


#DEATH
func die() -> void:
	Engine.time_scale = 0.5
	await get_tree().create_timer(2.0, false, false, true).timeout
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()


#MOVEMENT
func _physics_process(delta: float) -> void:
	# 1. Decay knockback smoothly over time
	if knockback_velocity.length() > 0.1:
		knockback_velocity = knockback_velocity.move_toward(Vector3.ZERO, knockback_decay * delta)
	else:
		knockback_velocity = Vector3.ZERO
	
	
	# Add the gravity.
	if not is_on_floor():
		if velocity.y > 0 and Input.is_action_pressed("ui_accept"):
			# Rising while holding jump → normal gravity
			velocity += get_gravity() * delta
		elif velocity.y > 0:
			# Rising but released jump → cut jump short
			velocity += get_gravity() * LOW_JUMP_GRAVITY_MULT * delta
		else:
			# Falling → heavier gravity
			velocity += get_gravity() * FALL_GRAVITY_MULT * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	
	if knockback_velocity.length() > 1.0:
		# Player is currently in knockback state: let knockback control movement
		velocity.x = knockback_velocity.x
		velocity.z = knockback_velocity.z
	else:
		# Player has control: process normal movement inputs
		var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction := Vector3(input_dir.x + input_dir.y, 0, input_dir.y - input_dir.x).normalized()
		
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
