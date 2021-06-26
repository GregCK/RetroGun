extends KinematicBody2D


var velocity = Vector2.ZERO
const speed = 350


# Called when the node enters the scene tree for the first time.
func _ready():
	look_at(velocity)


func init(direction:Vector2):
	velocity = direction * speed
	


func _physics_process(delta):
	velocity = move_and_slide(velocity)
