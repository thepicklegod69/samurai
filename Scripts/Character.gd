extends CharacterBody2D
class_name Character

# —— Stats —— #
@export var max_health: int = 100
@export var weapon_strength: int = 20
@export var block_strength: int = 10
@export var max_stamina: int = 100
@export var stamina_regen_rate: float = 10.0
@export var stamina_cost_attack: int = 20
@export var stamina_cost_block: int = 10

var health: int = 100
var stamina: float = 100

# —— Signals —— #
signal health_changed(new_health: int)
signal stamina_changed(new_stamina: float)
signal died(attacker)

func _ready() -> void:
	health = max_health
	stamina = max_stamina

func take_damage(amount: int, attacker=null) -> void:
	health = clamp(health - amount, 0, max_health)
	emit_signal("health_changed", health)
	if health == 0:
		emit_signal("died", attacker)
		die()

func attack(target: Character) -> void:
	if stamina >= stamina_cost_attack:
		stamina -= stamina_cost_attack
		emit_signal("stamina_changed", stamina)
		target.take_damage(weapon_strength, self)

func block() -> bool:
	if stamina >= stamina_cost_block:
		stamina -= stamina_cost_block
		emit_signal("stamina_changed", stamina)
		return true
	return false

func regenerate_stamina(delta: float) -> void:
	stamina = clamp(stamina + stamina_regen_rate * delta, 0, max_stamina)
	emit_signal("stamina_changed", stamina)

func is_alive() -> bool:
	return health > 0

func die() -> void:
	print("Player died")
	get_tree().change_scene("res://scenes/GameOver.tscn")
	queue_free()
	
func heal(amount: int) -> void:
	health = clamp(health + amount, 0, max_health)
	emit_signal("health_changed", health)
