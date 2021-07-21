extends "res://Enemies/Enemy.gd"

onready var line2d = $Line2D

var speed : int = 40


var path: Array = [] #contains destination points
var levelNavigation: Navigation2D = null


func _ready():
	yield(get_tree(), "idle_frame")
	var tree = get_tree()
	if tree.has_group("LevelNavigation"):
		levelNavigation = tree.get_nodes_in_group("LevelNavigation")[0]
	if tree.has_group("player"):
		player = tree.get_nodes_in_group("player")[0]

func _physics_process(delta):
	line2d.global_position = Vector2.ZERO
	if player and levelNavigation:
		generate_path()
		navigate()
	move()

func navigate():
	if path.size() > 0:
		velocity = global_position.direction_to(path[1]) * speed
		pass
	
#	if reached destination, remove point from path
	if global_position == path[0]:
		path.pop_front()

func generate_path():
	if levelNavigation != null and player != null:
		path = levelNavigation.get_simple_path(global_position, player.global_position, false)
		line2d.points = path

func move():
	velocity = move_and_slide(velocity)
