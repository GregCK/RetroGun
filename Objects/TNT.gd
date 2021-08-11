extends KinematicBody2D


onready var explosionCreator = $ExplosionCreator


func explode():
	explosionCreator.create_explosion_effect()
	queue_free()



func _on_Hurtbox_area_entered(area):
	explode()
