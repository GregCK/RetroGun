extends Area2D


const HitEffect = preload("res://Effects/HitEffect.tscn")



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func create_hit_effect():
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

func _on_Hurtbox_area_entered(area):
#	area.create_hit_effect()
	pass
