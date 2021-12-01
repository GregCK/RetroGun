extends KinematicBody2D
class_name Player

const scent_scene = preload("res://Player/Scent.tscn")

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var rollAnimationPlayer = $AnimationPlayer/AnimationPlayer
onready var skullAnimationPlayer = $SkullAnimationPlayer
onready var camera = $PlayerCam
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var hurtSound = $HurtSound
onready var dashSound = $DashSound
onready var hurtboxCollisionShape = $Hurtbox/CollisionShape2D
onready var pickupMagnet = $PickupMagnet
onready var weaponIcons = $WeaponManager/CanvasLayer/WeaponIcons
onready var dashTimer = $DashTimer


const ACCELERATION = 560
const MAX_SPEED = 120
const FRICTION = 500
const KNOCKBACK_FRICTION = 1000
const DASH_SPEED = 350

var velocity = Vector2.ZERO
var dash_vector = Vector2.DOWN
var knockback = Vector2.ZERO

export(bool) var god_mode = true

var world = null

var scent_trail = []
var scentTimer = null
var scentWaitTime = 0.1

enum State{
	MOVE,
	DASH,
	PORTAL,
	DEAD
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
	





func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, KNOCKBACK_FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match current_state:
		State.MOVE:
			move_state(delta)
		State.DASH:
			move()
		State.PORTAL:
			portal_state(delta)
		State.DASH:
			pass
	set_camera(delta)



func set_state(new_state: int):
	if new_state == current_state:
		return
	match new_state:
		State.MOVE:
			pass
		State.DASH:
			velocity = dash_vector * DASH_SPEED
			hurtboxCollisionShape.disabled = true
			animationPlayer.play("Dash")
			if !sprite.is_flipped_h():
				rollAnimationPlayer.play("RollCW")
			else:
				rollAnimationPlayer.play("RollCCW")
			dashSound.play()
			
			dashTimer.start()
			
		State.PORTAL:
			animationPlayer.play("RollLoop")
		
		State.DEAD:
			pass
	current_state = new_state 


func move_state(delta):
#	handle movement
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		dash_vector = input_vector
		set_flip(input_vector)
		
		animationPlayer.play("Run")
		
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationPlayer.play("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	
	if Input.is_action_just_pressed("dash") and dashTimer.get_time_left() == 0:
		set_state(State.DASH)
	

func portal_state(delta):
	var vec_to_portal = get_vector_to_portal()
	var dist_to_portal = vec_to_portal.length()
	vec_to_portal = vec_to_portal.normalized()
	
	var portal_gravity = 500 / dist_to_portal
	
	velocity = velocity.move_toward(vec_to_portal * (portal_gravity), ACCELERATION * delta)
	
	move()


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

func change_knockback(direction, amount):
	var knockback_adjustment = direction * amount
	knockback += knockback_adjustment


func add_scent():
#	generate scent
	var scent = scent_scene.instance()
	scent.set_player(self)
	world.call_deferred("add_child",scent)
#	var position = self.get_global_transform()
	var position = $CollisionShape2D.get_global_transform()
	scent.set_global_transform(position)
	
	
	scent_trail.push_front(scent)


func dash_animation_finished():
	velocity = velocity / 2
	hurtboxCollisionShape.disabled = false
	set_state(State.MOVE)
	

var portal = null
func set_portal():
	portal = get_parent().get_node("Portal")
	set_state(State.PORTAL)
	pass
	

func get_vector_to_portal():
	if portal != null:
		var portal_pos = portal.position
		var my_pos = position
		var difference:Vector2 = portal_pos - my_pos
		return difference
	return null


func _on_Hurtbox_area_entered(area):
	if not area.get("damage") == null:
		take_damage(area.damage)
	else:
		print("area does not have damage car")

func take_damage(damage):
	PlayerStats.health -= damage
	if god_mode:
		if PlayerStats.health < (PlayerStats.max_health/2):
			PlayerStats.health = PlayerStats.max_health
#	blinkAnimationPlayer.play("Start")
	hurtSound.play()
	
	if PlayerStats.health <= 0:
		play_dead()




func play_dead():
	sprite.visible = false
#	hurtboxCollisionShape.disabled = true
	hurtboxCollisionShape.set_deferred("disabled", true)
	set_state(State.DEAD)
	$WeaponManager.queue_free()


func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")


func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")
