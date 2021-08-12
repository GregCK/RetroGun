extends Node2D

onready var animationPlayer = $AnimationPlayer
const camera_shake = 300

# Called when the node enters the scene tree for the first time.
func _ready():
	animationPlayer.play("Explode")
	Globals.camera.shake(camera_shake, 0.1, 200)


func animation_finished():
	queue_free()
