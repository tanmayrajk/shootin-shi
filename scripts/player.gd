extends CharacterBody2D

const max_speed = 300.0
const acceleration = 1250.0
const air_acceleration_multiplier = 0.6
const deacceleration = 1000.0
const max_jump_height = -500.0

func _physics_process(delta: float) -> void:
	var accel = acceleration
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = move_toward(velocity.x, max_speed * direction, accel * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, deacceleration * delta)
	
	if is_on_floor():
		$CoyoteTimer.start()
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or not $CoyoteTimer.is_stopped():
			velocity.y = max_jump_height
			$CoyoteTimer.stop()
		else:
			$JumpBufferTimer.start()
	
	if is_on_floor() and not $JumpBufferTimer.is_stopped():
		velocity.y = max_jump_height
		$JumpBufferTimer.stop()
			
	if (Input.is_action_just_released("jump") and velocity.y < 0) or is_on_ceiling():
		velocity.y *= 0.2
	
	move_and_slide()
