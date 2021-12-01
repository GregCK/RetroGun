extends CanvasLayer

var paused = false


func _ready():
	$Control.hide()
	pause_mode = Node.PAUSE_MODE_PROCESS

func _input(event):
	if event.is_action_pressed("escape"):
		_on_pause_button_pressed()

func _on_pause_button_pressed():
	if !paused:
		set_pause(true)
	else:
		set_pause(false)


func set_pause(value:bool):
	if value:
		paused = true
		$Control.show()
		get_tree().paused = true
	else:
		paused = false
		$Control.hide()
		get_tree().paused = false

func _on_ResumeButton_pressed():
	get_tree().paused = false
	$Control.hide()
	


func _on_QuitButton_pressed():
	get_tree().quit()
