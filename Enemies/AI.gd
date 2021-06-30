extends Node2D

signal state_changed(new_state)

onready var playerDetectionZone = $PlayerDetectionZone
var animationPlayer = null

enum State{
	PATROL,
	ENGAGE
}

var current_state : int = -1 setget set_state
var player : Player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	set_state(State.PATROL)




func _physics_process(delta):
	match current_state:
		State.PATROL:
			pass
		State.ENGAGE:
			pass

func set_state(new_state: int):
	if new_state == current_state:
		return
	
	current_state = new_state
	emit_signal("state_changed", current_state)


func _on_Area2D_area_entered(area):
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	pass # Replace with function body.


func _on_PlayerDetectionZone_body_entered(body):
	if body.is_in_group("player"):
		player = body
		set_state(State.ENGAGE)
