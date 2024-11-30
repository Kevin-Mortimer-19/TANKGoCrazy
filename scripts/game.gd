extends Control

var victory_menu = preload("res://scenes/ui/victory_menu.tscn")
var death_menu = preload("res://scenes/ui/death_menu.tscn")
var win_game_menu = preload("res://scenes/ui/win_game_menu.tscn")
var title = preload("res://scenes/ui/title_screen.tscn")
var credits = preload("res://scenes/ui/credits.tscn")

@export var first_level: Level

var active_level: Level

@onready var hud: MarginContainer = $HUDViewportContainer/SubViewport/HUD

@onready var world_viewport: SubViewport = $WorldViewportContainer/SubViewport
@onready var menu_viewport: SubViewport = $MenuViewportContainer/SubViewport


func _ready() -> void:
	EventBus.level_complete.connect(win)
	EventBus.change_level.connect(change_level)
	EventBus.return_to_title.connect(return_to_title)
	EventBus.death.connect(lose)
	EventBus.open_credits.connect(switch_to_credits)
	
	EventBus.change_level.emit(first_level)


func win() -> void:
	SFXPlayer.end_loop()
	var w
	if active_level.next_level == null:
		w = win_game_menu.instantiate()
	else:
		w = victory_menu.instantiate()
		w.next_level_data = active_level.next_level
	w.position = Vector2(320, 180)
	menu_viewport.add_child(w)
	get_tree().paused = true


func lose() -> void:
	var l = death_menu.instantiate()
	l.current_level_data = active_level
	l.position = Vector2(320, 180)
	menu_viewport.add_child(l)
	SFXPlayer.end_loop()
	get_tree().paused = true


func change_level(new_level: Level) -> void:
	for c in world_viewport.get_children():
		if c is World:
			c.queue_free()
	for c in menu_viewport.get_children():
		if c is VictoryMenu or DeathMenu:
			c.queue_free()
	active_level = new_level
	get_tree().paused = false
	var w = active_level.current_level.instantiate()
	world_viewport.add_child(w)
	hud.find_child("ProgressBar").update(100)


func return_to_title() -> void:
	for c in world_viewport.get_children():
		c.queue_free()
	for c in menu_viewport.get_children():
		c.queue_free()
	var title_scene = title.instantiate()
	get_tree().root.add_child(title_scene)
	queue_free()


func switch_to_credits() -> void:
	for c in world_viewport.get_children():
		c.queue_free()
	for c in menu_viewport.get_children():
		c.queue_free()
	var credits_scene = credits.instantiate()
	get_tree().root.add_child(credits_scene)
	queue_free()
	
