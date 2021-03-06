extends "res://Player/Weapons/WeaponParent.gd"

const Bullet = preload("res://Player/Bullets/PlayerBullet.tscn")
const BigBullet = preload("res://Player/Bullets/PlayerBulletBig.tscn")


onready var firepoint = $Firepoint
onready var audioStreamPlayer = $AudioStreamPlayer
onready var muzzleFlareTimer = $MuzzleFlareSprite/Timer
onready var gunPitchTimer = $GunPitchTimer
onready var shotTimer = $ShotTimer
onready var click = $Click

var rng =  RandomNumberGenerator.new()
var adjustAngle = AdjustAngle.new()

var can_shoot = true

const weapon_name = "Spread Gun"

var ammo = 200

var camera_shake = 25

signal ammo_changed(ammo)

# Called when the node enters the scene tree for the first time.
func _ready():
	world = get_parent().get_parent().get_parent()
	sprite = $WeaponSprite
	muzzleFlareSprite = $MuzzleFlareSprite

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
	if can_shoot and PlayerStats.spreadGunAmmo > 0:
	#	create bullet
		var bullet
		bullet = Bullet.instance()

		
#		set small amount of bullet knockback
#		bullet.set_knockback_amount(0.5)
		
#		adjust angle
		direction = adjustAngle.randomly_rotate_vector(direction, 0.4)
		
		bullet.init(direction)
		bullet.set_global_position( firepoint.get_global_position() )
		world.add_child(bullet)
		
		
		#raise pitch
		pitch = pitch + 0.005
		audioStreamPlayer.set_pitch_scale(pitch) 
		gunPitchTimer.start()
		audioStreamPlayer.play()
		
		
		muzzleFlareSprite.visible = true
		muzzleFlareTimer.start()
		
		Globals.camera.shake(camera_shake, 0.1, 200)
		
		can_shoot = false
		shotTimer.start()

		PlayerStats.spreadGunAmmo -=1
		emit_signal("ammo_changed", PlayerStats.spreadGunAmmo)
	elif PlayerStats.spreadGunAmmo <= 0:
		click.play()



func _on_Timer_timeout():
	muzzleFlareSprite.visible = false


func _on_GunPitchTimer_timeout():
	pitch = default_pitch


func _on_ShotTimer_timeout():
	can_shoot = true
