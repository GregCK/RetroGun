extends "res://Enemies/Enemy.gd"



const Bullet = preload("res://Enemies/EnemyBullet.tscn")

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var firePoint = $FirePoint
onready var shotTimer = $ShotTimer
onready var idleTimer = $IdleTimer
onready var patrolTimer = $PatrolTimer
onready var strafeTimer = $StrafeTimer
onready var spellSound = $SpellSound
onready var stateLabel = $StateLabel
onready var seeLabel = $SeeLabel

export var shots_to_fire = 3
var shots_fired = 0


const move_speed = 80

enum State{
	IDLE,
	PATROL,
	AIM,
	CHASE,
	STRAFE
}

var current_state : int = -1 setget set_state


# Called when the node enters the scene tree for the first time.
func _ready():
	set_state(State.IDLE)
	playerCast = $FirePoint/PlayerCast



func _physics_process(delta):
	seeLabel.text = str(can_see_player())
	
	match current_state:
		State.IDLE:
			if can_see_player():
				set_state(State.AIM)
		State.PATROL:
			if can_see_player():
				set_state(State.AIM)
			else:
				move()
		State.AIM:
			pass
		State.CHASE:
			chase_state()
		State.STRAFE:
			move()




func set_state(new_state: int):
	if new_state == current_state:
		return
	idleTimer.stop()
	patrolTimer.stop()
	match new_state:
		State.IDLE:
			animationPlayer.play("stand")
			idleTimer.start()
			stateLabel.text = "IDLE"
			print("IDLE")
		State.PATROL:
			animationPlayer.play("walk")
			var x = rand_range(-1, 1)
			var y = rand_range(-1, 1)
			velocity = Vector2(x, y).normalized() * move_speed
			patrolTimer.start()
			stateLabel.text = "PATROL"
			print("PATROL")
		State.AIM:
			animationPlayer.play("summon")
			stateLabel.text = "AIM"
			print("AIM")
		State.CHASE:
			animationPlayer.play("walk")
			stateLabel.text = "CHASE"
			print("CHASE")
		State.STRAFE:
			animationPlayer.play("walk")
			var x = rand_range(-1, 1)
			var y = rand_range(-1, 1)
			velocity = Vector2(x, y).normalized() * move_speed
			
			stateLabel.text = "STRAFE"
			print("CHASE")
	current_state = new_state
	emit_signal("state_changed", current_state)


func chase_state():
	if can_see_player():
		set_state(State.AIM)
	else:
		var smell_dir = can_smell_player()
		if smell_dir == null:
			set_state(State.PATROL)
			return
		else:
			velocity = smell_dir * move_speed
			move()
		

func fire():
	var bullet = Bullet.instance()
	var vec_to_player = player.get_global_position() - firePoint.get_global_position()
	vec_to_player = vec_to_player.normalized()
	bullet.init(vec_to_player)
	bullet.set_global_position(firePoint.get_global_position())
	get_parent().add_child(bullet)
	
	shots_fired += 1
	
	spellSound.play()
	
	if can_see_player():
		shotTimer.start()
	else:
		set_state(State.CHASE)



func move():
	velocity = move_and_slide(velocity)



func _on_ShotTimer_timeout():
	if shots_fired < shots_to_fire:
		fire()
		if shots_fired == shots_to_fire:
			animationPlayer.play("lower")
	else:
		shots_fired = 0
		set_state(State.PATROL)


func _on_IdleTimer_timeout():
	set_state(State.PATROL)


func _on_PatrolTimer_timeout():
	set_state(State.IDLE)


func _on_StrafeTimer_timeout():
	if can_see_player():
		set_state(State.AIM)
	else:
		set_state(State.CHASE)
