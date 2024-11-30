extends Node2D

var initial_bomb_drop: float = 1.2
var min_time_between_bombs: float = 2.0
var max_time_between_bombs: float = 6.0
var bombs_on_hand: int = 4
var bombs_dropped: int = 0

var rng: RandomNumberGenerator

@onready var bomb_timer: Timer = $"../BombTimer"

var Bomb = preload("res://scenes/sub-scenes/bomb.tscn")
@onready var enemy: CharacterBody2D = $".."


func _ready() -> void:
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
	bomb_timer.wait_time = initial_bomb_drop
	bomb_timer.timeout.connect(drop_bomb)
	
	enemy.activated.connect(wake_up)


func wake_up() -> void:
	bomb_timer.start()


func drop_bomb() -> void:
	if bombs_dropped < bombs_on_hand:
		var b = Bomb.instantiate()
		get_parent().get_parent().get_parent().add_child(b)
		b.position = global_position
		bombs_dropped += 1
		bomb_timer.wait_time = rng.randf_range(min_time_between_bombs, max_time_between_bombs)
		bomb_timer.start()
