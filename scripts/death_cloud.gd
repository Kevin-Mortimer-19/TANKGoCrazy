extends AnimatedSprite2D


func _ready() -> void:
	play()
	animation_finished.connect(end)


func end() -> void:
	queue_free()
