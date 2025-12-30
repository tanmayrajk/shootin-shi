extends CharacterBody2D

const SPEED = 300.0
const ACCELERATION = 850.0
const AIR_ACCELERATION_MULT = 0.6
const DEACCELERATION = 1000.0
const JUMP_HEIGHT = - 500.0

func _physics_process(delta: float) -> void:
	var accel = ACCELERATION
	if not is_on_floor():
		velocity += get_gravity() * delta
		accel *= AIR_ACCELERATION_MULT

	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = move_toward(velocity.x, SPEED * direction, accel * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, DEACCELERATION * delta)
	
	if is_on_floor():
		$CoyoteTimer.stop()
	else:
		$CoyoteTimer.start()
		
	if is_on_floor() or not $CoyoteTimer.is_stopped():
		if Input.is_action_just_pressed("jump") or not $JumpBufferTimer.is_stopped():
			velocity.y = JUMP_HEIGHT
			$JumpBufferTimer.stop()
	else:
		if Input.is_action_just_pressed("jump"):
			$JumpBufferTimer.start()
		if Input.is_action_just_released("jump") and velocity.y < 0:
			velocity.y *= 0.2
		elif is_on_ceiling():
			velocity.y *= 0.2
	
	move_and_slide()
