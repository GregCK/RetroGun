extends Area2D


signal leaving_level
signal portal_activated

onready var audio = $AudioStreamPlayer
onready var rushing = $RushingSound
onready var sprite = $AnimatedSprite
onready var collisionShape = $CollisionShape2D
onready var sceneChangeDelayTimer = $SceneChangeDelay


var world = null

var player

func _ready():
#	connect("leaving_level", world, "reload_level")
	connect("leaving_level", LevelSelector, "next_level")
	
	
	
	
	player = get_parent().get_node("Player")
	
	connect("portal_activated", player, "set_portal")
	
	pass



func set_world(w):
	world = w




var is_rushing = false
func _on_Portal_body_entered(body):
	emit_signal("portal_activated")
	sceneChangeDelayTimer.start()
	rushing.play()


func _on_Timer_timeout():
	sprite.visible = true
	collisionShape.disabled = false
	audio.play()


func _on_SceneChangeDelay_timeout():
	emit_signal("leaving_level")
