extends Node2D

const Explosion = preload("res://Effects/Explosion.tscn")

func create_explosion_effect():
	var explosion = Explosion.instance()
	var parent = get_parent().get_parent()
	parent.call_deferred("add_child", explosion)
	explosion.global_position = global_position
