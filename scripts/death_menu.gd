class_name DeathMenu extends MarginContainer

@export var sound : AudioStream

@onready var retry_button: Button = $HBoxContainer/RetryButton
@onready var quit_button: Button = $HBoxContainer/QuitButton

var current_level_data: Level


func _ready() -> void:
	retry_button.pressed.connect(retry_level)
	quit_button.pressed.connect(quit_game)


func quit_game() -> void:
	SFXPlayer.play(sound)
	get_tree().quit()


func retry_level() -> void:
	SFXPlayer.play(sound)
	EventBus.change_level.emit(current_level_data)
