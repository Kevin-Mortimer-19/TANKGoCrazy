class_name WinGameMenu extends MarginContainer

@export var sound : AudioStream

@onready var title_button: Button = $HBoxContainer/NextButton
@onready var credits_button: Button = $"HBoxContainer/Credits Button"
@onready var quit_button: Button = $HBoxContainer/QuitButton

var next_level_data: Level


func _ready() -> void:
	title_button.pressed.connect(return_to_title)
	credits_button.pressed.connect(open_credits)
	quit_button.pressed.connect(quit_game)


func quit_game() -> void:
	get_tree().quit()


func open_credits() -> void:
	SFXPlayer.play(sound)
	EventBus.open_credits.emit()


func return_to_title() -> void:
	SFXPlayer.play(sound)
	EventBus.return_to_title.emit()
