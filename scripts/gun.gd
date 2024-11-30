extends Node2D

var shoot_buffer_time: float = 0.125

var player: Player
var bullet = load("res://scenes/sub-scenes/bullet.tscn")

@onready var end_of_barrel: Node2D = $"end of barrel"
@onready var shoot_buffer_timer: Timer = $ShootBufferTimer
@onready var base_sprite: Sprite2D = $Base

@export var shoot_sound: AudioStream

func _ready() -> void:
	shoot_buffer_timer.wait_time = shoot_buffer_time
	EventBus.player_health_changed.connect(update_health_sprite)


func _process(_delta: float) -> void:
	var mouse_position = get_local_mouse_position()
	rotation += mouse_position.angle() * 0.75
	fire()


func update_health_sprite(current_health: float) -> void:
	if current_health <= 33:
		base_sprite.frame = 2
	elif current_health <= 66 and current_health > 33:
		base_sprite.frame = 1
	else:
		base_sprite.frame = 0


func fire():
	if (Input.is_action_just_pressed("fire") or not shoot_buffer_timer.is_stopped()) and player.shoot_timer.is_stopped():
		if not shoot_buffer_timer.is_stopped():
			shoot_buffer_timer.stop()
		player.shoot_timer.start()
		var b = bullet.instantiate()
		b.init(global_position, end_of_barrel.global_position)
		get_parent().get_parent().add_child(b)
		SFXPlayer.play(shoot_sound)
	elif Input.is_action_just_pressed("fire") and not player.shoot_timer.is_stopped() and shoot_buffer_timer.is_stopped():
		shoot_buffer_timer.start()
