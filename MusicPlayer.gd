extends AudioStreamPlayer

const Digital = preload("res://Assets/Music/Digital Milestones by Harris Heller.ogg")
const Lust = preload("res://Assets/Music/Lust by Harris Heller.ogg")
const Neon = preload("res://Assets/Music/Neon Thrills by LukHash.ogg")
const Rush = preload("res://Assets/Music/Rush by Harris Heller.ogg")
const Terminate = preload("res://Assets/Music/Terminate by Megahit.ogg")

var songs = [Digital, Lust, Neon, Rush, Terminate]
var current_song = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
#	load_songs()
	randomize()
	songs.shuffle()
	stream = songs[0]
	if autoplay == true:
		play()






#doesn't work
func load_songs():
	var path = "res://Assets/Music/"
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file_name = dir.get_next()
		if file_name == "":
			#break the while loop when get_next() returns ""
			break
		elif (!file_name.begins_with(".") ) and  !file_name.ends_with(".import") :
			#get_next() returns a string so this can be used to load the images into an array.
			songs.append(load(path + file_name))
	dir.list_dir_end()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_MusicPlayer_finished():
	if is_playing():
		next_song()


func next_song():
	current_song += 1
	if current_song >= songs.size():
		current_song = 0
	
	stream = songs[current_song]
	play()
