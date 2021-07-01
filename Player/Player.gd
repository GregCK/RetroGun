extends KinematicBody2D
class_name Player

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var camera = $PlayerCam
onready var center = $Weapon
onready var stats = $Stats
onready var blinkAnimationPlayer = $BlinkAnimationPlayer

const ACCELERATION = 500
const MAX_SPEED = 100
const FRICTION = 500

var velocity = Vector2.ZERO

func _physics_process(delta):
	move_state(delta)
	set_camera(delta)

func move_state(delta):
#	handle movement
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		set_flip(input_vector)
		
		animationPlayer.play("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationPlayer.play("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	


func move():
	velocity = move_and_slide(velocity)

#calcs position between mouse and player
#lerp between current cam pos and middle_pos
func set_camera(delta):
	var mouse_pos = get_global_mouse_position()
	var player_pos = center.get_global_position()
	var middle_x = (mouse_pos.x + player_pos.x) / 2.5
	var middle_y = (mouse_pos.y + player_pos.y) / 2.5
	var middle_pos = Vector2(middle_x, middle_y)
	
	var cam_pos = camera.get_global_position()
	
	var camSpeed = 4
	var new_cam_pos = lerp(cam_pos, middle_pos, camSpeed * delta)
	
	camera.set_global_position(new_cam_pos)

func set_flip(input_vector):
	if input_vector.x < 0:
		sprite.set_flip_h(true)
	elif input_vector.x > 0:
		sprite.set_flip_h(false)


func _on_Hurtbox_area_entered(area):
	if not area.get("damage") == null:
		stats.health -= area.damage
		blinkAnimationPlayer.play("Start")
	else:
		print("area does not have damage car")
