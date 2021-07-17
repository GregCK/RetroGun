extends "res://Enemies/Bandit/Bandit.gd"


onready var shootCast = $ShootCast
const gun_damage = 1


func fire():
#	var vec_to_player = player.get_global_position() - firePoint.get_global_position()
#	vec_to_player = vec_to_player.normalized()
	var player_pos = player.get_global_position()
	var ray_pos = shootCast.get_global_position()
	var ray_vector = player_pos - ray_pos

	shootCast.set_cast_to(ray_vector)
	shootCast.force_raycast_update ( )
	var coll = shootCast.get_collider()
	if shootCast.is_colliding() and coll.is_in_group("player"):
		coll.take_damage(gun_damage)
	
	set_state(State.PAUSE)

func _on_StrafeTimer_timeout():
	set_state(State.PAUSE)


func _on_PauseTimer_timeout():
	if can_see_player():
		var move = randi() % 2
		if move == 0:
			set_state(State.AIM)
		elif move == 1:
			set_state(State.STRAFE)
	else:
		set_state(State.STRAFE)
	
