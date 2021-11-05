extends Node2D


func _ready():
	Globals.floor_num += 1

func reload_level():
	get_tree().reload_current_scene()

