extends Area2D

var direction: Vector2
var speed: float = 120
var starting_position: Vector2 = Vector2(100,100)
var damage: int = 10

var frozen: bool = false

@export var plink_sound: AudioStream

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func init(end_of_barrel, target):
	starting_position = end_of_barrel
	direction = Vector2(target - end_of_barrel).normalized()
	rotation = direction.angle()


func _ready() -> void:
	position = starting_position
	body_entered.connect(hit)
	animation_player.animation_finished.connect(bullet_break)


func bullet_break(anim_name: String) -> void:
	if anim_name == "break":
		queue_free()


func _physics_process(delta: float) -> void:
	if not frozen:
		position += direction * speed * delta


func hit(body: Node2D) -> void:
	if body.has_method("hurt"):
		body.hurt(damage)
		SFXPlayer.play(plink_sound)
	animation_player.play("break")
	frozen = true
