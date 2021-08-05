extends Node2D

const Bullet = preload("res://Player/Bullets/PlayerBullet.tscn")
const BigBullet = preload("res://Player/Bullets/PlayerBulletBig.tscn")

onready var sprite = $Pistol
onready var firepoint = $Firepoint
onready var audioStreamPlayer = $AudioStreamPlayer
onready var muzzleFlareSprite = $MuzzleFlareSprite
onready var muzzleFlareTimer = $MuzzleFlareSprite/Timer
onready var gunPitchTimer = $GunPitchTimer
onready var shotTimer = $ShotTimer
var world
var rng =  RandomNumberGenerator.new()

var can_shoot = true


export(int, "regular", "big") var bullet_type
export(int) var camera_shake

# Called when the node enters the scene tree for the first time.
func _ready():
	world = get_parent().get_parent().get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var mousePos = get_global_mouse_position()
	look_at(mousePos)
	var isLeft = isFacingLeft()
	sprite.set_flip_v(isLeft)
	muzzleFlareSprite.set_flip_v(isLeft)
	
	


func isFacingLeft():
	var mousePos = get_global_mouse_position()
	var playePos = get_parent().get_global_position()
	if(mousePos != null && mousePos.x < playePos.x):
		return true
	else:
		return false


func handle_input():
	if Input.is_action_pressed("click"):
		var mouse_pos = get_global_mouse_position()
		var self_pos = get_global_position()
		var direction = mouse_pos - self_pos
		direction = direction.normalized()

		attack(direction)


#const default_pitch = 0.7
export(float) var default_pitch = 0.7
var pitch : float = default_pitch
func attack(direction:Vector2):
	if can_shoot:
	#	create bullet
		var bullet
		match bullet_type:
			0:
				bullet = Bullet.instance()
			1:
				bullet = BigBullet.instance()
		bullet.init(direction)
		bullet.set_global_position( firepoint.get_global_position() )
		world.add_child(bullet)
		
		
		#raise pitch
		pitch = pitch + 0.01
		audioStreamPlayer.set_pitch_scale(pitch) 
		gunPitchTimer.start()
		audioStreamPlayer.play()
		
		
		muzzleFlareSprite.visible = true
		muzzleFlareTimer.start()
		
		Globals.camera.shake(camera_shake, 0.1, 200)
		
		can_shoot = false
		shotTimer.start()


func _on_Timer_timeout():
	muzzleFlareSprite.visible = false


func _on_GunPitchTimer_timeout():
	pitch = default_pitch


func _on_ShotTimer_timeout():
	can_shoot = true
