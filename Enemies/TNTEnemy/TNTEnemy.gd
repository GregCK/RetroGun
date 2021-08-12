extends "res://Enemies/Enemy.gd"

onready var sprite = $Sprite
onready var stateLabel = $StateLabel
onready var animationPlayer = $AnimationPlayer
onready var rollAnimationPlayer = $AnimationPlayer/AnimationPlayer
onready var diveTimer = $DiveTimer
onready var explosionCreator = $ExplosionCreator


enum State{
	IDLE,
	CLOSE_DISTANCE,
	DIVE
}

const move_speed = 70
const dive_speed = 120
const FRICTION = 400
const ACCELERATION = 300

var current_state : int = -1 setget set_state

func _ready():
	playerCast = $PlayerCast
	softCollision = $SoftCollision
	set_level_nav()
	set_state(State.IDLE)

func set_state(new_state:int):
	match new_state:
		State.IDLE:
			pass
		State.CLOSE_DISTANCE:
			animationPlayer.play("Walk")
		State.DIVE:
			animationPlayer.play("Fuse")
			if get_vector_to_player().x < 0:
				rollAnimationPlayer.play("RollCCW")
			else:
				rollAnimationPlayer.play("RollCW")
			velocity = get_vector_to_player().normalized() * dive_speed
			diveTimer.start()
	
	
	current_state = new_state
	stateLabel.text = str(new_state)

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	detect_softCollision(delta)
	
	var see_player = can_see_player()
	
	match current_state:
		State.IDLE:
			if see_player:
				set_state(State.CLOSE_DISTANCE)
		State.CLOSE_DISTANCE:
			if player and levelNavigation:
				generate_path_to_player()
				navigate_gradual(move_speed, delta)

	
			if get_distance_to_player() < 100 and see_player:
				set_state(State.DIVE)
		State.DIVE:
			pass
	
	move()
	set_flip()
	
	
	








func set_flip():
	sprite.flip_h = velocity.x < 0


func _on_DiveTimer_timeout():
	explosionCreator.create_explosion_effect()
	stats.set_health(0)
