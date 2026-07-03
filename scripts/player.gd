extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.0
const FALL_GRAVITY_MULT = 1.2
const LOW_JUMP_GRAVITY_MULT = 3.2

const MAX_HEALTH = 20
var health = MAX_HEALTH

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

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		damage()
		
func damage() -> void:
	health -= 1
	if health < 0:
		health = MAX_HEALTH
	update_health_ui()
	
	if health <= 0:
		die()



#DEATH
func die() -> void:
	Engine.time_scale = 0.5
	await get_tree().create_timer(2.0, false, false, true).timeout
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()


#MOVEMENT
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
