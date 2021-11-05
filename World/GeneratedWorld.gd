extends Node2D

const Player = preload("res://Player/Player.tscn")

var Goblin = load("res://Enemies/Goblin/Goblin.tscn")
var Turret = load("res://Enemies/Goblin/Turret.tscn" )
var ChaseGhost = load("res://Enemies/Ghost/ChaseGhost.tscn")
var ChaseGhostAStar = load("res://Enemies/Ghost/ChaseGhostAStar.tscn")
var Bandit = load("res://Enemies/Bandit/Bandit.tscn")
var FlamePig = load("res://Enemies/FlamePig/FlamePig.tscn")
var RifleMan = load("res://Enemies/Bandit/RifleMan.tscn")
var Shooter = load("res://Enemies/Shooter/Shooter.tscn")
var AggresiveShooter = load("res://Enemies/Shooter/AggresiveShooter.tscn")
var CautionShooter = load("res://Enemies/Shooter/CautionShooter.tscn")
var TNTEnemy = load("res://Enemies/TNTEnemy/TNTEnemy.tscn")
var Bouncer = load("res://Enemies/Bouncer/Bouncer.tscn")

var TNT = load("res://Objects/TNT.tscn")
var WeaponPickup = load("res://Objects/Pickups/WeaponPickup.tscn")
var HealthPickup = load("res://Objects/Pickups/HealthPickup.tscn")

onready var tileMap = $LevelNavigation/TileMap
onready var label = $CanvasLayer/Label


var borders = Rect2(1, 1, 95, 67) #size of the grid in generated world 
const tile_size = 32
const offset = Vector2(16, 16) #half the size of a tile
var map

var taken_positions = []
var enemies = []
var player_pos

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	Globals.floor_num += 1
	generate_level()
	
	var floor_num = Globals.floor_num
	var label_text = "Floor: " + str(floor_num)
	label.text = label_text


func generate_level():
	
	var walker = Walker.new(Vector2(15, 10), borders)
	map = walker.walk(200)
	walker.queue_free()
	
	
	
#	remove tiles for all vectors in var map
	for location in map:
#		tileMap.set_cellv(location, -1) #clears the cell
		tileMap.set_cellv(location, 3)
	tileMap.update_bitmask_region(borders.position, borders.end)
	
	
	add_player()
	
	add_objects()
	
#	shuffles so do last
	add_enemies()
	





func add_player():
	var player = Player.instance()
	add_child(player)
	player_pos = (map.pop_front() * tile_size) + offset
	player.position = player_pos
	


#careful! this one shuffles the map locations! do this one last
func add_enemies():
#	map.shuffle()

#	create array of enemies and spawn a segment of those enemies
	var num_enemies = 1
	var enemies_to_spawn = []
	
##
	for i in range(15):
		enemies_to_spawn.append(Turret)


	for i in range(10):
		enemies_to_spawn.append(ChaseGhostAStar)

	for i in range(30):
		enemies_to_spawn.append(CautionShooter)
	
	for i in range(20):
		enemies_to_spawn.append(AggresiveShooter)

	for i in range(10):
		enemies_to_spawn.append(TNTEnemy)
	
	for i in range(10):
		enemies_to_spawn.append(Bouncer)
	
	num_enemies = 1 + (Globals.floor_num)
	enemies_to_spawn.shuffle()
	for i in range(num_enemies):
		add_enemy(enemies_to_spawn[i])



func add_enemy(enemy_type):
	var enemy = null
#	match enemy_type:
#		Goblin:
#			enemy = Goblin.instance()
#		ChaseGhost:
#			enemy = ChaseGhost.instance()
	enemy = enemy_type.instance()
	
#	replace by find_open_position()
#	var enemy_pos
#	while true:
#		var i = randi() % map.size()
#		enemy_pos = (map[i] * tile_size) + offset
#		var distance_to_player = enemy_pos.distance_to(player_pos)
#		if distance_to_player > 250 and !taken_positions.has(enemy_pos):
#			break
	
	
	var enemy_pos = find_open_position()
	enemy.position = enemy_pos
	
	
	add_child(enemy)
	enemies.append(enemy)


func add_objects():
	add_object(TNT)
	add_object(WeaponPickup)
	add_object(HealthPickup)


func add_object(new_object):
	var object = new_object.instance()
	var object_pos = find_open_position()
	object.position = object_pos
	add_child(object)
	


func find_open_position():
	var pos
	while true:
		var i = randi() % map.size()
		pos = (map[i] * tile_size) + offset
		var distance_to_player = pos.distance_to(player_pos)
		if distance_to_player > 250 and !taken_positions.has(pos):
			taken_positions.append(pos)
			return pos

func reload_level():
	get_tree().reload_current_scene()

