extends Node
class_name AdjustAngle

var rng = RandomNumberGenerator.new()

func ready():
	rng.randomize()

func randomly_rotate_vector(vec:Vector2):
	#	convert to radians and add a random adjustment to it
	var radians = vec.angle()
	var adjustment = rng.randfn(0.0, 0.15)
	radians += adjustment
#	convert back to a vector
	var adjusted_vector = Vector2(cos(radians), sin(radians))
	adjusted_vector = adjusted_vector.normalized()
	
	return adjusted_vector
