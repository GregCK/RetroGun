extends KinematicBody2D

var velocity = Vector2.ZERO
var direction = Vector2.ZERO
const speed = 200



func init(new_direction:Vector2):
	direction = new_direction
	velocity = new_direction * speed

func _physics_process(delta):
	velocity = move_and_slide(velocity)


func _on_Timer_timeout():
	queue_free()
