extends "res://Enemies/Enemy.gd"

signal state_changed(new_state)

onready var sprite = $Sprite


enum State{
	PATROL,
	CHASE
}

var current_state : int = -1 setget set_state


var velocity = Vector2.ZERO
const speed = 50

func _ready():
	set_state(State.PATROL)
	playerCast = $PlayerCast





func _physics_process(delta):
	match current_state:
		State.PATROL:
			if can_see_player():
				set_state(State.CHASE)
		State.CHASE:
			chase_state(delta)


func chase_state(delta):
	if can_see_player():
		var player_pos = player.get_global_position()
		var self_pos = get_global_position()
		var vec_to_player = player_pos - self_pos
		vec_to_player = vec_to_player.normalized()
		velocity = vec_to_player * speed
		move()
	else:
		var smell_dir = can_smell_player()
		if smell_dir == null:
			set_state(State.PATROL)
			return
		else:
			velocity = smell_dir * speed
			move()


func _process(delta):
	if abs(velocity.x) > abs(velocity.y):
#		look horizontal
		if velocity.x > 0:
#			look right
			sprite.frame = 0
		else:
#			look left
			sprite.frame = 2
	else:
#		looking vertical
		if velocity.y > 0:
#			look down
			sprite.frame = 1
		else:
#			look down
			sprite.frame = 3
			

func move():
	velocity = move_and_slide(velocity)
	

func set_state(new_state: int):
	if new_state == current_state:
		return
	
	current_state = new_state
	emit_signal("state_changed", current_state)
