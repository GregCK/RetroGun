extends Position2D


onready var pistol = $Pistol
onready var firepoint = $Pistol/Firepoint

onready var weapon = pistol


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("click"):
		var mouse_pos = get_global_mouse_position()
		var self_pos = get_global_position()
		var direction = mouse_pos - self_pos
		direction = direction.normalized()
		
		weapon.attack(direction)
