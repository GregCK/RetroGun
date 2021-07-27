extends "res://Enemies/Enemy.gd"

onready var line2d = $Line2D


var speed : int = 40





func _ready():
	yield(get_tree(), "idle_frame")
	set_level_nav()
	softCollision = $SoftCollision
#	if tree.has_group("player"):
#		player = tree.get_nodes_in_group("player")[0]

func _physics_process(delta):
	line2d.global_position = Vector2.ZERO
	if player and levelNavigation:
		line2d.points = generate_path_to_player()
		navigate(speed)
		
	detect_softCollision(delta)
	
		
	move()


