extends Control

var game = load("res://scenes/game.tscn")

@export var sound : AudioStream

@onready var start_button: Button = $MarginContainer/VBoxContainer/StartButton
@onready var quit_button: Button = $MarginContainer/VBoxContainer/QuitButton


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)
	start_button.pressed.connect(start_game)
	quit_button.pressed.connect(quit_game)


func start_game() -> void:
	SFXPlayer.play(sound)
	var game_scene = game.instantiate()
	get_tree().root.add_child(game_scene)
	queue_free()


func quit_game() -> void:
	get_tree().quit()
