extends Node2D


var player
onready var removeTimer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	var world = get_tree().current_scene
	player = world.get_node("YSort/Player")
	
	removeTimer.connect("timeout", self, "remove_scent")
	removeTimer.start()
	
	add_to_group("scents")
	

func remove_scent():
  player.scent_trail.erase(self)
  queue_free()
