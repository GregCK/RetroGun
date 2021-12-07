extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_music_button_text():
	var isplaying = MusicPlayer.is_playing()
	var text = "Music: " + str(isplaying)
	$VBoxContainer/Music.set_text(text)




func _on_Music_pressed():
	MusicPlayer._set_playing(!MusicPlayer.is_playing())
	set_music_button_text()


func _on_Button_pressed():
	MusicPlayer.next_song()
