extends "res://Enemies/Enemy.gd"

const Bullet = preload("res://Enemies/EnemyBullet.tscn")

onready var seeLabel = $SeeLabel
onready var stateLabel = $StateLabel
onready var firePoint = $FirePoint
onready var animationPlayer = $AnimationPlayer
onready var strafeTimer = $StrafeTimer
onready var delayedPauseTimer = $DelayedPauseTimer
onready var pauseTimer = $PauseTimer
onready var closeDistanceTimer = $CloseDistanceTimer
onready var line2d = $Line2D

enum State{
	IDLE,
	AIM,
	STRAFE,
	PAUSE,
	DELAYED_PAUSE,
	FOLLOW,
	CLOSE_DISTANCE
}


var current_state : int = -1 setget set_state
var last_state : int


const move_speed = 80

func _ready():
	playerCast = $PlayerCast
	softCollision = $SoftCollision
	set_level_nav()
	set_state(State.STRAFE)

func _physics_process(delta):
	line2d.global_position = Vector2.ZERO
	seeLabel.text = str(can_see_player())
	
	detect_softCollision(delta)
	
	match current_state:
		State.IDLE:
			if can_see_player():
				set_state(State.AIM)
		State.AIM:
			pass
		State.STRAFE:
			move()
		State.PAUSE:
			pass
		State.FOLLOW:
			follow_state()
		State.CLOSE_DISTANCE:
			close_distance_state()
		State.DELAYED_PAUSE:
			move()


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
		State.CLOSE_DISTANCE:
			stateLabel.text = "CLOSE_DISTANCE"
			closeDistanceTimer.start()
		State.DELAYED_PAUSE:
			stateLabel.text = "DELAYED_PAUSE"
			var delayTime = rand_range(0.1, 3.0)
			delayedPauseTimer.start()
			
			
	
	
	current_state = new_state
	emit_signal("state_changed", current_state)


func close_distance_state():
	if player and levelNavigation:
		line2d.points = generate_path_to_player()
		navigate(move_speed)
		move()
	
	if get_distance_to_player() < 100:
		end_close_distance()

func follow_state():
	if can_see_player():
#		set_state(State.PAUSE)
		set_state(State.DELAYED_PAUSE)
	else:
#		maybe do this at set_state
		generate_level_nav()
		move()
		

func generate_level_nav():
	if player and levelNavigation:
#		this may cause a bug where path is generated,
#		enemy is on point[0] so it is removed, then generated again
#		this causes enemy to stutter
		line2d.points = generate_path_to_player()
		navigate(move_speed)


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
#		var move = randi() % 3
		var move = randf()
		if move < 0.6:
			set_state(State.AIM)
		elif move < 0.9:
			set_state(State.CLOSE_DISTANCE)
		else:
			set_state(State.STRAFE)
#		if move == 0:
#			set_state(State.CLOSE_DISTANCE)
#		elif move > 0:
#			set_state(State.AIM)
	else:
		set_state(State.FOLLOW)
	


func _on_CloseDistanceTimer_timeout():
	end_close_distance()

func end_close_distance():
	if current_state == State.CLOSE_DISTANCE:
		set_state(State.PAUSE)


func _on_DelayedPauseTimer_timeout():
	set_state(State.PAUSE)
