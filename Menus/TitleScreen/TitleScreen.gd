extends Control


const game = preload("res://World/GeneratedWorld.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Start_pressed():
	get_tree().change_scene_to(game)


func _on_Quit_pressed():
	get_tree().quit()


func _on_Options_pressed():
	pass # Replace with function body.
