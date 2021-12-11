extends Node2D

onready var tilemap = $LevelNavigation/TileMap

func _ready():
	Globals.floor_num += 1

func reload_level():
	get_tree().reload_current_scene()

func _physics_process(delta):
	var coordinates = tilemap.world_to_map($Player.position)
	var tile_index = tilemap.get_cellv(coordinates)
	var tile_str = str(tile_index)
	$CanvasLayer/Label.set_text(tile_str)

