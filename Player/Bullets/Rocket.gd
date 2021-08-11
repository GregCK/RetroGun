extends KinematicBody2D

onready var hitbox = $Hitbox
onready var explosionCreator = $ExplosionCreator

var world
var direction = Vector2.ZERO
var velocity = Vector2.ZERO
const speed = 500


func _ready():
	var rotation = velocity.angle()
	rotation = rad2deg(rotation)
	set_rotation_degrees(rotation)

	hitbox.set_knockback_vector(velocity)

	world = get_parent()


func init(new_direction:Vector2):
	direction = new_direction
	velocity = new_direction * speed


func _physics_process(delta):
	velocity = move_and_slide(velocity)
	if get_slide_count() != 0:
		explosionCreator.create_explosion_effect()
		queue_free()


func _on_Hitbox_area_entered(area):
	explosionCreator.create_explosion_effect()
	queue_free()
