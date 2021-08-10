extends Node2D


var sprite
var muzzleFlareSprite

var world
var player

func _ready():
	world = get_parent().get_parent().get_parent()
	player = get_parent().get_parent()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	set_rotations_and_flips()

func set_rotations_and_flips():
	var mousePos = get_global_mouse_position()
	look_at(mousePos)
	var isLeft = isFacingLeft()
	sprite.set_flip_v(isLeft)
	muzzleFlareSprite.set_flip_v(isLeft)

func isFacingLeft():
	var mousePos = get_global_mouse_position()
	var playePos = get_parent().get_global_position()
	if(mousePos != null && mousePos.x < playePos.x):
		return true
	else:
		return false
