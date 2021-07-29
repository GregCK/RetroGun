extends "res://Enemies/Enemy.gd"


const Bullet = preload("res://Enemies/EnemyBullet.tscn")

onready var stateLabel = $StateLabel
onready var seeLabel = $SeeLabel
onready var animationPlayer = $AnimationPlayer
onready var firePoint = $FirePoint
onready var spellSound = $SpellSound
onready var reactionTimer = $ReactionTimer
onready var closeDistanceTimer = $CloseDistanceTimer

enum State{
	IDLE,
	AIM,
	CLOSE_DISTANCE,
	MOVE_TO_LAST_KNOWN_LOC
}

var current_state : int = -1 setget set_state
var engaged = false
var next_state : int = -1

const move_speed = 80
const FRICTION = 200

func _ready():
	playerCast = $PlayerCast
	softCollision = $SoftCollision
	set_level_nav()
	set_state(State.IDLE)

func _physics_process(delta):
	var see_player = can_see_player()
	seeLabel.text = str(see_player)
	
	match current_state:
		State.IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			if see_player and reactionTimer.is_stopped() :
				engaged = true
				next_state = decide_tactic()
		State.AIM:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		State.CLOSE_DISTANCE:
			if player and levelNavigation:
				generate_path_to_player()
				navigate_gradual(move_speed, delta)
				move()
	
			if get_distance_to_player() < 100 and see_player:
				next_state = decide_tactic()
				
		State.MOVE_TO_LAST_KNOWN_LOC:
#			navigate_gradual(move_speed, delta)
			navigate(move_speed)
			move()

func set_state(new_state: int):
	match new_state:
		State.IDLE:
			pass
		State.AIM:
			animationPlayer.play("aim")
		State.CLOSE_DISTANCE:
			closeDistanceTimer.start()
		State.MOVE_TO_LAST_KNOWN_LOC:
			if player and levelNavigation:
#				generate_path_to_position(Globals.last_known_loc)
				generate_path_to_player()
	
	
	stateLabel.text = str(new_state)
	current_state = new_state
	emit_signal("state_changed", current_state)
	

func decide_tactic():
	if !reactionTimer.is_stopped():
		return next_state
		
	reactionTimer.start()
	if get_distance_to_player() < 100:
		return State.AIM
	else:
		var n = randf()
		if n < 0.5:
			return State.AIM
		else:
			return State.CLOSE_DISTANCE

func fire():
	var bullet = Bullet.instance()
	var vec_to_player = player.get_global_position() - firePoint.get_global_position()
	vec_to_player = vec_to_player.normalized()
	bullet.init(vec_to_player)
	bullet.set_global_position(firePoint.get_global_position())
	get_parent().add_child(bullet)
	
	spellSound.play()
	
	if can_see_player():
		next_state = decide_tactic()
	else:
		set_state(State.MOVE_TO_LAST_KNOWN_LOC)
	

func _on_ReactionTimer_timeout():
	set_state(next_state)
	next_state = -1


func _on_CloseDistanceTimer_timeout():
	if can_see_player():
		next_state = decide_tactic()
	else:
		set_state(State.MOVE_TO_LAST_KNOWN_LOC)
	
