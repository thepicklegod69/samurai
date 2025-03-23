extends CharacterBody2D

#const SPEED = 150.0
const RUN_SPEED = 200.0 
const WALK_SPEED = 100.0
const JUMP_VELOCITY = -250.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta


	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Walk_left","Walk_right")
	var is_running := Input.is_action_pressed("Run")  # Holding "Run" key
	var speed := RUN_SPEED if is_running else WALK_SPEED  # Walk is slower
	
	velocity.x = direction * speed

	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

# Play animations
	if direction == 0 and is_on_floor():
		animated_sprite.play("Idle")  # Idle when not moving
	elif is_running and direction != 0:  # Run if holding "Shift" and moving
		animated_sprite.play("Run")
	elif direction != 0:  # Walk if moving but not holding "Shift"
		animated_sprite.play("Walk")
	
	
	if velocity.y < 0:
		animated_sprite.play("Jump")
	elif velocity.y > 0:
		animated_sprite.play("Fall")
	
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	#Helloooooooo
