class_name Player extends CharacterBody2D


const TURN_SPEED = 400
const TURN_RATE = 100
const MOVE_SPEED = 35
const ACCELERATION = 5
const FRICTION = 100

var time_between_shots: float = 0.25

var max_health = 100
var current_health = 100

var frozen: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shoot_timer: Timer = $ShootTimer
@onready var barrel: Node2D = $Barrel

@export var small_explosion: AudioStream
@export var large_explosion: AudioStream
@export var move_sound: AudioStream


func _ready() -> void:
	animation_player.animation_finished.connect(check_animations)
	shoot_timer.wait_time = time_between_shots
	barrel.player = self


func _physics_process(delta: float) -> void:
	if not frozen:
		handle_rotation(delta)
		handle_move()
		
		move_and_slide()
		check_for_enemies()


func handle_rotation(delta) -> void:
	if Input.is_action_pressed("turn_left"):
		rotation_degrees = move_toward(rotation_degrees, rotation_degrees - TURN_SPEED, TURN_RATE * delta)
	elif Input.is_action_pressed("turn_right"):
		rotation_degrees = move_toward(rotation_degrees, rotation_degrees + TURN_SPEED, TURN_RATE * delta)


func handle_move() -> void:
	var moving = false
	var move_back = false
	if Input.is_action_pressed("move_forward"):
		velocity = velocity.move_toward(Vector2.UP.rotated(rotation) * MOVE_SPEED, ACCELERATION)
		moving = true
		if not SFXPlayer.looping:
			SFXPlayer.start_loop(move_sound)
	elif Input.is_action_pressed("move_back"):
		velocity = velocity.move_toward(Vector2.DOWN.rotated(rotation) * MOVE_SPEED, ACCELERATION)
		moving = true
		move_back = true
		if not SFXPlayer.looping:
			SFXPlayer.start_loop(move_sound)
	else:
		velocity = velocity.move_toward(Vector2(0, 0), FRICTION)
		SFXPlayer.end_loop()
	play_animations(moving, move_back)


func check_for_enemies() -> void:
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider().has_method("die"):
			c.get_collider().die()


func play_animations(playing: bool, move_back: bool):
	if move_back:
		animation_player.speed_scale = -1.2
	else:
		animation_player.speed_scale = 1.2
	if not playing and animation_player.is_playing():
		animation_player.pause()
	elif playing and not animation_player.is_playing():
		animation_player.play("tank_treads")


func hurt(percent_of_health: int):
	current_health -= percent_of_health
	EventBus.player_health_changed.emit(current_health)
	if current_health <= 0:
		die()


func check_animations(anim_name: String) -> void:
	if anim_name == "death":
		EventBus.death.emit()
		queue_free()


func die() -> void:
	animation_player.speed_scale = 1.2
	if not frozen:
		frozen = true
		if animation_player.is_playing():
			animation_player.stop()
		animation_player.play("death")


func play_small_death_sound() -> void:
	SFXPlayer.play(small_explosion)


func play_big_death_sound() -> void:
	SFXPlayer.play(large_explosion)
