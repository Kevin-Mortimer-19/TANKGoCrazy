extends Camera2D

var player: CharacterBody2D
var tilemap: TileMapLayer


func _ready() -> void:
	call_deferred("setup_camera")


func _process(_delta: float) -> void:
	if player != null:
		position = player.position


func setup_camera() -> void:
	var map_limits = tilemap.get_used_rect()
	var map_cellsize = tilemap.tile_set.tile_size
	limit_left = map_limits.position.x * map_cellsize.x
	limit_right = map_limits.end.x * map_cellsize.x
	limit_top = map_limits.position.y * map_cellsize.y
	limit_bottom = map_limits.end.y * map_cellsize.y
