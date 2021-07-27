extends RayCast2D

var direction:Vector2
var step:Vector2
const step_amount = 32



# Called when the node enters the scene tree for the first time.
func _ready():
	direction = get_cast_to().normalized()
	step = direction * step_amount

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func get_points():
	var coll = get_collider ( )
	var coll_point = get_collision_point()
	var curr_point = get_global_position()
	
	var points = []
	while curr_point.length() * direction < coll_point.length() * direction:
		points.append(curr_point)
		curr_point += step
		
	
	return points
