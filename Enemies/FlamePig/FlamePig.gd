extends "res://Enemies/Enemy.gd"


onready var animationPlayer = $AnimationPlayer
onready var stateLabel = $StateLabel
onready var seeLabel = $SeeLabel

enum State{
	IDLE,
	ALIGN,
	CHARGE
}


var current_state : int = -1 setget set_state

func _ready():
	playerCast = $PlayerCast
	set_state(State.IDLE)


func _physics_process(delta):
	seeLabel.text = str(can_see_player())
	match current_state:
		State.IDLE:
			if can_see_player():
				set_state(State.ALIGN)
		State.ALIGN:
			align_state(delta)
		State.CHARGE:
			pass

func align_state(delta):
	var player_dir_vector = playerCast.get_cast_to()
	var player_dir_radians = player_dir_vector.angle()
	var player_dir_degrees = rad2deg(player_dir_radians)
	
	
#	rotation_degrees = lerp(rotation_degrees, player_dir_degrees, 0.1)
	var old_rotation_radians = deg2rad(rotation_degrees)
	var new_rotation_radians = lerp_angle(old_rotation_radians, player_dir_radians, 0.1)
	
	rotation_degrees = rad2deg(new_rotation_radians)

func set_state(new_state: int):
	if new_state == current_state:
		return
	match new_state:
		State.IDLE:
			stateLabel.text = "IDLE"
			animationPlayer.play("idle")
		State.ALIGN:
			stateLabel.text = "ALIGN"
			animationPlayer.play("idle")
		State.CHARGE:
			stateLabel.text = "CHARGE"
			animationPlayer.play("charge")
	
	current_state = new_state
	emit_signal("state_changed", current_state)


static func lerp_angle(from, to, weight):
	return from + _short_angle_dist(from, to) * weight

static func _short_angle_dist(from, to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference
