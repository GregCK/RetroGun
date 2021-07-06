extends Node2D

const Player = preload("res://Player/Player.tscn")


var borders = Rect2(1, 1, 27, 17)

onready var tileMap = $TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	generate_level()


func generate_level():
	var walker = Walker.new(Vector2(15, 10), borders)
	var map = walker.walk(400)
	
	var player = Player.instance()
	add_child(player)
	player.position = map.front() * 32
	
	walker.queue_free()
	for location in map:
		tileMap.set_cellv(location, -1)
	tileMap.update_bitmask_region(borders.position, borders.end)
