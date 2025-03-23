extends ProgressBar

@export var player_path: NodePath
@onready var player = get_node_or_null(player_path)

func _ready() -> void:
	if not player:
		push_error("HealthBar: player_path is invalid!")
		print("HealthBar not player")
		return
		
	print("DEBUG → Player.max_health:", player.max_health, "player.health:", player.health)

	max_value = player.max_health
	player.connect("health_changed", Callable(self, "_on_health_changed"))
	_on_health_changed(player.health)  # immediately sync UI to current health	value = player.health
	print("HealthBar visible:", visible, "value:", value)

func _on_health_changed(new_health: int) -> void:
	value = new_health
