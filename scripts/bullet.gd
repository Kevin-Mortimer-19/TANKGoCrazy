extends Node2D

var direction: Vector2
var speed: float = 250
var starting_position: Vector2 = Vector2(100,100)

var frozen: bool = false

@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func init(start_of_barrel, end_of_barrel):
	starting_position = end_of_barrel
	direction = Vector2(end_of_barrel - start_of_barrel).normalized()
	rotation = direction.angle()


func _ready():
	position = starting_position
	area_2d.body_entered.connect(hit)
	area_2d.area_entered.connect(hit)
	animation_player.animation_finished.connect(bullet_break)


func _physics_process(delta: float) -> void:
	if not frozen:
		position += direction * speed * delta


func bullet_break(anim_name: String) -> void:
	if anim_name == "break":
		queue_free()


func hit(body: Node2D) -> void:
	if body.has_method("die"):
		body.die()
	animation_player.play("break")
	frozen = true
	sprite_2d.frame = 1
