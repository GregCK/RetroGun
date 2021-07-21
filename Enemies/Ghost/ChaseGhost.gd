extends "res://Enemies/Enemy.gd"



onready var sprite = $Sprite
onready var wallCast = $WallCast
onready var softCollision = $SoftCollision

enum State{
	PATROL,
	CHASE
}

var current_state : int = -1 setget set_state



const patrol_directions = [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]
var patrol_direction = Vector2.RIGHT

const speed = 50

func _ready():
	set_state(State.PATROL)
	velocity = patrol_direction * speed
	playerCast = $PlayerCast





func _physics_process(delta):
	match current_state:
		State.PATROL:
			if can_see_player():
				set_state(State.CHASE)
			else:
				patrol_state()
		State.CHASE:
			chase_state(delta)
	
	if softCollision.is_colliding():
		velocity = velocity + (softCollision.get_push_vector() * delta * 400)



func patrol_state():
	if velocity.length() < velocity.normalized().length():
		change_patrol_direction()
	wallCast.set_cast_to(velocity.normalized() * 8)
	if wallCast.is_colliding():
		change_patrol_direction()
	else:
		pass
	
	move()

func change_patrol_direction():
	patrol_direction = patrol_directions[randi() % 4]
	velocity = patrol_direction * speed

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


func _on_ChangeDirection_timeout():
	if current_state == State.PATROL:
		change_patrol_direction()
