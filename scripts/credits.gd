extends Control

var title = preload("res://scenes/ui/title_screen.tscn")

@export var sound : AudioStream

@onready var title_button: Button = $MarginContainer/HBoxContainer/Column1/TitleButton
@onready var quit_button: Button = $MarginContainer/HBoxContainer/Column3/QuitButton


func _ready() -> void:
	title_button.pressed.connect(return_to_title)
	quit_button.pressed.connect(quit_game)


func return_to_title() -> void:
	SFXPlayer.play(sound)
	var title_scene = title.instantiate()
	get_tree().root.add_child(title_scene)
	queue_free()


func quit_game() -> void:
	get_tree().quit()
