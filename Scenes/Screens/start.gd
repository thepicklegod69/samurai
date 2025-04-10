extends Node2D

#@onready var player_icon = $Panel/Container/PlayerIcon
#@onready var choose_button = $Panel/Container/ChoosePlayerButton

# Reference to the currently selected character name
var selected_character: String = "Player1"

@onready var character_buttons := {
	"Player1": $Panel/VBoxContainer/Characters/Player1,
	"Player2": $Panel/VBoxContainer/Characters/Player2
}

# Load your player icons and keep track of which one is selected
var CHARACTERS = {
"Player1": preload("res://Art/Samurai_characters/Samurai_(1-6)/Samurai_#1/Preview.png"),
"Player2": preload("res://Art/Samurai_characters/Samurai_(1-6)/Samurai_#2/Preview.png")
}
var current_player = "Player1"

func _ready():
	$Panel/VBoxContainer/Menu/PlayButton.pressed.connect(on_play_pressed)
	$Panel/VBoxContainer/Menu/QuitButton.pressed.connect(on_quit_pressed)
	
	# Set up button signals
	for btns in character_buttons.keys():
		character_buttons[btns].pressed.connect(_on_character_pressed.bind(btns))

	# Set initial selection visual
	_highlight_selected(selected_character)

func on_play_pressed():
	# Store the current player in a global singleton or pass it to the next scene
	Global.player_choice = current_player
	get_tree().change_scene_to_file("res://Scenes/Maps/game.tscn")

func on_quit_pressed():
	get_tree().quit()

func _on_character_pressed(name: String):
	selected_character = name
	_highlight_selected(name)
	if (name) == "Player1" :
		Global.selected_player_scene = preload("res://Scenes/Players/Player1.tscn")
	else:
		Global.selected_player_scene = preload("res://Scenes/Players/Player2.tscn")	
	
func _highlight_selected(name: String):
	for char_name in character_buttons.keys():
		var btn = character_buttons[char_name]
		if char_name == name:
			btn.modulate = Color(1, 1, 1, 1) # Fully visible (or bright)
		else:
			btn.modulate = Color(0.5, 0.5, 0.5, 1) # Dim to indicate not selected
