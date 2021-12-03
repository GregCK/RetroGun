extends Node2D

const HitEffect = preload("res://Effects/HitEffect.tscn")

onready var animationPlayer = $AnimationPlayer
onready var sprite = $SlashSprite
onready var weaponSprite = $WeaponSprite
onready var hitbox = $Hitbox
onready var sound = $Sound
onready var sound2 = $Sound2
onready var swingReset = $SwingReset

onready var current_swing_sound = sound

const weapon_name = "Sword"
const ammo = null
const knockback_amount = 250
const camera_shake = 40

signal give_knockback(direction, amount)
signal sword_damage_changed(multiple)

var isAttacking = false
var onFirstSwing:bool = true

func _ready():
	var player = get_parent().get_parent()
	connect("give_knockback", player, "change_knockback")
	PlayerStats.connect("guts_changed", self, "set_damage")
	set_damage(PlayerStats.guts)

func _process(delta):
	if !isAttacking:
		var mousePos = get_global_mouse_position()
		look_at(mousePos)

func handle_input():
	if Input.is_action_just_pressed("click"):
		attack()

func set_swing(value:bool):
	sprite.set_flip_v(value)

	if value:
		current_swing_sound = sound
		weaponSprite.rotation_degrees = 0
	else:
		current_swing_sound = sound2
		weaponSprite.rotation_degrees = 180

func attack():
	if PlayerStats.guts <= 0:
		$BreathSound.play()
		return
	if isAttacking == false:
		isAttacking = true
		
		var dir = (get_global_mouse_position() - global_position).normalized()
		hitbox.set_knockback_vector(dir)
		
		animationPlayer.play("attack")
		current_swing_sound.play()
		
		Globals.camera.shake(camera_shake, 0.1, 200)
		
#		emit_signal("give_knockback", dir, 0)
		emit_signal("give_knockback", dir, knockback_amount)
		
		onFirstSwing = !onFirstSwing
		set_swing(onFirstSwing)
		
#		guts
		PlayerStats.set_guts(PlayerStats.guts - 3)

func attack_animation_finished():
	isAttacking = false

func create_hit_effect():
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position
	

func set_visible(value:bool):
	weaponSprite.visible = value
	

func _on_Hitbox_area_entered(area):
	if area.is_in_group("enemy_bullet_hurtbox"):
		area.get_parent().queue_free()
	else:
		create_hit_effect()

func set_damage(guts):
	var multiple = (guts / PlayerStats.max_guts) + 1
	hitbox.damage = hitbox.base_damage * multiple
	emit_signal("sword_damage_changed", multiple)


func get_damage():
	return hitbox.damage


func get_damage_multiple():
	return (PlayerStats.guts / PlayerStats.max_guts) + 1
