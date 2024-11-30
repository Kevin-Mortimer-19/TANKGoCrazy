class_name VictoryMenu extends MarginContainer

@export var sound : AudioStream

@onready var next_button: Button = $HBoxContainer/NextButton
@onready var quit_button: Button = $HBoxContainer/QuitButton

var next_level_data: Level


func _ready() -> void:
	next_button.pressed.connect(next_level)
	quit_button.pressed.connect(quit_game)


func quit_game() -> void:
	SFXPlayer.play(sound)
	get_tree().quit()


func next_level() -> void:
	SFXPlayer.play(sound)
	if next_level_data != null:
		EventBus.change_level.emit(next_level_data)
	else:
		quit_game()
