extends Range


func _ready() -> void:
	EventBus.player_health_changed.connect(update)


func update(player_health):
	value = player_health
