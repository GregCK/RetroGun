extends CanvasLayer

var paused = false


func _ready():
	$Control.hide()
	$Options.hide()
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
		$Options.hide()
		get_tree().paused = false

func _on_ResumeButton_pressed():
	resume()
	
func resume():
	get_tree().paused = false
	paused = false
	$Control.hide()


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_Options_pressed():
	$Control.hide()
	$Options.show()
	$Options.set_music_button_text()


func _on_Button_pressed():
	$Options.hide()
	$Control.show()


const titleScreen = preload("res://Menus/TitleScreen/TitleScreen.tscn")
func _on_TitleScreen_pressed():
	get_tree().change_scene_to(titleScreen)
	PlayerStats.reset_game_globals()
	resume()
