extends KinematicBody2D

onready var sprite = $Sprite


const DeathEffect = preload("res://Effects/BulletEffect.tscn")

var direction = Vector2.ZERO
var velocity = Vector2.ZERO
const speed = 350

var world
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var rotation = velocity.angle()
	rotation = rad2deg(rotation)
	set_rotation_degrees(rotation)
	
	world = get_parent()
	rng.randomize()


func init(new_direction:Vector2):
	direction = new_direction
	velocity = new_direction * speed
	


func _physics_process(delta):
	velocity = move_and_slide(velocity)
	if get_slide_count() != 0:
		for i in range(3):
			create_death_effect()
		
		queue_free()

func create_death_effect():
		var deathEffect = DeathEffect.instance()
		world.add_child(deathEffect)
		
		var col = get_slide_collision(0)
		var normal = col.get_normal() 
		var dir = direction.bounce(normal)
		
		var spread = 0.6
		dir.x += rng.randf_range(-spread, spread)
		dir.y += rng.randf_range(-spread, spread)
		
		deathEffect.init(dir)
		deathEffect.set_global_position(col.get_position() )
		
