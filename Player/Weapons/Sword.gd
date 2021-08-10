extends Node2D

const HitEffect = preload("res://Effects/HitEffect.tscn")

onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite
onready var hitbox = $Hitbox
onready var sound = $Sound
onready var sound2 = $Sound2
onready var swingReset = $SwingReset

onready var current_swing_sound = sound

const weapon_name = "Sword"
const knockback_amount = 150
const camera_shake = 40

signal give_knockback(direction, amount)

var isAttacking = false
var onFirstSwing:bool = true

func _ready():
	var player = get_parent().get_parent()
	connect("give_knockback", player, "change_knockback")


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
	else:
		current_swing_sound = sound2

func attack():
	if isAttacking == false:
		isAttacking = true
		
		var dir = (get_global_mouse_position() - global_position).normalized()
		hitbox.set_knockback_vector(dir)
		
		animationPlayer.play("attack")
		current_swing_sound.play()
		
		Globals.camera.shake(camera_shake, 0.1, 200)
		
		emit_signal("give_knockback", dir, knockback_amount)
		
		onFirstSwing = !onFirstSwing
		set_swing(onFirstSwing)

func attack_animation_finished():
	isAttacking = false

func create_hit_effect():
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

func _on_Hitbox_area_entered(area):
	if area.is_in_group("enemy_bullet_hurtbox"):
		area.get_parent().queue_free()
	else:
		create_hit_effect()
