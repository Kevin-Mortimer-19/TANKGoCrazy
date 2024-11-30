class_name World extends Node2D

@export var player: CharacterBody2D
@export var camera: Camera2D
@export var tilemap: TileMapLayer


func _ready() -> void:
	camera.player = player
	camera.tilemap = tilemap
