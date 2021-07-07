extends Node2D

const Player = preload("res://Player/Player.tscn")

const Goblin = preload("res://Enemies/Goblin.tscn")
const ChaseGhost = preload("res://Enemies/ChaseGhost.tscn")

onready var tileMap = $TileMap



var borders = Rect2(1, 1, 27, 17)
const tile_size = 32
const offset = Vector2(16, 16)
var map


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	generate_level()


func generate_level():
	var walker = Walker.new(Vector2(15, 10), borders)
	map = walker.walk(400)
	walker.queue_free()
	
	
#	remove tiles for all vectors in var map
	for location in map:
		tileMap.set_cellv(location, -1)
	tileMap.update_bitmask_region(borders.position, borders.end)
	
	
	add_player()
	add_enemies()


func add_player():
	var player = Player.instance()
	add_child(player)
	player.position = (map.pop_front() * tile_size) + offset


func add_enemies():
	map.shuffle()
	for i in range(4):
		add_enemy(Goblin)
	for i in range(4):
		add_enemy(ChaseGhost)

func add_enemy(enemy_type):
	var enemy = null
	match enemy_type:
		Goblin:
			enemy = Goblin.instance()
		ChaseGhost:
			enemy = ChaseGhost.instance()
	
	add_child(enemy)
	enemy.position = (map.pop_front() * tile_size) + offset
