extends "res://Enemies/Enemy.gd"

signal state_changed(new_state)

const Bullet = preload("res://Enemies/EnemyBullet.tscn")


onready var playerDetectionZone = $PlayerDetectionZone
onready var animationPlayer = $AnimationPlayer
onready var firePoint = $FirePoint
onready var shotTimer = $ShotTimer
onready var playerCast = $FirePoint/PlayerCast

export var shots_to_fire = 4
var shots_fired = 0

enum State{
	PATROL,
	AIM,
	SHOOT
}

var current_state : int = -1 setget set_state


# Called when the node enters the scene tree for the first time.
func _ready():
	set_state(State.PATROL)




func _physics_process(delta):
	if player != null:
		can_see_player()
	
	match current_state:
		State.PATROL:
			pass
		State.AIM:
			pass
		State.SHOOT:
			pass

func can_see_player():
	var player_pos = player.get_global_position()
	var ray_pos = playerCast.get_global_position()
	var ray_vector = player_pos - ray_pos
	playerCast.set_cast_to(ray_vector)
	var coll = playerCast.get_collider()
	


func set_state(new_state: int):
	if new_state == current_state:
		return
	if new_state == State.AIM:
		animationPlayer.play("summon")
	current_state = new_state
	emit_signal("state_changed", current_state)


func fire():
	var bullet = Bullet.instance()
	var vec_to_player = player.get_global_position() - firePoint.get_global_position()
	vec_to_player = vec_to_player.normalized()
	bullet.init(vec_to_player)
	bullet.set_global_position(firePoint.get_global_position())
	get_parent().add_child(bullet)
	
	shots_fired += 1
	
	shotTimer.start()




func _on_PlayerDetectionZone_body_entered(body):
	if body.is_in_group("player"):
		player = body
		var player_pos = player.get_global_position() * 2
		player_pos = to_local(player_pos)
		playerCast.set_cast_to(player_pos) 
		playerCast.force_raycast_update()
		var cast_location = playerCast.get_cast_to()
		
		var coll = playerCast.get_collider()
		if playerCast.is_colliding() and coll.is_in_group("player"):
			set_state(State.AIM)


func _on_ShotTimer_timeout():
	if shots_fired < shots_to_fire:
		fire()
	else:
		set_state(State.PATROL)
