extends Area2D


var knockback_vector = Vector2.ZERO

export var damage = 1

func set_knockback_vector(dir: Vector2):
	knockback_vector = dir
