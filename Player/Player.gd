extends KinematicBody2D
class_name Player

const scent_scene = preload("res://Player/Scent.tscn")

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var camera = $PlayerCam
onready var center = $Weapon
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var hurtSound = $HurtSound
onready var hurtboxCollisionShape = $Hurtbox/CollisionShape2D


const ACCELERATION = 500
const MAX_SPEED = 100
const FRICTION = 500
const DASH_SPEED = 200

var velocity = Vector2.ZERO

var hits = 0

var world = null

var scent_trail = []
var scentTimer = null
var scentWaitTime = 0.1

enum State{
	MOVE,
	DASH
}

var current_state : int = -1 setget set_state

func _ready():
	yield(get_tree(), "idle_frame")
	get_tree().call_group("enemies", "set_player", self)
	
	
	set_state(State.MOVE)
	
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
	match current_state:
		State.MOVE:
			move_state(delta)
		State.DASH:
			move()
	set_camera(delta)



func set_state(new_state: int):
	if new_state == current_state:
		return
	match new_state:
		State.MOVE:
			pass
		State.DASH:
			var mouse_pos = get_global_mouse_position()
			var self_pos = get_global_position()
			var direction = mouse_pos - self_pos
			direction = direction.normalized()
			velocity = direction * DASH_SPEED
			hurtboxCollisionShape.disabled = true
			animationPlayer.play("Dash")
			
	current_state = new_state 


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
	
	
	if Input.is_action_just_pressed("dash"):
		set_state(State.DASH)
	


func move():
	velocity = move_and_slide(velocity)


func set_camera(delta):
	var mouse_pos = get_global_mouse_position()
	var player_pos = get_global_position()


	var diff = mouse_pos - player_pos
	diff = diff / 3
	if diff.length() > 100:
		diff = diff.normalized() * 100
	camera.position = diff
	pass


func set_flip(input_vector):
	if input_vector.x < 0:
		sprite.set_flip_h(true)
	elif input_vector.x > 0:
		sprite.set_flip_h(false)

func add_scent():
#	generate scent
	var scent = scent_scene.instance()
	scent.set_player(self)
	world.call_deferred("add_child",scent)
	var position = self.get_global_transform()
	scent.set_global_transform(position)
	
	
	scent_trail.push_front(scent)


func dash_animation_finished():
	hurtboxCollisionShape.disabled = false
	set_state(State.MOVE)
	

func _on_Hurtbox_area_entered(area):
	if not area.get("damage") == null:
		PlayerStats.health -= area.damage
		blinkAnimationPlayer.play("Start")
		hurtSound.play()
	else:
		print("area does not have damage car")
