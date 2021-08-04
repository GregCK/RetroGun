extends Position2D

const Pistol = preload("res://Player/Weapons/Pistol.tscn")




var weapon


# Called when the node enters the scene tree for the first time.
func _ready():
	var pistol = Pistol.instance()
	add_child(pistol)
	weapon = pistol


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("click"):
		var mouse_pos = get_global_mouse_position()
		var self_pos = get_global_position()
		var direction = mouse_pos - self_pos
		direction = direction.normalized()
		
		weapon.attack(direction)

func _input(event):
	if event.is_action_pressed("click"):
		pass
