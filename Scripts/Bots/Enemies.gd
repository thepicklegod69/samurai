extends Node2D

@export var BotScene: PackedScene
# @onready var enemies_container = $Enemies

func _ready() -> void:
	spawn_bot(Vector2(300, 200))

func spawn_bot(position: Vector2) -> void:
	var bot = BotScene.instantiate()
	bot.position = position
#	enemies_container.add_child(bot)
