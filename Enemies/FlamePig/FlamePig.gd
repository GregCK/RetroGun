extends "res://Enemies/Enemy.gd"


onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite
onready var alignTimer = $AlignTimer
onready var stateLabel = $StateLabel
onready var seeLabel = $SeeLabel

enum State{
	IDLE,
	ALIGN,
	CHARGE
}

const charge_speed = 300
const idle_speed = 25


var current_state : int = -1 setget set_state

func _ready():
	playerCast = $PlayerCast
	set_state(State.IDLE)


func _physics_process(delta):
	seeLabel.text = str(can_see_player())
	velocity = move_and_slide(velocity)
	
	if get_slide_count() > 0:
		var collision = get_slide_collision(0)
		var bounce_amount = velocity.length() * 0.5
		velocity = velocity + collision.get_normal() * bounce_amount
	
	match current_state:
		State.IDLE:
			idle_state()
		State.ALIGN:
			align_state(delta)
		State.CHARGE:
			charge_state(delta)


func idle_state():
	if can_see_player():
		var r = randi() % 100
		if r == 0:
			set_state(State.ALIGN)

	velocity = velocity + Vector2( rand_range(-10, 10), rand_range(-10, 10) )
	velocity = velocity.normalized() * idle_speed


func align_state(delta):
	var player_dir_radians = get_player_dir_radians()

	var old_rotation_radians = deg2rad(sprite.rotation_degrees)
	var new_rotation_radians = lerp_angle(old_rotation_radians, player_dir_radians, 0.1)
	
	sprite.rotation_degrees = rad2deg(new_rotation_radians)
	



func charge_state(delta):
	if get_slide_count() > 0:
		set_state(State.IDLE)

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
			alignTimer.start()
		State.CHARGE:
			stateLabel.text = "CHARGE"
			animationPlayer.play("charge")
			var charge_dir = playerCast.get_cast_to().normalized()
			sprite.rotation_degrees = rad2deg( get_player_dir_radians() )
			velocity = charge_dir * charge_speed
	
	current_state = new_state
	emit_signal("state_changed", current_state)




func get_player_dir_radians():
	var player_dir_vector = playerCast.get_cast_to()
	var player_dir_radians = player_dir_vector.angle() - PI/2
	return player_dir_radians

static func lerp_angle(from, to, weight):
	return from + _short_angle_dist(from, to) * weight

static func _short_angle_dist(from, to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference


func _on_AlignTimer_timeout():
	set_state(State.CHARGE)
