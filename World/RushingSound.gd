extends AudioStreamPlayer





# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_playing():
		var current_pitch = get_pitch_scale()
		var new_pitch = current_pitch + 1
		set_pitch_scale(new_pitch)
