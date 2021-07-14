extends "res://Enemies/Enemy.gd"

const Bullet = preload("res://Enemies/EnemyBullet.tscn")

onready var seeLabel = $SeeLabel
onready var stateLabel = $StateLabel
onready var firePoint = $FirePoint
onready var animationPlayer = $AnimationPlayer
onready var strafeTimer = $StrafeTimer
onready var pauseTimer = $PauseTimer

enum State{
	IDLE,
	AIM,
	STRAFE,
	PAUSE
}


var current_state : int = -1 setget set_state

var velocity = Vector2.ZERO
const move_speed = 80

func _ready():
	playerCast = $PlayerCast
	set_state(State.IDLE)

func _physics_process(delta):
	seeLabel.text = str(can_see_player())
	match current_state:
		State.IDLE:
			
			if can_see_player():
				set_state(State.AIM)
		State.AIM:
			pass
		State.STRAFE:
			
			move_and_slide(velocity)
		State.PAUSE:
			pass


func set_state(new_state: int):
	if new_state == current_state:
		return
	match new_state:
		State.IDLE:
			stateLabel.text = "IDLE"
			velocity = Vector2.ZERO
		State.AIM:
			stateLabel.text = "AIM"
			velocity = Vector2.ZERO
			animationPlayer.play("aim")
		State.STRAFE:
			stateLabel.text = "STRAFE"
			var x = rand_range(-1, 1)
			var y = rand_range(-1, 1)
			velocity = Vector2(x, y).normalized() * move_speed
			strafeTimer.start()
		State.PAUSE:
			stateLabel.text = "PAUSE"
			velocity = Vector2.ZERO
			pauseTimer.start()
			
	
	
	current_state = new_state
	emit_signal("state_changed", current_state)


func fire():
	var bullet = Bullet.instance()
	var vec_to_player = player.get_global_position() - firePoint.get_global_position()
	vec_to_player = vec_to_player.normalized()
	bullet.init(vec_to_player)
	bullet.set_global_position(firePoint.get_global_position())
	get_parent().add_child(bullet)
	
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
	
