extends KinematicBody2D

onready var sprite = $Sprite

var direction = Vector2.ZERO
var velocity = Vector2.ZERO
const speed = 350


# Called when the node enters the scene tree for the first time.
func _ready():
#	var look_vec = to_local(direction)
#	look_at(look_vec)
#	look_at(direction)
#	look_at(velocity)
#	var angle = Vector2.ZERO.angle_to(direction)
#	set_rotation_degrees(angle) 
#	sprite.set_rotation_degrees(angle)
	var rotation = velocity.angle()
	rotation = rad2deg(rotation)
	set_rotation_degrees(rotation)
	pass


func init(new_direction:Vector2):
	direction = new_direction
	velocity = new_direction * speed
	


func _physics_process(delta):
	velocity = move_and_slide(velocity)
