extends Node2D

onready var tilemap = $LevelNavigation/TileMap
onready var player = $Player

const floor_index = 9

var falling_enemies

func _ready():
	Globals.floor_num += 1
	player.connect("fall", self, "find_spawn_point")
	falling_enemies = get_tree().get_nodes_in_group("falling_enemies")
	for e in falling_enemies:
		e.connect("die", self, "remove_falling_enemy")

func reload_level():
	get_tree().reload_current_scene()

func _physics_process(delta):
#	check if player is over hole
	var coordinates = tilemap.world_to_map(player.position)
	var tile_index = tilemap.get_cellv(coordinates)
	if tile_index == floor_index:
		player.over_hole()
	
	for e in falling_enemies:
		coordinates = tilemap.world_to_map(e.position)
		tile_index = tilemap.get_cellv(coordinates)
		if tile_index == floor_index:
			e.fall()


func find_spawn_point(scents):
	for s in scents:
		var s_pos = s.get_position()
		var coordinates = tilemap.world_to_map(s_pos)
		var tile_index = tilemap.get_cellv(coordinates)
		if tile_index != floor_index:
			var distance = get_distance(s_pos, player.position)
			if distance > 0:
				player.set_position(s_pos)
				player.take_damage(0)
				return
	
	push_error("could not find position to spawn player after fall")

func remove_falling_enemy(enemy):
	falling_enemies.erase(enemy)


func get_distance(s_pos, player_pos):
	var distance = (player_pos - s_pos).length()
	return distance
