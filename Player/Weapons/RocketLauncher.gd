extends "res://Player/Weapons/WeaponParent.gd"

const Rocket = preload("res://Player/Bullets/Rocket.tscn")


onready var firepoint = $Firepoint
onready var audioStreamPlayer = $AudioStreamPlayer
onready var muzzleFlareTimer = $MuzzleFlareSprite/Timer
onready var gunPitchTimer = $GunPitchTimer
onready var shotTimer = $ShotTimer
onready var click = $Click

var rng =  RandomNumberGenerator.new()

var can_shoot = true

const weapon_name = "Rocket Launcher"

var ammo = 3

var camera_shake = 150

const knockback_amount = 200
signal give_knockback(direction, amount)

signal ammo_changed(ammo)

# Called when the node enters the scene tree for the first time.
func _ready():
	world = get_parent().get_parent().get_parent()
	sprite = $WeaponSprite
	muzzleFlareSprite = $MuzzleFlareSprite
	connect("give_knockback", player, "change_knockback")

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
	if Input.is_action_just_pressed("click"):
		var mouse_pos = get_global_mouse_position()
		var self_pos = get_global_position()
		var direction = mouse_pos - self_pos
		direction = direction.normalized()

		attack(direction)


const default_pitch = 1.5
#export(float) var default_pitch = 0.7
var pitch : float = default_pitch
func attack(direction:Vector2):
	if can_shoot and PlayerStats.rocketLaucherAmmo > 0:
	#	create rocket
		var rocket
		rocket = Rocket.instance()
		rocket.init(direction)
		rocket.set_global_position( firepoint.get_global_position() )
		world.add_child(rocket)
		
		
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
		
		emit_signal("give_knockback", -direction, knockback_amount)

		PlayerStats.rocketLaucherAmmo -=1
		emit_signal("ammo_changed", PlayerStats.rocketLaucherAmmo)
	elif PlayerStats.rocketLaucherAmmo <= 0:
		click.play()


func _on_Timer_timeout():
	muzzleFlareSprite.visible = false


func _on_GunPitchTimer_timeout():
	pitch = default_pitch


func _on_ShotTimer_timeout():
	can_shoot = true
