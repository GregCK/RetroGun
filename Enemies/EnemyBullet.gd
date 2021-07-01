extends KinematicBody2D


var direction : Vector2
var velocity : Vector2
const speed = 150


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func init(new_direction:Vector2):
	direction = new_direction
	velocity = new_direction * speed

func _physics_process(delta):
	velocity = move_and_slide(velocity)


func _on_Hitbox_area_entered(area):
	queue_free()
