extends Node
class_name Walker

const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]

var position = Vector2.ZERO
var direction = Vector2.RIGHT
var borders = Rect2()
var step_history = []
var steps_since_turn = 0


func _init(starting_position, new_borders):
	assert(new_borders.has_point(starting_position))
	position = starting_position
	step_history.append(position)
#	add_pos(position)
	borders = new_borders


#may make a map smaller than steps amount of tiles because they may overlap
func walk(steps):
	create_room(position)
	for step in steps:
#		if randf() < 0.9 and steps_since_turn >= 20: #long hallways
		if randf() <= 0.7 and steps_since_turn >= 5:
			change_direction()
		
		if step():
#			step_history.append(position)
			add_pos(position)
		else:
			change_direction()
	return step_history

func step():
	var target_position = position + direction
	if borders.has_point(target_position):
		steps_since_turn += 1
		position = target_position
		return true
	else:
		return false

func change_direction():
	create_room(position)
	steps_since_turn = 0
	var directions = DIRECTIONS.duplicate()
	directions.erase(direction)
	directions.shuffle()
	direction = directions.pop_front()
	while not borders.has_point(position + direction):
		direction = directions.pop_front()


func create_room(position):
	var size = Vector2(randi() % 4 + 2, randi() % 4 + 2) #small rooms
#	var size = Vector2(randi() % 16 + 2, randi() % 16 + 2) #big rooms
	var top_left_corner = (position - size/2).ceil()
	for y in size.y:
		for x in size.x:
			var new_step = top_left_corner + Vector2(x, y)
			if borders.has_point(new_step):
#				step_history.append(new_step)
				add_pos(new_step)
	
	
func add_pos(pos):
	if step_history.has(pos):
		pass
	else:
		step_history.append(pos)
	
	
	
	
	
