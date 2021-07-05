extends KinematicBody2D
class_name Player

const scent_scene = preload("res://Player/Scent.tscn")

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var camera = $PlayerCam
onready var center = $Weapon
onready var stats = $Stats
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var hurtSound = $HurtSound
onready var label = $CanvasLayer/Label

const ACCELERATION = 500
const MAX_SPEED = 100
const FRICTION = 500

var velocity = Vector2.ZERO

var hits = 0

var world = null

var scent_trail = []
var scentTimer = null
var scentWaitTime = 0.1

func _ready():
	yield(get_tree(), "idle_frame")
	get_tree().call_group("enemies", "set_player", self)
	
	world = get_tree().current_scene
	
	scentTimer = Timer.new()
	scentTimer.connect("timeout",self,"add_scent")
	add_child(scentTimer) #to process
	scentTimer.wait_time = scentWaitTime
	scentTimer.start() #to start


func _process(delta):
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()

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

func add_scent():
#	generate scent
	var scent = scent_scene.instance()
	world.call_deferred("add_child",scent)
	var position = self.get_global_transform()
	scent.set_global_transform(position)
	
	
	scent_trail.push_front(scent)


func _on_Hurtbox_area_entered(area):
	if not area.get("damage") == null:
		stats.health -= area.damage
		blinkAnimationPlayer.play("Start")
		hurtSound.play()
		hits += 1
		label.set_text(String(hits))
	else:
		print("area does not have damage car")
