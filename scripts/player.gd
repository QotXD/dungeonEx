extends CharacterBody3D


const SPEED = 3.5
const JUMP_VELOCITY = 4.0
const FALL_GRAVITY_MULT = 1.2
const LOW_JUMP_GRAVITY_MULT = 3.2


func _physics_process(delta: float) -> void:
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
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := Vector3(input_dir.x + input_dir.y, 0, input_dir.y - input_dir.x).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
