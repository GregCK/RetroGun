extends Node


const generatedWorld = preload("res://World/GeneratedWorld.tscn")
const lvl4 = preload("res://World/Levels/TestLvl4.tscn")
const lvl6 = preload("res://World/Levels/Lvl6.tscn")
const lvl7 = preload("res://World/Levels/Lvl7.tscn")
const lvl8 = preload("res://World/Levels/Lvl8.tscn")
const lvl9 = preload("res://World/Levels/Lvl9.tscn")
const premade_lvls = [lvl4, lvl6, lvl7,lvl8,lvl9]

func reload_level():
	get_tree().reload_current_scene()


func next_level():
	var n = Globals.floor_num % 2
	if n == 0:
		pick_premade_level()
	else:
		get_tree().change_scene_to(generatedWorld)


func pick_premade_level():
	var n = randi() % premade_lvls.size()
	get_tree().change_scene_to(premade_lvls[n])
#	match n:
#		0:
#			get_tree().change_scene_to(lvl4)
#		1:
#			get_tree().change_scene_to(lvl6)
