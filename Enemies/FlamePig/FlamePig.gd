extends "res://Enemies/Enemy.gd"


onready var animationPlayer = $AnimationPlayer
onready var stateLabel = $StateLabel
onready var seeLabel = $SeeLabel

enum State{
	IDLE,
	ALIGN,
	CHARGE
}


var current_state : int = -1 setget set_state

func _ready():
	playerCast = $PlayerCast
	set_state(State.IDLE)


func _physics_process(delta):
	seeLabel.text = str(can_see_player())
	match current_state:
		State.IDLE:
			if can_see_player():
				set_state(State.ALIGN)
		State.ALIGN:
			pass
		State.CHARGE:
			pass



func set_state(new_state: int):
	if new_state == current_state:
		return
	match new_state:
		State.IDLE:
			stateLabel.text = "IDLE"
			animationPlayer.play("idle")
		State.ALIGN:
			stateLabel.text = "ALIGN"
			animationPlayer.play("idle")
		State.CHARGE:
			stateLabel.text = "CHARGE"
			animationPlayer.play("charge")
	
	current_state = new_state
	emit_signal("state_changed", current_state)
