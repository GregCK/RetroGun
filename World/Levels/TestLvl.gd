extends Node2D

onready var tilemap = $LevelNavigation/TileMap
onready var player = $Player

const floor_index = 9

func _ready():
	Globals.floor_num += 1
	player.connect("fall", self, "find_spawn_point")

func reload_level():
	get_tree().reload_current_scene()

func _physics_process(delta):
	var coordinates = tilemap.world_to_map(player.position)
	var tile_index = tilemap.get_cellv(coordinates)
	if tile_index == floor_index:
		player.over_hole()
	var tile_str = str(tile_index)
	$CanvasLayer/Label.set_text(tile_str)

func find_spawn_point(scents):
	for s in scents:
#		var s_pos = scents[scents.size() - 1].get_position()
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


func get_distance(s_pos, player_pos):
	var distance = (player_pos - s_pos).length()
	return distance
