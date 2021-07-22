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
	PAUSE,
	FOLLOW
}


var current_state : int = -1 setget set_state


const move_speed = 80

func _ready():
	playerCast = $PlayerCast
	set_state(State.STRAFE)

func _physics_process(delta):
	seeLabel.text = str(can_see_player())
	match current_state:
		State.IDLE:
			if can_see_player():
				set_state(State.AIM)
		State.AIM:
			pass
		State.STRAFE:
			velocity = move_and_slide(velocity)
		State.PAUSE:
			pass
		State.FOLLOW:
			follow_state()


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
			
			if player != null:
				var vec_to_player = get_vector_to_player()
				var distance_to_player = vec_to_player.length()
				pass
				if distance_to_player > 200:
					pass

			
			
			var x = rand_range(-1, 1)
			var y = rand_range(-1, 1)
			velocity = Vector2(x, y).normalized() * move_speed
			
			
			strafeTimer.wait_time = rand_range(0.2, 1)
			strafeTimer.start()
		State.PAUSE:
			stateLabel.text = "PAUSE"
			velocity = Vector2.ZERO
			pauseTimer.wait_time = rand_range(0.0, 1)
			pauseTimer.start()
		State.FOLLOW:
			stateLabel.text = "FOLLOW"
			
	
	
	current_state = new_state
	emit_signal("state_changed", current_state)


func follow_state():
	if can_see_player():
		set_state(State.PAUSE)
	else:
		var smell_dir = can_smell_player()
		if smell_dir == null:
			set_state(State.STRAFE)
			return
		velocity = smell_dir * move_speed
		velocity = move_and_slide(velocity)
		


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
		var move = randi() % 3
		if move == 0:
			set_state(State.STRAFE)
		elif move > 0:
			set_state(State.AIM)
	else:
		set_state(State.FOLLOW)
	
