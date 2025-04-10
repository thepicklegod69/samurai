extends Character
class_name Bot

@export var attack_damage: int = 10
@export var attack_range: float = 50
@export var attack_interval: float = 1.5

var target: Node2D
var attack_timer := 0.0

func _ready():
	target = get_node("/root/Game/Player")
	$AttackHitbox.monitoring = false

func _physics_process(delta):
	if not target: return

	# Move toward player
	var dir = (target.position - position).normalized()
	position += dir * 100 * delta

	# Attack when in range
	attack_timer -= delta
	if attack_timer <= 0 and position.distance_to(target.position) < attack_range:
		attack_timer = attack_interval
		do_attack()

func do_attack() -> void:
	$AttackHitbox.set_meta("damage", attack_damage)
	$AttackHitbox.monitoring = true
	get_tree().create_timer(0.1)
	$AttackHitbox.monitoring = false
