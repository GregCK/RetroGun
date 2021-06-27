extends Node2D

const Bullet = preload("res://Player/PlayerBullet.tscn")

onready var sprite = $Pistol
onready var firepoint = $Firepoint
onready var audioStreamPlayer = $AudioStreamPlayer
onready var muzzleFlareSprite = $MuzzleFlareSprite
onready var muzzleFlareTimer = $MuzzleFlareSprite/Timer
onready var gunPitchTimer = $GunPitchTimer
var world
var rng =  RandomNumberGenerator.new()

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

const default_pitch = 0.7
var pitch : float = default_pitch
func attack(direction:Vector2):
#	create bullet
	var bullet = Bullet.instance()
	bullet.init(direction)
	bullet.set_global_position( firepoint.get_global_position() )
	world.add_child(bullet)
	
	
	#raise pitch
	pitch = pitch + 0.02
	audioStreamPlayer.set_pitch_scale(pitch) 
	gunPitchTimer.start()
	audioStreamPlayer.play()
	
	
	muzzleFlareSprite.visible = true
	muzzleFlareTimer.start()
	
	Globals.camera.shake(50, 0.1, 200)


func _on_Timer_timeout():
	muzzleFlareSprite.visible = false


func _on_GunPitchTimer_timeout():
	pitch = default_pitch
