extends "res://Enemies/Enemy.gd"

const Bullet = preload("res://Enemies/EnemyBullet.tscn")

onready var animationPlayer = $AnimationPlayer

const move_speed = 50
var move_dir


var rng



func _ready():
	rng = RandomNumberGenerator.new()
	var x = rng.randf_range(-1,1)
	var y = rng.randf_range(-1,1)
	move_dir = Vector2(x,y)
	velocity = move_dir * move_speed

func _physics_process(delta):
	move()
	if get_slide_count() != 0:
		var col = get_slide_collision(0)
		var normal = col.get_normal() 
		velocity = move_dir.bounce(normal) * move_speed
		move_dir = velocity.normalized()


func _on_ShootTimer_timeout():
	animationPlayer.play("fire")


func fire_bullets():
	for i in range(4):
		var bullet = Bullet.instance()
		var vec_to_shoot
		match i:
			0:
				vec_to_shoot = Vector2(0, -1)
			1:
				vec_to_shoot = Vector2(0, 1)
			2:
				vec_to_shoot = Vector2(-1, 0)
			3:
				vec_to_shoot = Vector2(1, 0)
				
		
		bullet.init(vec_to_shoot)
		bullet.set_global_position(get_global_position())
		get_parent().add_child(bullet)
	
	animationPlayer.play("default")
