extends CharacterBody2D

var move_speed = 30
var move_time: float = 0.5
var moving: bool = false
var direction: Vector2 = Vector2.RIGHT
var new_angle: Vector2 = Vector2.UP
var turn_speed: float = 1/30.0
var turn_sharpness: float = 30.0
var wall_vision_scalar = 8

var active: bool = false

var rng: RandomNumberGenerator

@export var die_sound: AudioStream

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var move_timer: Timer = $MoveTimer

@onready var ray: RayCast2D = $EnemySightLine
@onready var wall_sight_line: RayCast2D = $WallSightLine
@onready var visible_on_screen_enabler_2d: VisibleOnScreenEnabler2D = $VisibleOnScreenEnabler2D

var death = load("res://scenes/sub-scenes/death_cloud.tscn")

signal activated


func _ready() -> void:
	rng = RandomNumberGenerator.new()
	rng.randomize()
	animated_sprite_2d.frame = rng.randi_range(0,3)
	animated_sprite_2d.play("move")
	
	direction = pick_new_direction()
	
	move_timer.wait_time = move_time
	move_timer.timeout.connect(update_move)
	move_timer.start()


func _physics_process(_delta: float) -> void:
	velocity = direction * move_speed
	if active:
		direction = direction.move_toward(new_angle, turn_speed)
		move_and_slide()


func activate() -> void:
	visible_on_screen_enabler_2d.queue_free()
	active = true
	activated.emit()


func die():
	SFXPlayer.play(die_sound)
	var cloud = death.instantiate()
	cloud.position = position
	get_parent().get_parent().add_child(cloud)
	EventBus.enemy_death.emit()
	queue_free()


func run_over(_body) -> void:
	die()


func update_move() -> void:
	move_timer.wait_time = move_time
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
