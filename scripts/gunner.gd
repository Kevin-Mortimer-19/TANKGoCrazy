class_name GunnerEnemy extends CharacterBody2D

var move_speed = 30
var min_time_between_moves: float = 0.5
var max_time_between_moves: float = 0.51
var move_time: float = 1.0
var moving: bool = false
var direction: Vector2 = Vector2.RIGHT
var new_angle: Vector2 = Vector2.UP
var turn_speed: float = 1/30.0
var turn_sharpness: float = 30.0
var wall_vision_scalar = 8

var reload_time: float = 1.5
var time_between_shots: float = 0.1
var shots_per_reload: int = 3
var shots_fired: int = 0

var active: bool = false

var rng: RandomNumberGenerator

@export var shoot_sound: AudioStream
@export var die_sound: AudioStream

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var move_timer: Timer = $MoveTimer

@onready var ray: RayCast2D = $EnemySightLine
@onready var wall_sight_line: RayCast2D = $WallSightLine

@onready var shoot_timer: Timer = $ShootTimer
@onready var reload_timer: Timer = $ReloadTimer
@onready var end_of_barrel: Marker2D = $EndOfBarrel
@onready var visible_on_screen_enabler_2d: VisibleOnScreenEnabler2D = $VisibleOnScreenEnabler2D

var bullet = load("res://scenes/sub-scenes/enemy_bullet.tscn")
var death = load("res://scenes/sub-scenes/death_cloud.tscn")

var player: Player

signal activated


func _ready() -> void:

	rng = RandomNumberGenerator.new()
	rng.randomize()
	animated_sprite_2d.frame = rng.randi_range(0,3)
	animated_sprite_2d.play("move")
	
	move_timer.wait_time = rng.randf_range(min_time_between_moves, max_time_between_moves)
	move_timer.timeout.connect(update_move)
	move_timer.start()
	
	shoot_timer.wait_time = time_between_shots
	shoot_timer.timeout.connect(pull_trigger)
	reload_timer.wait_time = reload_time
	reload_timer.timeout.connect(reload)


func _physics_process(_delta: float) -> void:
	flip()
	velocity = direction * move_speed
	if active:
		direction = direction.move_toward(new_angle, turn_speed)
		move_and_slide()


func activate() -> void:
	active = true
	visible_on_screen_enabler_2d.queue_free()
	reload_timer.start()
	activated.emit()


func die():
	SFXPlayer.play(die_sound)
	EventBus.enemy_death.emit()
	var cloud = death.instantiate()
	cloud.position = position
	get_parent().get_parent().add_child(cloud)
	queue_free()


func run_over(_body) -> void:
	die()


func flip() -> void:
	if player != null:
		if player.position.x > position.x and animated_sprite_2d.scale.x == 0.5:
			animated_sprite_2d.scale.x = -0.5
			end_of_barrel.position.x = 2.5
		elif player.position.x < position.x and animated_sprite_2d.scale.x == -0.5:
			animated_sprite_2d.scale.x = 0.5
			end_of_barrel.position.x = -2.5


func update_move() -> void:
	move_timer.wait_time = rng.randf_range(min_time_between_moves, max_time_between_moves)
	wall_sight_line.target_position = new_angle * wall_vision_scalar
	wall_sight_line.force_raycast_update()
	if wall_sight_line.is_colliding():
		direction = new_angle.rotated(deg_to_rad(180))
	else:
		direction = new_angle
	var coin_flip = rng.randi_range(0,1)
	if coin_flip == 0:
		new_angle = direction.rotated(deg_to_rad(-turn_sharpness))
	else:
		new_angle = direction.rotated(deg_to_rad(turn_sharpness))
	move_timer.start()


func pick_new_direction() -> Vector2:
	var looking_at_wall = true
	var d = Vector2.RIGHT.rotated(deg_to_rad(rng.randi_range(0,359))) * wall_vision_scalar
	while looking_at_wall:
		wall_sight_line.target_position = d
		wall_sight_line.force_raycast_update()
		if wall_sight_line.is_colliding():
			d = Vector2.RIGHT.rotated(deg_to_rad(rng.randi_range(0,359)))
		else:
			looking_at_wall = false
	return d.normalized()


func pull_trigger() -> void:
	shots_fired += 1
	fire()
	if shots_fired == shots_per_reload:
		reload_timer.start()
	else:
		shoot_timer.start()


func reload() -> void:
	shots_fired = 0
	pull_trigger()


func fire() -> void:
	SFXPlayer.play(shoot_sound)
	if player != null:
		var b = bullet.instantiate()
		b.init(end_of_barrel.global_position, player.global_position)
		get_parent().get_parent().add_child(b)
