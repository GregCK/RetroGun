extends KinematicBody2D

var velocity = Vector2.ZERO
var direction = Vector2.ZERO
const speed = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(0.08), "timeout")
	queue_free()


func init(new_direction:Vector2):
	direction = new_direction
	velocity = new_direction * speed

func _physics_process(delta):
	velocity = move_and_slide(velocity)
