extends "res://Enemies/Enemy.gd"

signal state_changed(new_state)

const Bullet = preload("res://Enemies/EnemyBullet.tscn")


onready var playerDetectionZone = $PlayerDetectionZone
onready var animationPlayer = $AnimationPlayer
onready var firePoint = $FirePoint


enum State{
	PATROL,
	ENGAGE
}

var current_state : int = -1 setget set_state
var player : Player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	set_state(State.PATROL)




func _physics_process(delta):
	match current_state:
		State.PATROL:
			pass
		State.ENGAGE:
			pass

func set_state(new_state: int):
	if new_state == current_state:
		return
	if new_state == State.ENGAGE:
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


func _on_PlayerDetectionZone_body_entered(body):
	if body.is_in_group("player"):
		player = body
		set_state(State.ENGAGE)
