extends Node2D


const PointSprite = preload("res://PointSprite.tscn")

onready var rayCast0 = $RayCast0
onready var rayCast1 = $RayCast1
onready var rayCast2 = $RayCast2
onready var rayCast3 = $RayCast3
onready var rayCast4 = $RayCast4
onready var rayCast5 = $RayCast5
onready var rayCast6 = $RayCast6
onready var rayCast7 = $RayCast7

onready var raycasts = [rayCast0,rayCast1,rayCast2,rayCast3,rayCast4,rayCast5,rayCast6,rayCast7]

var player
var world

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent()
	world = player.get_parent()
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	draw_points()
	pass


func draw_points():
	var pointslist = get_points()
	for points in pointslist:
		for point in points:
			var pointSprite = PointSprite.instance()
			world.call_deferred("add_child",pointSprite)
		#	var position = self.get_global_transform()
			var position = point
#			pointSprite.set_global_transform(position)
			pointSprite.set_global_position(position)

func get_points():
	var points = []
	for raycast in raycasts:
		var new_points = raycast.get_points()
		points.append(new_points)
	return points
