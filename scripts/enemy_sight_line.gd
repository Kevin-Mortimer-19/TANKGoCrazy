extends RayCast2D

var target: Player


func _process(_delta: float) -> void:
	if target != null:
		target_position = target.position - get_parent().position
		if is_colliding():
			if get_collider() is Player:
				get_parent().activate()
				queue_free()
