extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var stats = $Stats

var parent = null

func _ready():
	parent = get_parent()


func _on_Hurtbox_area_entered(area):
	blinkAnimationPlayer.play("Start")
	stats.health -= area.damage
#	knockback = area.knockback_vector * 120


func _on_Stats_no_health():
	var effect = EnemyDeathEffect.instance()
	effect.set_global_position(get_global_position())
	parent.add_child(effect)
	
	queue_free()
	
