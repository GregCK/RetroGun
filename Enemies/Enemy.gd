extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var stats = $Stats
onready var playerCast = null

var parent = null
var player : Player = null

func _ready():
	parent = get_parent()
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")


func _on_Hurtbox_area_entered(area):
	blinkAnimationPlayer.play("Start")
	stats.health -= area.damage
#	knockback = area.knockback_vector * 120


func _on_Stats_no_health():
	var effect = EnemyDeathEffect.instance()
	effect.set_global_position(get_global_position())
	parent.add_child(effect)
	
	queue_free()
	



func can_see_player():
	if player != null:
		var player_pos = player.get_global_position()
		var ray_pos = playerCast.get_global_position()
		var ray_vector = player_pos - ray_pos
		playerCast.set_cast_to(ray_vector)
		var coll = playerCast.get_collider()
		if playerCast.is_colliding() and coll.is_in_group("player"):
			return true
		else:
			return false


func can_smell_player():
	var scents = get_tree().get_nodes_in_group("scents")
	var i = scents.size() - 1
	while i >= 0:
		playerCast.cast_to = (scents[i].position - position)
		playerCast.force_raycast_update()
		
		if !playerCast.is_colliding():
			return playerCast.cast_to.normalized()
		i = i - 1
	
	return null

func set_player(p):
	player = p
