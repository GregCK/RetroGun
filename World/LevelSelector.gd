extends Node


const generatedWorld = preload("res://World/GeneratedWorld.tscn")
const lvl4 = preload("res://World/Levels/TestLvl4.tscn")

func reload_level():
	get_tree().reload_current_scene()


func next_level():
	var n = Globals.floor_num % 2
	if n == 0:
		get_tree().change_scene_to(lvl4)
	else:
		get_tree().change_scene_to(generatedWorld)
