extends "res://Enemies/Enemy.gd"

onready var line2d = $Line2D
onready var sprite = $Sprite

enum State{
	IDLE,
	CHASE
}

var current_state : int = -1 setget set_state

var speed : int = 70
export (int) var my_max_health = 5


const KNOCKBACK_FRICTION = 200

func _ready():
	playerCast = $PlayerCast
	set_state(State.IDLE)
	
	stats.set_max_health(my_max_health)
	stats.set_health(my_max_health)
	softCollision = $SoftCollision
	
	yield(get_tree(), "idle_frame")
	set_level_nav()
	softCollision = $SoftCollision
#	if tree.has_group("player"):
#		player = tree.get_nodes_in_group("player")[0]



func set_state(new_state:int):
	current_state = new_state

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, KNOCKBACK_FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match current_state:
		State.IDLE:
			if can_see_player():
				set_state(State.CHASE)
		State.CHASE:
			chase_state(delta)
	
	set_look_direction()
	move()

func set_look_direction():
#	determine which way to look
	var dir = Vector2.ZERO
	if abs(velocity.x) > abs(velocity.y):
		if velocity.x < 0:
			dir = Vector2.LEFT
		else:
			dir = Vector2.RIGHT
	else:
		if velocity.y < 0:
			dir = Vector2.UP
		else:
			dir = Vector2.DOWN
	
#	set sprite looking at movement dir
	match dir:
		Vector2.UP:
			sprite.frame = 3
		Vector2.LEFT:
			sprite.frame = 2
		Vector2.DOWN:
			sprite.frame = 1
		Vector2.LEFT:
			sprite.frame = 0


func chase_state(delta):
	line2d.global_position = Vector2.ZERO
	if player and levelNavigation:
		line2d.points = generate_path_to_player()
#		navigate(speed)
		navigate_gradual(speed, delta)
		
	detect_softCollision(delta)
