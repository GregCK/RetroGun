extends Position2D


onready var weapon = $Pistol
onready var firepoint = $Pistol/Firepoint


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("click"):
		var self_pos = get_global_position()
		var weapon_pos = firepoint.get_global_position()
		var direction = self_pos - weapon_pos
		weapon.attack(direction)
