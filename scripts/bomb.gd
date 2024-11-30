extends Area2D

var damage: int = 34

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var explode_sound: AudioStream

var explosion = load("res://scenes/sub-scenes/explosion.tscn")

func _ready() -> void:
	animated_sprite_2d.play("active")
	body_entered.connect(explode)
	area_entered.connect(explode)


func explode(body: CollisionObject2D) -> void:
	if body.has_method("hurt"):
		body.hurt(damage)
	var e = explosion.instantiate()
	e.position = position
	get_parent().add_child(e)
	SFXPlayer.play(explode_sound)
	queue_free()
