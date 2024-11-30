extends Node

var enemy_just_died = false
var level_active: bool = true

@export var player: Player


func _ready() -> void:
	EventBus.enemy_death.connect(enemy_dead)
	for e in get_children():
		e.find_child("EnemySightLine").target = player
		if e is GunnerEnemy:
			e.player = player


func _process(_delta: float) -> void:
	if get_children() == [] and level_active:
		EventBus.level_complete.emit()
		level_active = false


func enemy_dead() -> void:
	enemy_just_died = true
