extends "res://Enemies/Enemy.gd"

signal state_changed(new_state)


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
			if !can_see_player():
				set_state(State.PATROL)
			chase_state(delta)


func chase_state(delta):
	var player_pos = player.get_global_position()
	var self_pos = get_global_position()
	var vec_to_player = player_pos - self_pos
	vec_to_player = vec_to_player.normalized()
	velocity = vec_to_player * speed
	move()


func move():
	velocity = move_and_slide(velocity)

func set_state(new_state: int):
	if new_state == current_state:
		return
	
	current_state = new_state
	emit_signal("state_changed", current_state)
