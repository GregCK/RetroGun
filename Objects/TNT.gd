extends KinematicBody2D


const Explosion = preload("res://Effects/Explosion.tscn")


func explode():
	create_explosion_effect()
	queue_free()

func create_explosion_effect():
	var explosion = Explosion.instance()
	var parent = get_parent()
	parent.call_deferred("add_child", explosion)
	explosion.global_position = global_position

func _on_Hurtbox_area_entered(area):
	explode()
