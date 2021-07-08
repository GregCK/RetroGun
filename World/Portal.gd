extends Area2D


signal leaving_level

var world = null



func _ready():
	connect("leaving_level", world, "reload_level")



func set_world(w):
	world = w




func _on_Portal_body_entered(body):
	emit_signal("leaving_level")
