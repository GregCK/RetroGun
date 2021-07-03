extends "res://Enemies/Enemy.gd"

signal state_changed(new_state)

const Bullet = preload("res://Enemies/EnemyBullet.tscn")

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var firePoint = $FirePoint
onready var shotTimer = $ShotTimer
onready var playerCast = $FirePoint/PlayerCast
onready var spellSound = $SpellSound

export var shots_to_fire = 3
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
	
	match current_state:
		State.PATROL:
			if can_see_player():
				set_state(State.AIM)
		State.AIM:
			pass
		State.SHOOT:
			pass

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


func set_state(new_state: int):
	if new_state == current_state:
		return
	elif new_state == State.PATROL:
		sprite.set_frame(0)
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
	
	spellSound.play()






func _on_ShotTimer_timeout():
	if shots_fired < shots_to_fire:
		fire()
		if shots_fired == shots_to_fire:
			animationPlayer.play("lower")
	else:
		shots_fired = 0
		set_state(State.PATROL)