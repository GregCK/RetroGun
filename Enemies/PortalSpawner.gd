extends Node2D
class_name PortalSpawner

onready var Portal = preload("res://World/Portal.tscn")

var parent

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree(),"idle_frame")
	var enemies = get_tree().get_nodes_in_group("enemies").size()
	if enemies <= 0:
		spawn_portal()
	
	queue_free()


func set_world(w):
	parent = w

func spawn_portal():
	var portal = Portal.instance()
	portal.set_world(parent)
	parent.call_deferred("add_child", portal)
	portal.position = position
