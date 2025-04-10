extends Character
class_name Player

#const SPEED = 150.0
const RUN_SPEED = 200.0 
const WALK_SPEED = 100.0
const JUMP_VELOCITY = -250.0
@export var attack_damage: int = 20
@export var attack_cooldown: float = 0.5

var can_attack := true

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
	
	if Input.is_action_just_pressed("Basic_attack_right") and can_attack:
		do_attack()

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
	
func do_attack() -> void:
	can_attack = false

	var hitbox = $AttackHitbox
	hitbox.set_meta("damage", attack_damage)
	hitbox.monitoring = true

	# Wait 0.1 seconds for the attack hitbox to register collisions
	await get_tree().create_timer(0.1).timeout
	hitbox.monitoring = false

	# Wait attack cooldown before allowing next attack
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true
