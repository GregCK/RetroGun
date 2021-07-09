extends Node2D

const Player = preload("res://Player/Player.tscn")

var Goblin = load("res://Enemies/Goblin/Goblin.tscn")
var Turret = load("res://Enemies/Goblin/Turret.tscn" )
var ChaseGhost = load("res://Enemies/Ghost/ChaseGhost.tscn")

onready var tileMap = $TileMap



var borders = Rect2(1, 1, 84, 60)
const tile_size = 32
const offset = Vector2(16, 16)
var map

var enemies = []
var player_pos

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	generate_level()


func generate_level():
	var walker = Walker.new(Vector2(15, 10), borders)
	map = walker.walk(200)
	walker.queue_free()
	
	
#	remove tiles for all vectors in var map
	for location in map:
		tileMap.set_cellv(location, -1)
	tileMap.update_bitmask_region(borders.position, borders.end)
	
	
	add_player()
	
#	shuffles so do last
	add_enemies()
	


func add_player():
	var player = Player.instance()
	add_child(player)
	player_pos = (map.pop_front() * tile_size) + offset
	player.position = player_pos
	


#careful! this one shiffles the map locations! do this one last
func add_enemies():
#	map.shuffle()
	for i in range(4):
		add_enemy(Turret)
	for i in range(4):
		add_enemy(ChaseGhost)



func add_enemy(enemy_type):
	var enemy = null
#	match enemy_type:
#		Goblin:
#			enemy = Goblin.instance()
#		ChaseGhost:
#			enemy = ChaseGhost.instance()
	enemy = enemy_type.instance()
	
	
	var enemy_pos
	while true:
		var i = randi() % map.size()
		enemy_pos = (map[i] * tile_size) + offset
		var distance_to_player = enemy_pos.distance_to(player_pos)
		if distance_to_player > 250:
			break
	
	
	
	enemy.position = enemy_pos
	
	
	add_child(enemy)
	enemies.append(enemy)




func reload_level():
	get_tree().reload_current_scene()

