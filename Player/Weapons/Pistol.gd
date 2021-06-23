extends Node2D

const Bullet = preload("res://Player/PlayerBullet.tscn")

onready var sprite = $Pistol
onready var firepoint = $Firepoint

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var mousePos = get_global_mouse_position()
	look_at(mousePos)
	sprite.set_flip_v(isFacingLeft())
	


func isFacingLeft():
	var mousePos = get_global_mouse_position()
	var playePos = get_parent().get_global_position()
	if(mousePos != null && mousePos.x < playePos.x):
		return true
	else:
		return false

func attack(direction:Vector2):
	var bullet = Bullet.instance()
	bullet.init(direction)
	bullet.position = firepoint.position
	
	
