extends Area2D


var knockback_vector = Vector2.ZERO

export var damage = 3
export var knockback_amount = 2.0

func set_knockback_amount(new_amount):
	knockback_amount = new_amount

func set_knockback_vector(dir: Vector2):
	knockback_vector = dir.normalized() * knockback_amount
