extends Area2D


signal leaving_level

onready var audio = $AudioStreamPlayer
onready var sprite = $AnimatedSprite
onready var collisionShape = $CollisionShape2D



var world = null



func _ready():
#	connect("leaving_level", world, "reload_level")
	connect("leaving_level", LevelSelector, "next_level")



func set_world(w):
	world = w




func _on_Portal_body_entered(body):
	emit_signal("leaving_level")


func _on_Timer_timeout():
	sprite.visible = true
	collisionShape.disabled = false
	audio.play()
