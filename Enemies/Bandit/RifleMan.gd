extends "res://Enemies/Bandit/Bandit2.gd"


onready var shootCast = $ShootCast
onready var fireSound = $FireSound
const gun_damage = 1
var rng

func _ready():
	._ready()
	rng = RandomNumberGenerator.new()
	rng.randomize()


func fire():
#	vector to player
	var player_pos = player.get_global_position()
	var ray_pos = shootCast.get_global_position()
	var ray_vector = player_pos - ray_pos
	
#	to be used later to make the adjusted_ray_vector long enough
	var distance_to_player = ray_vector.length()
	
#	convert to radians and add a random adjustment to it
	var ray_radians = ray_vector.angle()
	var adjustment = rng.randfn(0.0, 0.1)
	ray_radians += adjustment


#	convert back to a vector
	var adjusted_ray_vector = Vector2(cos(ray_radians), sin(ray_radians))
	adjusted_ray_vector = adjusted_ray_vector * distance_to_player
	
	shootCast.set_cast_to(adjusted_ray_vector)
	
	shootCast.force_raycast_update ( )
	
	
	var coll = shootCast.get_collider()
	if shootCast.is_colliding() and coll.is_in_group("player"):
		coll.take_damage(gun_damage)
	
	set_state(State.PAUSE)
	
	fireSound.play()

